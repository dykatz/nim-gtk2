# Included by headers/atk.nim; do not import directly.
type
  TValueIface* = object of TGTypeInterface
    get_current_value*: proc (obj: PValue, value: PGValue){.cdecl.}
    get_maximum_value*: proc (obj: PValue, value: PGValue){.cdecl.}
    get_minimum_value*: proc (obj: PValue, value: PGValue){.cdecl.}
    set_current_value*: proc (obj: PValue, value: PGValue): gboolean{.cdecl.}
    pad33*: TFunction
    pad34*: TFunction


  PValueIface* = ptr TValueIface
