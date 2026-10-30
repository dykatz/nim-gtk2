# Included by headers/gtk2.nim; do not import directly.
type
  TAdjustment* = object of TObject
    lower*: gdouble
    upper*: gdouble
    value*: gdouble
    step_increment*: gdouble
    page_increment*: gdouble
    page_size*: gdouble

  PAdjustment* = ptr TAdjustment
  TAdjustmentClass* = object of TObjectClass
    changed*: proc (adjustment: PAdjustment){.cdecl.}
    value_changed*: proc (adjustment: PAdjustment){.cdecl.}
    reserved81: proc (){.cdecl.}
    reserved82: proc (){.cdecl.}
    reserved83: proc (){.cdecl.}
    reserved84: proc (){.cdecl.}

  PAdjustmentClass* = ptr TAdjustmentClass
