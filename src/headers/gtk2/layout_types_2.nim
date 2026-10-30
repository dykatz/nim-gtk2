# Included by headers/gtk2.nim; do not import directly.
type
  TLayoutClass* = object of TContainerClass
    set_scroll_adjustments*: proc (layout: PLayout, hadjustment: PAdjustment,
                                   vadjustment: PAdjustment){.cdecl.}
    reserved481: proc (){.cdecl.}
    reserved482: proc (){.cdecl.}
    reserved483: proc (){.cdecl.}
    reserved484: proc (){.cdecl.}

  PLayoutClass* = ptr TLayoutClass
