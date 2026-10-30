# Included by headers/atk.nim; do not import directly.
type
  TObjectFactoryClass* = object of TGObjectClass
    create_accessible*: proc (obj: PGObject): PObject{.cdecl.}
    invalidate*: proc (factory: PObjectFactory){.cdecl.}
    get_accessible_type*: proc (): GType{.cdecl.}
    pad17*: TFunction
    pad18*: TFunction

  PObjectFactoryClass* = ptr TObjectFactoryClass
