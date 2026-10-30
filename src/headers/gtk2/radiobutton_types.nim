# Included by headers/gtk2.nim; do not import directly.
type
  TRadioButton* = object of TCheckButton
    group*: PGSList

  PRadioButton* = ptr TRadioButton
