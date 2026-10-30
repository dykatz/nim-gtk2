# Included by headers/gdk2.nim; do not import directly.
proc DRAG_CONTEXT*(anObject: pointer): PDragContext
proc DRAG_CONTEXT_CLASS*(klass: pointer): PDragContextClass
proc IS_DRAG_CONTEXT*(anObject: pointer): bool
proc IS_DRAG_CONTEXT_CLASS*(klass: pointer): bool
proc DRAG_CONTEXT_GET_CLASS*(obj: pointer): PDragContextClass
proc drag_context_get_type*(): GType{.cdecl, dynlib: lib,
                                      importc: "gdk_drag_context_get_type".}
proc drag_context_new*(): PDragContext{.cdecl, dynlib: lib,
                                        importc: "gdk_drag_context_new".}
proc status*(context: PDragContext, action: TDragAction, time: guint32){.
    cdecl, dynlib: lib, importc: "gdk_drag_status".}
proc drop_reply*(context: PDragContext, ok: gboolean, time: guint32){.cdecl,
    dynlib: lib, importc: "gdk_drop_reply".}
proc drop_finish*(context: PDragContext, success: gboolean, time: guint32){.
    cdecl, dynlib: lib, importc: "gdk_drop_finish".}
proc get_selection*(context: PDragContext): TAtom{.cdecl, dynlib: lib,
    importc: "gdk_drag_get_selection".}
proc drag_begin*(window: PWindow, targets: PGList): PDragContext{.cdecl,
    dynlib: lib, importc: "gdk_drag_begin".}
proc drag_get_protocol_for_display*(display: PDisplay, xid: guint32,
                                    protocol: PDragProtocol): guint32{.cdecl,
    dynlib: lib, importc: "gdk_drag_get_protocol_for_display".}
proc find_window*(context: PDragContext, drag_window: PWindow,
                       x_root: gint, y_root: gint, w: var PWindow,
                       protocol: PDragProtocol){.cdecl, dynlib: lib,
    importc: "gdk_drag_find_window".}
proc motion*(context: PDragContext, dest_window: PWindow,
                  protocol: TDragProtocol, x_root: gint, y_root: gint,
                  suggested_action: TDragAction, possible_actions: TDragAction,
                  time: guint32): gboolean{.cdecl, dynlib: lib,
    importc: "gdk_drag_motion".}
proc drop*(context: PDragContext, time: guint32){.cdecl, dynlib: lib,
    importc: "gdk_drag_drop".}
proc abort*(context: PDragContext, time: guint32){.cdecl, dynlib: lib,
    importc: "gdk_drag_abort".}
proc region_EXTENTCHECK*(r1, r2: PRegionBox): bool
