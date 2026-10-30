# Included by headers/gtk2.nim; do not import directly.
type
  TArg*{.final, pure.} = object
    `type`*: TType
    name*: cstring
    d*: gdouble               # was a union type

  PArg* = ptr TArg
  TTypeInfo*{.final, pure.} = object
    type_name*: cstring
    object_size*: guint
    class_size*: guint
    class_init_func*: pointer #TGtkClassInitFunc
    object_init_func*: pointer #TGtkObjectInitFunc
    reserved_1*: gpointer
    reserved_2*: gpointer
    base_class_init_func*: pointer #TGtkClassInitFunc

  PTypeInfo* = ptr TTypeInfo
