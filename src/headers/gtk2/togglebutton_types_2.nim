# Included by headers/gtk2.nim; do not import directly.
type
  TToggleButtonClass* = object of TButtonClass
    toggled*: proc (toggle_button: PToggleButton){.cdecl.}
    reserved171: proc (){.cdecl.}
    reserved172: proc (){.cdecl.}
    reserved173: proc (){.cdecl.}
    reserved174: proc (){.cdecl.}

  PToggleButtonClass* = ptr TToggleButtonClass
