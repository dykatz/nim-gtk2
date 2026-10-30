# Included by headers/atk.nim; do not import directly.
type
  PObject* = ptr TObject
  TObject* = object of TGObject
    description*: cstring
    name*: cstring
    accessible_parent*: PObject
    role*: TRole
    relation_set*: PRelationSet
    layer*: TLayer

  PPAtkObject* = ptr PObject
  TImplementorIface* = object of TGTypeInterface
    ref_accessible*: proc (implementor: PImplementor): PObject{.cdecl.}

  PImplementorIface* = ptr TImplementorIface
