# Included by headers/glib2.nim; do not import directly.
type
  TGEnumValue*{.final.} = object
    value*: gint
    value_name*: cstring
    value_nick*: cstring

  PGEnumValue* = ptr TGEnumValue
  TGEnumClass*{.final.} = object
    g_type_class*: TGTypeClass
    minimum*: gint
    maximum*: gint
    n_values*: guint
    values*: PGEnumValue

  PGEnumClass* = ptr TGEnumClass
  TGFlagsValue*{.final.} = object
    value*: guint
    value_name*: cstring
    value_nick*: cstring


  PGFlagsValue* = ptr TGFlagsValue
  TGFlagsClass*{.final.} = object
    g_type_class*: TGTypeClass
    mask*: guint
    n_values*: guint
    values*: PGFlagsValue

  PGFlagsClass* = ptr TGFlagsClass
