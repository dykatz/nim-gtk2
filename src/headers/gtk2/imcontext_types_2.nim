# Included by headers/gtk2.nim; do not import directly.
type
  TIMContextClass* = object of TObjectClass
    preedit_start*: proc (context: PIMContext){.cdecl.}
    preedit_end*: proc (context: PIMContext){.cdecl.}
    preedit_changed*: proc (context: PIMContext){.cdecl.}
    commit*: proc (context: PIMContext, str: cstring){.cdecl.}
    retrieve_surrounding*: proc (context: PIMContext): gboolean{.cdecl.}
    delete_surrounding*: proc (context: PIMContext, offset: gint, n_chars: gint): gboolean{.
        cdecl.}
    set_client_window*: proc (context: PIMContext, window: gdk2.PWindow){.cdecl.}
    get_preedit_string*: proc (context: PIMContext, str: PPgchar,
                               attrs: var pango.PAttrList, cursor_pos: Pgint){.
        cdecl.}
    filter_keypress*: proc (context: PIMContext, event: gdk2.PEventKey): gboolean{.
        cdecl.}
    focus_in*: proc (context: PIMContext){.cdecl.}
    focus_out*: proc (context: PIMContext){.cdecl.}
    reset*: proc (context: PIMContext){.cdecl.}
    set_cursor_location*: proc (context: PIMContext, area: gdk2.PRectangle){.cdecl.}
    set_use_preedit*: proc (context: PIMContext, use_preedit: gboolean){.cdecl.}
    set_surrounding*: proc (context: PIMContext, text: cstring, len: gint,
                            cursor_index: gint){.cdecl.}
    get_surrounding*: proc (context: PIMContext, text: PPgchar,
                            cursor_index: Pgint): gboolean{.cdecl.}
    reserved261: proc (){.cdecl.}
    reserved262: proc (){.cdecl.}
    reserved263: proc (){.cdecl.}
    reserved264: proc (){.cdecl.}
    reserved265: proc (){.cdecl.}
    reserved266: proc (){.cdecl.}

  PIMContextClass* = ptr TIMContextClass
