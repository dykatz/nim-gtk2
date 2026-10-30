# Included by headers/atk.nim; do not import directly.
type
  TRelationSet* = object of TGObject
    relations*: PGPtrArray

  PRelationSet* = ptr TRelationSet
  TRelationSetClass* = object of TGObjectClass
    pad19*: TFunction
    pad20*: TFunction

  PRelationSetClass* = ptr TRelationSetClass
