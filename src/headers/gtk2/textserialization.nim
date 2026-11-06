# Included by headers/gtk2.nim. GTK 2.10+ public rich-text APIs.
type
  TTextBufferSerializeFunc* = proc (registerBuffer, contentBuffer: PTextBuffer,
    first, last: PTextIter, length: ptr gsize, data: pointer): ptr guint8 {.cdecl.}
  TTextBufferDeserializeFunc* = proc (registerBuffer, contentBuffer: PTextBuffer,
    iter: PTextIter, bytes: ptr guint8, length: gsize, createTags: gboolean,
    data: pointer, error: ptr ptr GError): gboolean {.cdecl.}
proc register_serialize_format*(buffer: PTextBuffer, mimeType: cstring,
    fn: TTextBufferSerializeFunc, data: pointer, destroy: TGDestroyNotify): gdk2.TAtom
    {.cdecl, dynlib: lib, importc: "gtk_text_buffer_register_serialize_format".}
proc register_deserialize_format*(buffer: PTextBuffer, mimeType: cstring,
    fn: TTextBufferDeserializeFunc, data: pointer, destroy: TGDestroyNotify): gdk2.TAtom
    {.cdecl, dynlib: lib, importc: "gtk_text_buffer_register_deserialize_format".}
proc register_serialize_tagset*(buffer: PTextBuffer, name: cstring): gdk2.TAtom
    {.cdecl, dynlib: lib, importc: "gtk_text_buffer_register_serialize_tagset".}
proc register_deserialize_tagset*(buffer: PTextBuffer, name: cstring): gdk2.TAtom
    {.cdecl, dynlib: lib, importc: "gtk_text_buffer_register_deserialize_tagset".}
proc unregister_serialize_format*(buffer: PTextBuffer, format: gdk2.TAtom)
    {.cdecl, dynlib: lib, importc: "gtk_text_buffer_unregister_serialize_format".}
proc unregister_deserialize_format*(buffer: PTextBuffer, format: gdk2.TAtom)
    {.cdecl, dynlib: lib, importc: "gtk_text_buffer_unregister_deserialize_format".}
proc deserialize_set_can_create_tags*(buffer: PTextBuffer, format: gdk2.TAtom, allowed: gboolean)
    {.cdecl, dynlib: lib, importc: "gtk_text_buffer_deserialize_set_can_create_tags".}
proc deserialize_get_can_create_tags*(buffer: PTextBuffer, format: gdk2.TAtom): gboolean
    {.cdecl, dynlib: lib, importc: "gtk_text_buffer_deserialize_get_can_create_tags".}
proc get_serialize_formats*(buffer: PTextBuffer, count: ptr gint): ptr gdk2.TAtom
    {.cdecl, dynlib: lib, importc: "gtk_text_buffer_get_serialize_formats".}
proc get_deserialize_formats*(buffer: PTextBuffer, count: ptr gint): ptr gdk2.TAtom
    {.cdecl, dynlib: lib, importc: "gtk_text_buffer_get_deserialize_formats".}
proc text_buffer_serialize*(registerBuffer, contentBuffer: PTextBuffer, format: gdk2.TAtom,
    first, last: PTextIter, length: ptr gsize): ptr guint8
    {.cdecl, dynlib: lib, importc: "gtk_text_buffer_serialize".}
proc text_buffer_deserialize*(registerBuffer, contentBuffer: PTextBuffer, format: gdk2.TAtom,
    iter: PTextIter, bytes: ptr guint8, length: gsize, error: ptr ptr GError): gboolean
    {.cdecl, dynlib: lib, importc: "gtk_text_buffer_deserialize".}
