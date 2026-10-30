# Included by headers/gtk2.nim; do not import directly.
type
  TAccelLabelClass* = object of TLabelClass
    signal_quote1*: cstring
    signal_quote2*: cstring
    mod_name_shift*: cstring
    mod_name_control*: cstring
    mod_name_alt*: cstring
    mod_separator*: cstring
    accel_seperator*: cstring
    AccelLabelClass_flag0*: guint16
    reserved61: proc (){.cdecl.}
    reserved62: proc (){.cdecl.}
    reserved63: proc (){.cdecl.}
    reserved64: proc (){.cdecl.}

  PAccelLabelClass* = ptr TAccelLabelClass
