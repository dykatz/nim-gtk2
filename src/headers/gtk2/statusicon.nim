# Included by headers/gtk2.nim; do not import directly.
proc status_icon_get_type*(): GType{.cdecl,
    importc: "gtk_status_icon_get_type", dynlib: lib.}
proc status_icon_new*():PStatusIcon {.cdecl,
    importc: "gtk_status_icon_new", dynlib: lib.}
proc status_icon_new_from_pixbuf*(pixbuf: PPixbuf):PStatusIcon {.cdecl,
    importc: "gtk_status_icon_new_from_pixbuf", dynlib: lib.}
proc status_icon_new_from_file*(filename: PPgchar):PStatusIcon {.cdecl,
    importc: "gtk_status_icon_new_from_file", dynlib: lib.}
proc status_icon_new_from_stock*(stock_id: PPgchar):PStatusIcon {.cdecl,
    importc: "gtk_status_icon_new_from_stock", dynlib: lib.}
proc status_icon_new_from_icon_name*(icon_name: PPgchar):PStatusIcon {.cdecl,
    importc: "gtk_status_icon_new_from_icon_name", dynlib: lib.}
proc status_icon_set_from_pixbuf*(status_icon: PStatusIcon,pixbuf: PPixbuf) {.cdecl,
    importc: "gtk_status_icon_set_from_pixbuf", dynlib: lib.}
proc status_icon_set_from_file*(status_icon: PStatusIcon,filename: cstring) {.cdecl,
    importc: "gtk_status_icon_set_from_file", dynlib: lib.}
proc status_icon_set_from_stock*(status_icon: PStatusIcon,stock_id: cstring) {.cdecl,
    importc: "gtk_status_icon_set_from_stock", dynlib: lib.}
proc status_icon_set_from_icon_name*(status_icon: PStatusIcon,icon_name: cstring) {.cdecl,
    importc: "gtk_status_icon_set_from_icon_name", dynlib: lib.}
proc status_icon_get_storage_type*(status_icon: PStatusIcon): gtk2.PImageType {.cdecl,
    importc: "gtk_status_icon_get_storage_type", dynlib: lib.}
proc status_icon_get_pixbuf*(status_icon: PStatusIcon):PPixbuf {.cdecl,
    importc: "gtk_status_icon_get_pixbuf", dynlib: lib.}
proc status_icon_get_stock*(status_icon: PStatusIcon):cstring {.cdecl,
    importc: "gtk_status_icon_get_stock", dynlib: lib.}
proc status_icon_get_icon_name*(status_icon: PStatusIcon):cstring {.cdecl,
    importc: "gtk_status_icon_get_icon_name", dynlib: lib.}
proc status_icon_get_size*(status_icon: PStatusIcon):gint {.cdecl,
    importc: "gtk_status_icon_get_size", dynlib: lib.}
proc status_icon_set_screen*(status_icon: PStatusIcon,screen: PScreen) {.cdecl,
    importc: "gtk_status_icon_set_screen", dynlib: lib.}
proc status_icon_get_screen*(status_icon: PStatusIcon):PScreen {.cdecl,
    importc: "gtk_status_icon_get_screen", dynlib: lib.}
proc status_icon_set_has_tooltip*(status_icon: PStatusIcon,has_tooltip: gboolean) {.cdecl,
    importc: "gtk_status_icon_set_has_tooltip", dynlib: lib.}
proc status_icon_set_tooltip_text*(status_icon: PStatusIcon,text: cstring) {.cdecl,
    importc: "gtk_status_icon_set_tooltip_text", dynlib: lib.}
proc status_icon_set_tooltip_markup*(status_icon: PStatusIcon,markup: cstring) {.cdecl,
    importc: "gtk_status_icon_set_tooltip_markup", dynlib: lib.}
proc status_icon_set_title*(status_icon: PStatusIcon,title: cstring) {.cdecl,
    importc: "gtk_status_icon_set_title", dynlib: lib.}
proc status_icon_get_title*(status_icon: PStatusIcon):cstring {.cdecl,
    importc: "gtk_status_icon_get_title", dynlib: lib.}
proc status_icon_set_name*(status_icon: PStatusIcon,name: cstring) {.cdecl,
    importc: "gtk_status_icon_set_name", dynlib: lib.}
proc status_icon_set_visible*(status_icon: PStatusIcon,visible: gboolean) {.cdecl,
    importc: "gtk_status_icon_set_visible", dynlib: lib.}
proc status_icon_get_visible*(status_icon: PStatusIcon):gboolean {.cdecl,
    importc: "gtk_status_icon_get_visible", dynlib: lib.}
proc status_icon_is_embedded*(status_icon: PStatusIcon):gboolean {.cdecl,
    importc: "gtk_status_icon_is_embedded", dynlib: lib.}
proc status_icon_position_menu*(menu: PMenu,x: Pgint,y: Pgint,push_in: Pgboolean,user_data: gpointer) {.cdecl,
    importc: "gtk_status_icon_position_menu", dynlib: lib.}
proc status_icon_get_geometry*(status_icon: PStatusIcon,screen: PScreen,area: gdk2.PRectangle,orientation: POrientation):gboolean {.cdecl,
    importc: "gtk_status_icon_get_geometry", dynlib: lib.}
proc status_icon_get_has_tooltip*(status_icon: PStatusIcon):gboolean {.cdecl,
    importc: "gtk_status_icon_get_has_tooltip", dynlib: lib.}
proc status_icon_get_tooltip_text*(status_icon: PStatusIcon):cstring {.cdecl,
    importc: "gtk_status_icon_get_tooltip_text", dynlib: lib.}
proc status_icon_get_tooltip_markup*(status_icon: PStatusIcon):cstring {.cdecl,
    importc: "gtk_status_icon_get_tooltip_markup", dynlib: lib.}
proc status_icon_get_x11_window_id*(status_icon: PStatusIcon):guint32 {.cdecl,
    importc: "gtk_status_icon_get_x11_window_id", dynlib: lib.}

proc TYPE_STATUS_ICON*(): GType =
  result = status_icon_get_type()
proc STATUS_ICON_TYPE*(wid: pointer): GType =
  result = OBJECT_TYPE(wid)
proc `STATUS_ICON`*(anObject: pointer): PStatusIcon =
  result = cast[PStatusIcon](CHECK_CAST(anObject, TYPE_STATUS_ICON()))
proc STATUS_ICON_CLASS*(klass: pointer): PStatusIconClass =
  result = cast[PStatusIconClass](CHECK_CLASS_CAST(klass, TYPE_STATUS_ICON()))
proc IS_STATUS_ICON*(anObject: pointer): bool =
  result = CHECK_TYPE(anObject, TYPE_STATUS_ICON())
proc IS_STATUS_ICON_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_STATUS_ICON())
proc STATUS_ICON_GET_CLASS*(anObject: pointer): PStatusIconClass =
  result = cast[PStatusIconClass](CHECK_GET_CLASS(anObject, TYPE_STATUS_ICON()))

