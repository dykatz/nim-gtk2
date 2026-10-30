# Included by headers/glib2.nim; do not import directly.
type
  TGObjectGetPropertyFunc* = proc (anObject: PGObject, property_id: guint,
                                   value: PGValue, pspec: PGParamSpec){.cdecl.}
  TGObjectSetPropertyFunc* = proc (anObject: PGObject, property_id: guint,
                                   value: PGValue, pspec: PGParamSpec){.cdecl.}
  TGObjectFinalizeFunc* = proc (anObject: PGObject){.cdecl.}
  TGWeakNotify* = proc (data: gpointer, where_the_object_was: PGObject){.cdecl.}
