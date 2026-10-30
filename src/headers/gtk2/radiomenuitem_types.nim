# Included by headers/gtk2.nim; do not import directly.
type
  TRadioMenuItem* = object of TCheckMenuItem
    group*: PGSList

  PRadioMenuItem* = ptr TRadioMenuItem
