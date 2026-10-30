# Included by headers/atk.nim; do not import directly.
type
  TRelation* = object of TGObject
    target*: PGPtrArray
    relationship*: TRelationType

  PRelation* = ptr TRelation
  TRelationClass* = object of TGObjectClass
  PRelationClass* = ptr TRelationClass
