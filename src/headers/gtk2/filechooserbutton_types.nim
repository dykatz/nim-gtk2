# Included by headers/gtk2.nim; do not import directly.
type
  TFileChooserButtonPrivate* {.final, pure, incompleteStruct.} = object
  PFileChooserButtonPrivate* = ptr TFileChooserButtonPrivate
  TFileChooserButton* = object of THBox
    priv*: PFileChooserButtonPrivate
  PFileChooserButton* = ptr TFileChooserButton
  TFileChooserButtonClass* = object of THBoxClass
    file_set*: proc (fc: PFileChooserButton) {.cdecl.}
    reserved: array[7, pointer]
  PFileChooserButtonClass* = ptr TFileChooserButtonClass
