# Included by headers/gtk2.nim; do not import directly.
proc TYPE_IM_CONTEXT*(): GType
proc IM_CONTEXT*(obj: pointer): PIMContext
proc IM_CONTEXT_CLASS*(klass: pointer): PIMContextClass
proc IS_IM_CONTEXT*(obj: pointer): bool
proc IS_IM_CONTEXT_CLASS*(klass: pointer): bool
proc IM_CONTEXT_GET_CLASS*(obj: pointer): PIMContextClass
proc im_context_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_im_context_get_type".}
proc set_client_window*(context: PIMContext, window: gdk2.PWindow){.
    cdecl, dynlib: lib, importc: "gtk_im_context_set_client_window".}
proc filter_keypress*(context: PIMContext, event: gdk2.PEventKey): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_im_context_filter_keypress".}
proc focus_in*(context: PIMContext){.cdecl, dynlib: lib,
    importc: "gtk_im_context_focus_in".}
proc focus_out*(context: PIMContext){.cdecl, dynlib: lib,
    importc: "gtk_im_context_focus_out".}
proc reset*(context: PIMContext){.cdecl, dynlib: lib,
    importc: "gtk_im_context_reset".}
proc set_cursor_location*(context: PIMContext, area: gdk2.PRectangle){.
    cdecl, dynlib: lib, importc: "gtk_im_context_set_cursor_location".}
proc set_use_preedit*(context: PIMContext, use_preedit: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_im_context_set_use_preedit".}
proc set_surrounding*(context: PIMContext, text: cstring, len: gint,
                                 cursor_index: gint){.cdecl, dynlib: lib,
    importc: "gtk_im_context_set_surrounding".}
proc get_surrounding*(context: PIMContext, text: PPgchar,
                                 cursor_index: Pgint): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_im_context_get_surrounding".}
proc delete_surrounding*(context: PIMContext, offset: gint,
                                    n_chars: gint): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_im_context_delete_surrounding".}
const
  bm_TGtkMenuShell_active* = 0x0001'u16
const
  bp_TGtkMenuShell_active* = 0'u16
const
  bm_TGtkMenuShell_have_grab* = 0x0002'u16
const
  bp_TGtkMenuShell_have_grab* = 1'u16
const
  bm_TGtkMenuShell_have_xgrab* = 0x0004'u16
const
  bp_TGtkMenuShell_have_xgrab* = 2'u16
const
  bm_TGtkMenuShell_ignore_leave* = 0x0008'u16
const
  bp_TGtkMenuShell_ignore_leave* = 3'u16
const
  bm_TGtkMenuShell_menu_flag* = 0x0010'u16
const
  bp_TGtkMenuShell_menu_flag* = 4'u16
const
  bm_TGtkMenuShell_ignore_enter* = 0x0020'u16
const
  bp_TGtkMenuShell_ignore_enter* = 5'u16
const
  bm_TGtkMenuShellClass_submenu_placement* = 0x0001'u16
const
  bp_TGtkMenuShellClass_submenu_placement* = 0'u16

