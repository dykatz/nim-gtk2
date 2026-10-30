# Included by headers/gtk2.nim; do not import directly.
type
  TCellRendererToggleClass* = object of TCellRendererClass
    toggled*: proc (cell_renderer_toggle: PCellRendererToggle, path: cstring){.
        cdecl.}
    reserved141: proc (){.cdecl.}
    reserved142: proc (){.cdecl.}
    reserved143: proc (){.cdecl.}
    reserved144: proc (){.cdecl.}

  PCellRendererToggleClass* = ptr TCellRendererToggleClass
