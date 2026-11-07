# Included by gtk2.nim. Native editing/display policy, never private flag writes.
proc overwriteMode*(entry: Entry): bool = g.toBool(rawGtk.get_overwrite_mode(entry.raw))
proc `overwriteMode=`*(entry: Entry, value: bool) =
  let p = entry.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_overwrite_mode(p, g.gbool(value))
proc hasFrame*(entry: Entry): bool = g.toBool(rawGtk.get_has_frame(entry.raw))
proc `hasFrame=`*(entry: Entry, value: bool) =
  let p = entry.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_has_frame(p, g.gbool(value))
proc invisibleChar*(entry: Entry): uint32 = rawGtk.get_invisible_char(entry.raw).uint32
proc invisibleCharSet*(entry: Entry): bool = booleanProperty(entry, "invisible-char-set")
proc `invisibleChar=`*(entry: Entry, value: uint32) =
  let p = entry.raw
  # Zero is GTK's explicit no-feedback policy, not an invalid text terminator.
  # Noncharacters are Unicode scalars; surrogates and out-of-range values are not.
  if value > 0x10ffff'u32 or value in 0xd800'u32..0xdfff'u32:
    raise newException(ValueError, "invisibleChar must be zero or a Unicode scalar")
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_invisible_char(p, g.gunichar(value))
proc unsetInvisibleChar*(entry: Entry) =
  let p = entry.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.unset_invisible_char(p)
