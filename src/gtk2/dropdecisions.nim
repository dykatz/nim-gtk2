# Asynchronous application decisions after receipt of a validated COPY payload.
template monotonicDropTime(): int64 = g.g_get_monotonic_time()
type
  DropDecision* = object
    state: DropDecisionState
  DeferredDropHandler*[T] = proc (value: T, decision: DropDecision) {.closure.}
  DropDecisionState = ref object
    context: rawGdk.PDragContext
    pad: rawGtk.PWidget
    time: uint32
    deadline: int64
    idle, timer: g.guint
    notify: proc (decision: DropDecision) {.closure.}
    complete: proc (accepted: bool) {.closure.}

proc pending*(decision: DropDecision): bool =
  decision.state != nil and decision.state.context != nil

proc resolveDrop(s: DropDecisionState, accept: bool): bool =
  if s == nil or s.context == nil: return false
  let context = s.context
  let pad = s.pad
  s.context = nil # Consume before removing sources or delivering native finish.
  s.pad = nil
  defer:
    g.g_object_unref(context)
    g.g_object_unref(pad)
  let idle = s.idle
  let timer = s.timer
  s.idle = 0
  s.timer = 0
  if idle != 0: discard g.g_source_remove(idle)
  if timer != 0: discard g.g_source_remove(timer)
  s.notify = nil
  let complete = move(s.complete)
  result = accept and monotonicDropTime() < s.deadline and
    rawGdk.drag_context_get_selected_action(context) == rawGdk.ACTION_COPY
  rawGtk.drag_finish(context, g.gbool(result), g.gbool(false), g.guint32(s.time))
  complete(result)

proc accept*(decision: DropDecision): bool {.discardable.} =
  ## True if this call chose native success, not an acknowledgment from the source.
  requireOutsideModelFunction()
  resolveDrop(decision.state, true)

proc reject*(decision: DropDecision) =
  requireOutsideModelFunction()
  discard resolveDrop(decision.state, false)

proc releaseDropDecision(data: pointer) {.cdecl.} = GC_unref(cast[DropDecisionState](data))

proc idleDropDecision(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[DropDecisionState](data)
    if modelFunctionDepth != 0: return g.gbool(true)
    s.idle = 0
    try:
      if monotonicDropTime() >= s.deadline:
        discard resolveDrop(s, false)
      else:
        let notify = move(s.notify)
        notify(DropDecision(state: s))
    except Exception as error:
      reportSignalError(error)
      discard resolveDrop(s, false)
    g.gbool(false)

proc timeoutDropDecision(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[DropDecisionState](data)
    if modelFunctionDepth != 0: return g.gbool(true)
    s.timer = 0
    discard resolveDrop(s, false)
    g.gbool(false)

proc checkDropDecisionTimeout(timeoutMs: int) =
  if timeoutMs notin 1..5000:
    raise newException(ValueError, "drop decision timeout must be in 1..5000 ms")

proc startDropDecision(context: rawGdk.PDragContext, pad: rawGtk.PWidget, time: uint32,
                       timeoutMs: int, notify: proc (decision: DropDecision) {.closure.},
                       complete: proc (accepted: bool) {.closure.}): DropDecision =
  let s = DropDecisionState(context: cast[rawGdk.PDragContext](g.g_object_ref(context)),
    pad: cast[rawGtk.PWidget](g.g_object_ref(pad)), time: time,
    deadline: monotonicDropTime() + timeoutMs.int64 * 1000, notify: notify, complete: complete)
  GC_ref(s)
  s.timer = g.g_timeout_add_full(g.G_PRIORITY_DEFAULT, g.guint(timeoutMs),
    cast[pointer](timeoutDropDecision), cast[pointer](s), cast[pointer](releaseDropDecision))
  GC_ref(s)
  s.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE,
    cast[pointer](idleDropDecision), cast[pointer](s), cast[pointer](releaseDropDecision))
  DropDecision(state: s)

template finishPadDrop(site, packet, valid, value, policyValue: untyped) =
  if not packet.finished:
    packet.finished = true
    if valid and site.active and site.deferred != nil:
      let handler = site.deferred
      let input = policyValue
      let delivered = value
      site.decision = startDropDecision(packet.context, packet.widget, packet.time, site.timeoutMs,
        proc (decision: DropDecision) = handler(input, decision),
        proc (accepted: bool) =
          site.decision = DropDecision()
          if accepted and site.active: queueRecent(cast[pointer](site.queue), delivered))
    else:
      rawGtk.drag_finish(packet.context, g.gbool(valid), g.gbool(false), g.guint32(packet.time))
      if valid and site.active: queueRecent(cast[pointer](site.queue), value)
