# Included by headers/glib2.nim; do not import directly.
type
  TGTokenValue*{.final.} = object
    v_float*: gdouble

  PGTokenValue* = ptr TGTokenValue
  TGScannerConfig*{.final.} = object
    cset_skip_characters*: cstring
    cset_identifier_first*: cstring
    cset_identifier_nth*: cstring
    cpair_comment_single*: cstring
    flag0*: uint32
    padding_dummy*: guint


  PGScannerConfig* = ptr TGScannerConfig
