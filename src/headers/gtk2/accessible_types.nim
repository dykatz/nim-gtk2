# Included by headers/gtk2.nim; do not import directly.
type
  TAccessible* = object of atk.TObject
    widget*: PWidget

  PAccessible* = ptr TAccessible
  TAccessibleClass* = object of atk.TObjectClass
    connect_widget_destroyed*: proc (accessible: PAccessible){.cdecl.}
    reserved71: proc (){.cdecl.}
    reserved72: proc (){.cdecl.}
    reserved73: proc (){.cdecl.}
    reserved74: proc (){.cdecl.}

  PAccessibleClass* = ptr TAccessibleClass
