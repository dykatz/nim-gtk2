# Included by headers/gtk2.nim; do not import directly.
proc clipboard_get_for_display*(display: gdk2.PDisplay, selection: gdk2.TAtom): PClipboard{.
    cdecl, dynlib: lib, importc: "gtk_clipboard_get_for_display".}
proc get_display*(clipboard: PClipboard): gdk2.PDisplay{.cdecl,
    dynlib: lib, importc: "gtk_clipboard_get_display".}
proc set_with_data*(clipboard: PClipboard, targets: PTargetEntry,
                              n_targets: guint, get_func: TClipboardGetFunc,
                              clear_func: TClipboardClearFunc,
                              user_data: gpointer): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_clipboard_set_with_data".}
proc set_with_owner*(clipboard: PClipboard, targets: PTargetEntry,
                               n_targets: guint, get_func: TClipboardGetFunc,
                               clear_func: TClipboardClearFunc, owner: PGObject): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_clipboard_set_with_owner".}
proc get_owner*(clipboard: PClipboard): PGObject{.cdecl, dynlib: lib,
    importc: "gtk_clipboard_get_owner".}
proc clear*(clipboard: PClipboard){.cdecl, dynlib: lib,
    importc: "gtk_clipboard_clear".}
proc set_text*(clipboard: PClipboard, text: cstring, len: gint){.
    cdecl, dynlib: lib, importc: "gtk_clipboard_set_text".}
proc request_contents*(clipboard: PClipboard, target: gdk2.TAtom,
                                 callback: TClipboardReceivedFunc,
                                 user_data: gpointer){.cdecl, dynlib: lib,
    importc: "gtk_clipboard_request_contents".}
proc request_text*(clipboard: PClipboard,
                             callback: TClipboardTextReceivedFunc,
                             user_data: gpointer){.cdecl, dynlib: lib,
    importc: "gtk_clipboard_request_text".}
proc wait_for_contents*(clipboard: PClipboard, target: gdk2.TAtom): PSelectionData{.
    cdecl, dynlib: lib, importc: "gtk_clipboard_wait_for_contents".}
proc wait_for_text*(clipboard: PClipboard): cstring{.cdecl,
    dynlib: lib, importc: "gtk_clipboard_wait_for_text".}
proc wait_is_text_available*(clipboard: PClipboard): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_clipboard_wait_is_text_available".}
