# Included by headers/glib2.nim; do not import directly.
type
  PGScanner* = ptr TGScanner
  TGScannerMsgFunc* = proc (scanner: PGScanner, message: cstring,
                            error: gboolean){.cdecl.}
  TGScanner*{.final.} = object
    user_data*: gpointer
    max_parse_errors*: guint
    parse_errors*: guint
    input_name*: cstring
    qdata*: PGData
    config*: PGScannerConfig
    token*: TGTokenType
    value*: TGTokenValue
    line*: guint
    position*: guint
    next_token*: TGTokenType
    next_value*: TGTokenValue
    next_line*: guint
    next_position*: guint
    symbol_table*: PGHashTable
    input_fd*: gint
    text*: cstring
    text_end*: cstring
    buffer*: cstring
    scope_id*: guint
    msg_handler*: TGScannerMsgFunc

