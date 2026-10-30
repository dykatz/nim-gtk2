# Included by headers/gtk2.nim; do not import directly.
type
  TScrolledWindowClass* = object of TBinClass
    scrollbar_spacing*: gint
    scroll_child*: proc (scrolled_window: PScrolledWindow, scroll: TScrollType,
                         horizontal: gboolean){.cdecl.}
    move_focus_out*: proc (scrolled_window: PScrolledWindow,
                           direction: TDirectionType){.cdecl.}
    reserved601: proc (){.cdecl.}
    reserved602: proc (){.cdecl.}
    reserved603: proc (){.cdecl.}
    reserved604: proc (){.cdecl.}

  PScrolledWindowClass* = ptr TScrolledWindowClass
