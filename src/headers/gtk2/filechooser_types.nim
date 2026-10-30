# Included by headers/gtk2.nim; do not import directly.
type
  TFileChooserAction* = enum
    FILE_CHOOSER_ACTION_OPEN, FILE_CHOOSER_ACTION_SAVE,
    FILE_CHOOSER_ACTION_SELECT_FOLDER, FILE_CHOOSER_ACTION_CREATE_FOLDER
  PFileChooserAction* = ptr TFileChooserAction
  TFileChooserError* = enum
    FILE_CHOOSER_ERROR_NONEXISTENT, FILE_CHOOSER_ERROR_BAD_FILENAME

  PFileChooserError* = ptr TFileChooserError
  TFileChooser = object of TDialog
  PFileChooser* = ptr TFileChooser
  PPFileChooser* = ptr PFileChooser

