# Included by headers/glib2.nim; do not import directly.
type
  GType* = gsize
  PGType* = ptr GType
  TGTypeClass*{.final.} = object
    g_type*: GType

  PGTypeClass* = ptr TGTypeClass
  TGTypeInstance*{.final.} = object
    g_class*: PGTypeClass

  PGTypeInstance* = ptr TGTypeInstance
  TGTypeInterface*{.pure, inheritable.} = object
    g_type*: GType
    g_instance_type*: GType

  PGTypeInterface* = ptr TGTypeInterface
  TGTypeQuery*{.final.} = object
    theType*: GType
    type_name*: cstring
    class_size*: guint
    instance_size*: guint

  PGTypeQuery* = ptr TGTypeQuery
