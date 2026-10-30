# Included by headers/gtk2.nim; do not import directly.
const
  DEST_DEFAULT_MOTION* = 1 shl 0
const
  DEST_DEFAULT_HIGHLIGHT* = 1 shl 1
const
  DEST_DEFAULT_DROP* = 1 shl 2
const
  DEST_DEFAULT_ALL* = 0x00000007
const
  TARGET_SAME_APP* = 1 shl 0
const
  TARGET_SAME_WIDGET* = 1 shl 1

proc drag_get_data*(widget: PWidget, context: gdk2.PDragContext, target: gdk2.TAtom,
                    time: guint32){.cdecl, dynlib: lib,
                                    importc: "gtk_drag_get_data".}
proc drag_finish*(context: gdk2.PDragContext, success: gboolean, del: gboolean,
                  time: guint32){.cdecl, dynlib: lib, importc: "gtk_drag_finish".}
proc drag_get_source_widget*(context: gdk2.PDragContext): PWidget{.cdecl,
    dynlib: lib, importc: "gtk_drag_get_source_widget".}
proc drag_highlight*(widget: PWidget){.cdecl, dynlib: lib,
                                       importc: "gtk_drag_highlight".}
proc drag_unhighlight*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_drag_unhighlight".}
proc drag_dest_set*(widget: PWidget, flags: TDestDefaults,
                    targets: PTargetEntry, n_targets: gint,
                    actions: gdk2.TDragAction){.cdecl, dynlib: lib,
    importc: "gtk_drag_dest_set".}
proc drag_dest_set_proxy*(widget: PWidget, proxy_window: gdk2.PWindow,
                          protocol: gdk2.TDragProtocol, use_coordinates: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_drag_dest_set_proxy".}
proc drag_dest_unset*(widget: PWidget){.cdecl, dynlib: lib,
                                        importc: "gtk_drag_dest_unset".}
proc drag_dest_find_target*(widget: PWidget, context: gdk2.PDragContext,
                            target_list: PTargetList): gdk2.TAtom{.cdecl,
    dynlib: lib, importc: "gtk_drag_dest_find_target".}
proc drag_dest_get_target_list*(widget: PWidget): PTargetList{.cdecl,
    dynlib: lib, importc: "gtk_drag_dest_get_target_list".}
proc drag_dest_set_target_list*(widget: PWidget, target_list: PTargetList){.
    cdecl, dynlib: lib, importc: "gtk_drag_dest_set_target_list".}
proc drag_source_set*(widget: PWidget, start_button_mask: gdk2.TModifierType,
                      targets: PTargetEntry, n_targets: gint,
                      actions: gdk2.TDragAction){.cdecl, dynlib: lib,
    importc: "gtk_drag_source_set".}
proc drag_source_unset*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_drag_source_unset".}
proc drag_source_set_icon*(widget: PWidget, colormap: gdk2.PColormap,
                           pixmap: gdk2.PPixmap, mask: gdk2.PBitmap){.cdecl,
    dynlib: lib, importc: "gtk_drag_source_set_icon".}
proc drag_source_set_icon_pixbuf*(widget: PWidget, pixbuf: gdk2pixbuf.PPixbuf){.cdecl,
    dynlib: lib, importc: "gtk_drag_source_set_icon_pixbuf".}
proc drag_source_set_icon_stock*(widget: PWidget, stock_id: cstring){.cdecl,
    dynlib: lib, importc: "gtk_drag_source_set_icon_stock".}
proc drag_begin*(widget: PWidget, targets: PTargetList, actions: gdk2.TDragAction,
                 button: gint, event: gdk2.PEvent): gdk2.PDragContext{.cdecl,
    dynlib: lib, importc: "gtk_drag_begin".}
proc drag_set_icon_widget*(context: gdk2.PDragContext, widget: PWidget,
                           hot_x: gint, hot_y: gint){.cdecl, dynlib: lib,
    importc: "gtk_drag_set_icon_widget".}
proc drag_set_icon_pixmap*(context: gdk2.PDragContext, colormap: gdk2.PColormap,
                           pixmap: gdk2.PPixmap, mask: gdk2.PBitmap, hot_x: gint,
                           hot_y: gint){.cdecl, dynlib: lib,
    importc: "gtk_drag_set_icon_pixmap".}
proc drag_set_icon_pixbuf*(context: gdk2.PDragContext, pixbuf: gdk2pixbuf.PPixbuf,
                           hot_x: gint, hot_y: gint){.cdecl, dynlib: lib,
    importc: "gtk_drag_set_icon_pixbuf".}
proc drag_set_icon_stock*(context: gdk2.PDragContext, stock_id: cstring,
                          hot_x: gint, hot_y: gint){.cdecl, dynlib: lib,
    importc: "gtk_drag_set_icon_stock".}
proc drag_set_icon_default*(context: gdk2.PDragContext){.cdecl, dynlib: lib,
    importc: "gtk_drag_set_icon_default".}
proc drag_check_threshold*(widget: PWidget, start_x: gint, start_y: gint,
                           current_x: gint, current_y: gint): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_drag_check_threshold".}
