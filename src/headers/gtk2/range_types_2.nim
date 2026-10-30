# Included by headers/gtk2.nim; do not import directly.
type
  TRangeClass* = object of TWidgetClass
    slider_detail*: cstring
    stepper_detail*: cstring
    value_changed*: proc (range: PRange){.cdecl.}
    adjust_bounds*: proc (range: PRange, new_value: gdouble){.cdecl.}
    move_slider*: proc (range: PRange, scroll: TScrollType){.cdecl.}
    get_range_border*: proc (range: PRange, border: PBorder){.cdecl.}
    reserved401: proc (){.cdecl.}
    reserved402: proc (){.cdecl.}
    reserved403: proc (){.cdecl.}
    reserved404: proc (){.cdecl.}

  PRangeClass* = ptr TRangeClass
