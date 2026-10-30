# Included by headers/glib2.nim; do not import directly.
proc g_object_new*(object_type: GType, first_property_name: cstring): PGObject {.
  cdecl, varargs, dynlib: gobjectlib, importc.}
