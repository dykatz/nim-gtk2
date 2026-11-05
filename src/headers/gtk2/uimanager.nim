# GTK2.24 public radio action and UIManager APIs; GTK3 deprecation is irrelevant.
type
  TRadioAction* {.pure, final, incompleteStruct.} = object
  PRadioAction* = ptr TRadioAction
  TUIManager* {.pure, final, incompleteStruct.} = object
  PUIManager* = ptr TUIManager
  TUIManagerItemType* {.size: sizeof(cint).} = enum
    UI_MANAGER_AUTO = 0, UI_MANAGER_MENUBAR = 1, UI_MANAGER_MENU = 2,
    UI_MANAGER_TOOLBAR = 4, UI_MANAGER_PLACEHOLDER = 8, UI_MANAGER_POPUP = 16,
    UI_MANAGER_MENUITEM = 32, UI_MANAGER_TOOLITEM = 64, UI_MANAGER_SEPARATOR = 128,
    UI_MANAGER_ACCELERATOR = 256, UI_MANAGER_POPUP_WITH_ACCELS = 512
proc radio_action_get_type*(): GType {.cdecl, dynlib: lib, importc: "gtk_radio_action_get_type".}
proc radio_action_new*(name, label, tooltip, stock: cstring, value: gint): PRadioAction {.cdecl, dynlib: lib, importc: "gtk_radio_action_new".}
proc radio_action_get_group*(action: PRadioAction): PGSList {.cdecl, dynlib: lib, importc: "gtk_radio_action_get_group".}
proc radio_action_set_group*(action: PRadioAction, group: PGSList) {.cdecl, dynlib: lib, importc: "gtk_radio_action_set_group".}
proc radio_action_get_current_value*(action: PRadioAction): gint {.cdecl, dynlib: lib, importc: "gtk_radio_action_get_current_value".}
proc radio_action_set_current_value*(action: PRadioAction, value: gint) {.cdecl, dynlib: lib, importc: "gtk_radio_action_set_current_value".}
proc action_set_accel_group*(action: PAction, group: PAccelGroup) {.cdecl, dynlib: lib, importc: "gtk_action_set_accel_group".}
proc ui_manager_get_type*(): GType {.cdecl, dynlib: lib, importc: "gtk_ui_manager_get_type".}
proc ui_manager_new*(): PUIManager {.cdecl, dynlib: lib, importc: "gtk_ui_manager_new".}
proc ui_manager_set_add_tearoffs*(ui: PUIManager, value: gboolean) {.cdecl, dynlib: lib, importc: "gtk_ui_manager_set_add_tearoffs".}
proc ui_manager_get_add_tearoffs*(ui: PUIManager): gboolean {.cdecl, dynlib: lib, importc: "gtk_ui_manager_get_add_tearoffs".}
proc ui_manager_insert_action_group*(ui: PUIManager, group: PActionGroup, position: gint) {.cdecl, dynlib: lib, importc: "gtk_ui_manager_insert_action_group".}
proc ui_manager_remove_action_group*(ui: PUIManager, group: PActionGroup) {.cdecl, dynlib: lib, importc: "gtk_ui_manager_remove_action_group".}
proc ui_manager_get_accel_group*(ui: PUIManager): PAccelGroup {.cdecl, dynlib: lib, importc: "gtk_ui_manager_get_accel_group".}
proc ui_manager_get_widget*(ui: PUIManager, path: cstring): PWidget {.cdecl, dynlib: lib, importc: "gtk_ui_manager_get_widget".}
proc ui_manager_get_toplevels*(ui: PUIManager, types: TUIManagerItemType): PGSList {.cdecl, dynlib: lib, importc: "gtk_ui_manager_get_toplevels".}
proc ui_manager_get_action*(ui: PUIManager, path: cstring): PAction {.cdecl, dynlib: lib, importc: "gtk_ui_manager_get_action".}
proc ui_manager_add_ui_from_string*(ui: PUIManager, buffer: cstring, length: gssize, error: ptr ptr GError): guint {.cdecl, dynlib: lib, importc: "gtk_ui_manager_add_ui_from_string".}
proc ui_manager_remove_ui*(ui: PUIManager, mergeId: guint) {.cdecl, dynlib: lib, importc: "gtk_ui_manager_remove_ui".}
proc ui_manager_get_ui*(ui: PUIManager): cstring {.cdecl, dynlib: lib, importc: "gtk_ui_manager_get_ui".}
proc ui_manager_ensure_update*(ui: PUIManager) {.cdecl, dynlib: lib, importc: "gtk_ui_manager_ensure_update".}
