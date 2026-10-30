# Included by headers/atk.nim; do not import directly.
type
  TGObjectAccessibleClass* = object of TObjectClass
    pad5*: TFunction
    pad6*: TFunction

  PGObjectAccessibleClass* = ptr TGObjectAccessibleClass
