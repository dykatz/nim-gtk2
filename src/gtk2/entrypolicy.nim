# Included by gtk2.nim. Public GTK policies, not private GtkEntry bitfields.
proc maxLength*(entry: Entry): int = rawGtk.get_max_length(entry.raw).int
proc `maxLength=`*(entry: Entry, value: int) =
  let p = entry.raw
  if value < 0 or value > 65535:
    raise newException(ValueError, "entry maxLength must be in 0..65535 (0 means native default limit)")
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  let parent = rawGtk.get_parent(cast[rawGtk.PWidget](p))
  let combo = if parent != nil and g.G_TYPE_CHECK_INSTANCE_TYPE(parent, rawGtk.combo_box_get_type()): parent else: nil
  if combo != nil: discard g.g_object_ref(combo)
  defer:
    if combo != nil: g.g_object_unref(combo)
  let previous = g.get_data(cast[g.PGObject](p), entryPolicyDeferredKey)
  let previousCombo = if combo != nil: g.get_data(cast[g.PGObject](combo), entryPolicyDeferredKey) else: nil
  g.set_data(cast[g.PGObject](p), entryPolicyDeferredKey, cast[pointer](1))
  if combo != nil: g.set_data(cast[g.PGObject](combo), entryPolicyDeferredKey, cast[pointer](1))
  defer:
    g.set_data(cast[g.PGObject](p), entryPolicyDeferredKey, previous)
    if combo != nil: g.set_data(cast[g.PGObject](combo), entryPolicyDeferredKey, previousCombo)
  # GtkEntryBuffer truncates/emits changed BEFORE storing its new max-length.
  # Cancel stale SDK completion work; defer SDK entry/combo observations so they
  # see the committed limit and cannot tear down the native buffer mid-setter.
  prepareEntrySelection(p)
  rawGtk.set_max_length(p, g.gint(value))
proc widthChars*(entry: Entry): int = rawGtk.get_width_chars(entry.raw).int
proc `widthChars=`*(entry: Entry, value: int) =
  let p = entry.raw
  if value < -1 or value > high(g.gint).int:
    raise newException(ValueError, "entry widthChars must be -1 or a nonnegative gint")
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_width_chars(p, g.gint(value))
proc alignment*(entry: Entry): float64 = rawGtk.get_alignment(entry.raw).float64
proc `alignment=`*(entry: Entry, value: float64) =
  let p = entry.raw
  let checked = unitInterval(value)
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_alignment(p, g.gfloat(checked))
proc activatesDefault*(entry: Entry): bool = g.toBool(rawGtk.get_activates_default(entry.raw))
proc `activatesDefault=`*(entry: Entry, value: bool) =
  let p = entry.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_activates_default(p, g.gbool(value))
