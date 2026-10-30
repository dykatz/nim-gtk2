# Included by headers/gtk2.nim; do not import directly.
type
  TObjectClass* = object of TGObjectClass
    set_arg*: proc (anObject: PObject, arg: PArg, arg_id: guint){.cdecl.}
    get_arg*: proc (anObject: PObject, arg: PArg, arg_id: guint){.cdecl.}
    destroy*: proc (anObject: PObject){.cdecl.}

  PObjectClass* = ptr TObjectClass
