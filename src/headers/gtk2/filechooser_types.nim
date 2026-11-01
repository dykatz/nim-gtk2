# Included by headers/gtk2.nim; do not import directly.
type
  TFileChooserAction* {.size: sizeof(cint).} = enum
    FILE_CHOOSER_ACTION_OPEN, FILE_CHOOSER_ACTION_SAVE,
    FILE_CHOOSER_ACTION_SELECT_FOLDER, FILE_CHOOSER_ACTION_CREATE_FOLDER
  PFileChooserAction* = ptr TFileChooserAction
  TFileChooserError* {.size: sizeof(cint).} = enum
    FILE_CHOOSER_ERROR_NONEXISTENT, FILE_CHOOSER_ERROR_BAD_FILENAME,
    FILE_CHOOSER_ERROR_ALREADY_EXISTS, FILE_CHOOSER_ERROR_INCOMPLETE_HOSTNAME

  PFileChooserError* = ptr TFileChooserError
  TFileChooserDialog {.pure, final, incompleteStruct.} = object
  PFileChooserDialog* = ptr TFileChooserDialog
  TFileChooser {.pure, final, incompleteStruct.} = object
  PFileChooser* = ptr TFileChooser
  PPFileChooser* = ptr PFileChooser

