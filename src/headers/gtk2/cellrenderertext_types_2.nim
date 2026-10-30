# Included by headers/gtk2.nim; do not import directly.
type
  TCellRendererTextClass* = object of TCellRendererClass
    edited*: proc (cell_renderer_text: PCellRendererText, path: cstring,
                   new_text: cstring){.cdecl.}
    reserved131: proc (){.cdecl.}
    reserved132: proc (){.cdecl.}
    reserved133: proc (){.cdecl.}
    reserved134: proc (){.cdecl.}

  PCellRendererTextClass* = ptr TCellRendererTextClass
