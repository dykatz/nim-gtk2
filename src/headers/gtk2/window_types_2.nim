# Included by headers/gtk2.nim; do not import directly.
type
  TWindowClass* = object of TBinClass
    set_focus*: proc (window: PWindow, focus: PWidget){.cdecl.}
    frame_event*: proc (window: PWindow, event: gdk2.PEvent): gboolean{.cdecl.}
    activate_focus*: proc (window: PWindow){.cdecl.}
    activate_default*: proc (window: PWindow){.cdecl.}
    move_focus*: proc (window: PWindow, direction: TDirectionType){.cdecl.}
    keys_changed*: proc (window: PWindow){.cdecl.}
    reserved30: proc (){.cdecl.}
    reserved31: proc (){.cdecl.}
    reserved32: proc (){.cdecl.}
    reserved33: proc (){.cdecl.}

  PWindowClass* = ptr TWindowClass
