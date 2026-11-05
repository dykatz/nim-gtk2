# Included by gtk2.nim. Native radio groups; no fabricated private group state.
proc raw*(a: RadioAction): rawGtk.PRadioAction = cast[rawGtk.PRadioAction](nativePointer(a))
proc asRadioAction*(a: Action): RadioAction =
  if not g.G_TYPE_CHECK_INSTANCE_TYPE(a.raw, rawGtk.radio_action_get_type()):
    raise newException(ValueError, "action is not a radio action")
  result.state = a.state
proc radioValue(p: rawGtk.PRadioAction): int32 =
  var value = typedProperty(p, "value")
  defer: g.unset(addr value)
  g.get_property(cast[g.PGObject](p), "value", addr value)
  int32(g.get_int(addr value))
proc value*(a: RadioAction): int32 = radioValue(a.raw)
proc newRadioAction*(name, label: string, value: int32, tooltip = ""): RadioAction =
  let n = commandName(name)
  let l = checkedUtf8Text(label)
  let t = checkedUtf8Text(tooltip)
  result.state = adoptObject(rawGtk.radio_action_new(n, l, t, nil, g.gint(value)),
    cache = true, hasDestroySignal = false, sink = false)
  rawGtk.radio_action_set_group(result.raw, nil) # Singleton groups start selected.
proc joinGroup*(a: RadioAction, peer: RadioAction) =
  let p = a.raw
  var target = rawGtk.radio_action_get_group(peer.raw)
  if target == nil:
    rawGtk.radio_action_set_group(peer.raw, nil)
    target = rawGtk.radio_action_get_group(peer.raw)
  let previous = rawGtk.radio_action_get_group(p)
  if previous == target: return
  var node = target
  while node != nil:
    if radioValue(cast[rawGtk.PRadioAction](node.data)) == a.value:
      raise newException(ValueError, "radio action values must be unique within a group")
    node = node.next
  # Preserve a selected member in the old group when moving its selection out.
  if a.active:
    node = previous
    while node != nil:
      if node.data != cast[pointer](p):
        rawGtk.toggle_action_set_active(cast[rawGtk.PToggleAction](node.data), g.gbool(true))
        break
      node = node.next
  rawGtk.radio_action_set_group(p, target)
  # Native set_group alone can leave two selected members. The active setter
  # bypasses sensitivity and lets the native radio class normalize the joiner.
  if a.active: rawGtk.toggle_action_set_active(cast[rawGtk.PToggleAction](p), g.gbool(false))
proc newRadioAction*(peer: RadioAction, name, label: string, value: int32, tooltip = ""): RadioAction =
  result = newRadioAction(name, label, value, tooltip)
  result.joinGroup(peer)
proc currentValue*(a: RadioAction): int32 = int32(rawGtk.radio_action_get_current_value(a.raw))
proc `currentValue=`*(a: RadioAction, value: int32) =
  var node = rawGtk.radio_action_get_group(a.raw)
  if node == nil and a.value == value:
    rawGtk.radio_action_set_current_value(a.raw, g.gint(value))
    return
  while node != nil:
    if radioValue(cast[rawGtk.PRadioAction](node.data)) == value:
      rawGtk.radio_action_set_current_value(a.raw, g.gint(value))
      return
    node = node.next
  raise newException(ValueError, "no radio action has this value")
proc radioChangedThunk(instance: pointer, current: rawGtk.PRadioAction, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      if current != nil: queueRecent(data, radioValue(current))
    except Exception as error: reportSignalError(error)
proc onChanged*(a: RadioAction, fn: proc (value: int32) {.closure.}): Connection {.discardable.} =
  connectRecent(a, "changed", fn, cast[g.TGCallback](radioChangedThunk))
