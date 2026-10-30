# Included by headers/gtk2.nim; do not import directly.
type
  TCheckButtonClass* = object of TToggleButtonClass
    draw_indicator*: proc (check_button: PCheckButton, area: gdk2.PRectangle){.
        cdecl.}
    reserved181: proc (){.cdecl.}
    reserved182: proc (){.cdecl.}
    reserved183: proc (){.cdecl.}
    reserved184: proc (){.cdecl.}

  PCheckButtonClass* = ptr TCheckButtonClass
