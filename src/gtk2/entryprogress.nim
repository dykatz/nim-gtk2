# Included by gtk2.nim. No timer, activity shadow state or event pumping.
proc progressFraction*(entry: Entry): float64 = rawGtk.get_progress_fraction(entry.raw)
proc `progressFraction=`*(entry: Entry, value: float64) =
  let p = entry.raw
  let checked = unitInterval(value)
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_progress_fraction(p, checked)
proc progressPulseStep*(entry: Entry): float64 = rawGtk.get_progress_pulse_step(entry.raw)
proc `progressPulseStep=`*(entry: Entry, value: float64) =
  let p = entry.raw
  let checked = unitInterval(value)
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_progress_pulse_step(p, checked)
proc progressPulse*(entry: Entry) =
  let p = entry.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.entry_progress_pulse(p)
