# GTK2.24 action APIs (deprecated in GTK3, not GTK2). Opaque native GObjects.
type
  TAction* {.pure, final, incompleteStruct.} = object
  PAction* = ptr TAction
  TToggleAction* {.pure, final, incompleteStruct.} = object
  PToggleAction* = ptr TToggleAction
  TActionGroup* {.pure, final, incompleteStruct.} = object
  PActionGroup* = ptr TActionGroup
proc action_get_type*(): GType {.cdecl, dynlib: lib, importc: "gtk_action_get_type".}
proc toggle_action_get_type*(): GType {.cdecl, dynlib: lib, importc: "gtk_toggle_action_get_type".}
proc action_group_get_type*(): GType {.cdecl, dynlib: lib, importc: "gtk_action_group_get_type".}
proc action_new*(name, label, tooltip, stockId: cstring): PAction {.cdecl, dynlib: lib, importc: "gtk_action_new".}
proc toggle_action_new*(name, label, tooltip, stockId: cstring): PToggleAction {.cdecl, dynlib: lib, importc: "gtk_toggle_action_new".}
proc action_group_new*(name: cstring): PActionGroup {.cdecl, dynlib: lib, importc: "gtk_action_group_new".}
proc action_get_name*(action: PAction): cstring {.cdecl, dynlib: lib, importc: "gtk_action_get_name".}
proc action_get_label*(action: PAction): cstring {.cdecl, dynlib: lib, importc: "gtk_action_get_label".}
proc action_set_label*(action: PAction, value: cstring) {.cdecl, dynlib: lib, importc: "gtk_action_set_label".}
proc action_get_short_label*(action: PAction): cstring {.cdecl, dynlib: lib, importc: "gtk_action_get_short_label".}
proc action_set_short_label*(action: PAction, value: cstring) {.cdecl, dynlib: lib, importc: "gtk_action_set_short_label".}
proc action_get_tooltip*(action: PAction): cstring {.cdecl, dynlib: lib, importc: "gtk_action_get_tooltip".}
proc action_set_tooltip*(action: PAction, value: cstring) {.cdecl, dynlib: lib, importc: "gtk_action_set_tooltip".}
proc action_get_icon_name*(action: PAction): cstring {.cdecl, dynlib: lib, importc: "gtk_action_get_icon_name".}
proc action_set_icon_name*(action: PAction, value: cstring) {.cdecl, dynlib: lib, importc: "gtk_action_set_icon_name".}
proc action_get_is_important*(action: PAction): gboolean {.cdecl, dynlib: lib, importc: "gtk_action_get_is_important".}
proc action_set_is_important*(action: PAction, value: gboolean) {.cdecl, dynlib: lib, importc: "gtk_action_set_is_important".}
proc action_get_sensitive*(action: PAction): gboolean {.cdecl, dynlib: lib, importc: "gtk_action_get_sensitive".}
proc action_set_sensitive*(action: PAction, value: gboolean) {.cdecl, dynlib: lib, importc: "gtk_action_set_sensitive".}
proc action_is_sensitive*(action: PAction): gboolean {.cdecl, dynlib: lib, importc: "gtk_action_is_sensitive".}
proc action_get_visible*(action: PAction): gboolean {.cdecl, dynlib: lib, importc: "gtk_action_get_visible".}
proc action_set_visible*(action: PAction, value: gboolean) {.cdecl, dynlib: lib, importc: "gtk_action_set_visible".}
proc action_is_visible*(action: PAction): gboolean {.cdecl, dynlib: lib, importc: "gtk_action_is_visible".}
proc action_activate*(action: PAction) {.cdecl, dynlib: lib, importc: "gtk_action_activate".}
proc action_create_menu_item*(action: PAction): PWidget {.cdecl, dynlib: lib, importc: "gtk_action_create_menu_item".}
proc action_create_tool_item*(action: PAction): PWidget {.cdecl, dynlib: lib, importc: "gtk_action_create_tool_item".}
proc action_get_proxies*(action: PAction): PGSList {.cdecl, dynlib: lib, importc: "gtk_action_get_proxies".}
proc action_get_accel_path*(action: PAction): cstring {.cdecl, dynlib: lib, importc: "gtk_action_get_accel_path".}
proc action_get_accel_closure*(action: PAction): PGClosure {.cdecl, dynlib: lib, importc: "gtk_action_get_accel_closure".}
proc toggle_action_get_active*(action: PToggleAction): gboolean {.cdecl, dynlib: lib, importc: "gtk_toggle_action_get_active".}
proc toggle_action_set_active*(action: PToggleAction, active: gboolean) {.cdecl, dynlib: lib, importc: "gtk_toggle_action_set_active".}
proc action_group_get_name*(group: PActionGroup): cstring {.cdecl, dynlib: lib, importc: "gtk_action_group_get_name".}
proc action_group_get_sensitive*(group: PActionGroup): gboolean {.cdecl, dynlib: lib, importc: "gtk_action_group_get_sensitive".}
proc action_group_set_sensitive*(group: PActionGroup, value: gboolean) {.cdecl, dynlib: lib, importc: "gtk_action_group_set_sensitive".}
proc action_group_get_visible*(group: PActionGroup): gboolean {.cdecl, dynlib: lib, importc: "gtk_action_group_get_visible".}
proc action_group_set_visible*(group: PActionGroup, value: gboolean) {.cdecl, dynlib: lib, importc: "gtk_action_group_set_visible".}
proc action_group_get_action*(group: PActionGroup, name: cstring): PAction {.cdecl, dynlib: lib, importc: "gtk_action_group_get_action".}
proc action_group_add_action*(group: PActionGroup, action: PAction) {.cdecl, dynlib: lib, importc: "gtk_action_group_add_action".}
proc action_group_remove_action*(group: PActionGroup, action: PAction) {.cdecl, dynlib: lib, importc: "gtk_action_group_remove_action".}
