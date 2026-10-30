# Included by headers/gtk2.nim; do not import directly.
type
  TCheckMenuItemClass* = object of TMenuItemClass
    toggled*: proc (check_menu_item: PCheckMenuItem){.cdecl.}
    draw_indicator*: proc (check_menu_item: PCheckMenuItem, area: gdk2.PRectangle){.
        cdecl.}
    reserved191: proc (){.cdecl.}
    reserved192: proc (){.cdecl.}
    reserved193: proc (){.cdecl.}
    reserved194: proc (){.cdecl.}

  PCheckMenuItemClass* = ptr TCheckMenuItemClass
