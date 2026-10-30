# Included by headers/gtk2.nim; do not import directly.
const
  DIALOG_MODAL* = cint(1 shl 0)
const
  DIALOG_DESTROY_WITH_PARENT* = cint(1 shl 1)
const
  DIALOG_NO_SEPARATOR* = cint(1 shl 2)
const
  RESPONSE_NONE* = - cint(1)
const
  RESPONSE_REJECT* = - cint(2)
const
  RESPONSE_ACCEPT* = - cint(3)
const
  RESPONSE_DELETE_EVENT* = - cint(4)
const
  RESPONSE_OK* = - cint(5)
const
  RESPONSE_CANCEL* = cint(-6)
const
  RESPONSE_CLOSE* = - cint(7)
const
  RESPONSE_YES* = - cint(8)
const
  RESPONSE_NO* = - cint(9)
const
  RESPONSE_APPLY* = - cint(10)
const
  RESPONSE_HELP* = - cint(11)

proc TYPE_DIALOG*(): GType
proc DIALOG*(obj: pointer): PDialog
proc DIALOG_CLASS*(klass: pointer): PDialogClass
proc IS_DIALOG*(obj: pointer): bool
proc IS_DIALOG_CLASS*(klass: pointer): bool
proc DIALOG_GET_CLASS*(obj: pointer): PDialogClass
proc dialog_get_type*(): TType{.cdecl, dynlib: lib,
                                importc: "gtk_dialog_get_type".}
proc dialog_new*(): PDialog{.cdecl, dynlib: lib, importc: "gtk_dialog_new".}
proc get_content_area*(dialog: PDialog): PWidget {.cdecl, dynlib: lib,
    importc: "gtk_dialog_get_content_area".}
proc get_action_area*(dialog: PDialog): PWidget {.cdecl, dynlib: lib,
    importc: "gtk_dialog_get_action_area".}
proc add_action_widget*(dialog: PDialog, child: PWidget,
                               response_id: gint){.cdecl, dynlib: lib,
    importc: "gtk_dialog_add_action_widget".}
proc add_button*(dialog: PDialog, button_text: cstring, response_id: gint): PWidget{.
    cdecl, dynlib: lib, importc: "gtk_dialog_add_button".}
proc set_response_sensitive*(dialog: PDialog, response_id: gint,
                                    setting: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_dialog_set_response_sensitive".}
proc set_default_response*(dialog: PDialog, response_id: gint){.cdecl,
    dynlib: lib, importc: "gtk_dialog_set_default_response".}
proc set_has_separator*(dialog: PDialog, setting: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_dialog_set_has_separator".}
proc get_has_separator*(dialog: PDialog): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_dialog_get_has_separator".}
proc response*(dialog: PDialog, response_id: gint){.cdecl, dynlib: lib,
    importc: "gtk_dialog_response".}
proc run*(dialog: PDialog): gint{.cdecl, dynlib: lib,
    importc: "gtk_dialog_run".}
