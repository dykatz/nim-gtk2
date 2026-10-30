# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SOCKET*(): GType
proc SOCKET*(obj: pointer): PSocket
proc SOCKET_CLASS*(klass: pointer): PSocketClass
proc IS_SOCKET*(obj: pointer): bool
proc IS_SOCKET_CLASS*(klass: pointer): bool
proc SOCKET_GET_CLASS*(obj: pointer): PSocketClass
proc same_app*(a: PSocket): guint
proc set_same_app*(a: PSocket, `same_app`: guint)
proc focus_in*(a: PSocket): guint
proc set_focus_in*(a: PSocket, `focus_in`: guint)
proc have_size*(a: PSocket): guint
proc set_have_size*(a: PSocket, `have_size`: guint)
proc need_map*(a: PSocket): guint
proc set_need_map*(a: PSocket, `need_map`: guint)
proc is_mapped*(a: PSocket): guint
proc set_is_mapped*(a: PSocket, `is_mapped`: guint)
proc socket_new*(): PSocket{.cdecl, dynlib: lib, importc: "gtk_socket_new".}
proc socket_get_type*(): TType{.cdecl, dynlib: lib,
                                importc: "gtk_socket_get_type".}
proc add_id*(socket: PSocket, window_id: gdk2.TNativeWindow){.cdecl,
    dynlib: lib, importc: "gtk_socket_add_id".}
proc get_id*(socket: PSocket): gdk2.TNativeWindow{.cdecl, dynlib: lib,
    importc: "gtk_socket_get_id".}
