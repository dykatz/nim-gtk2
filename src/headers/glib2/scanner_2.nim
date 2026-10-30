# Included by headers/glib2.nim; do not import directly.
proc TGScannerConfig_case_sensitive*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_case_sensitive) shr
      bp_TGScannerConfig_case_sensitive

proc TGScannerConfig_set_case_sensitive*(a: PGScannerConfig,
    `case_sensitive`: guint) =
  a.flag0 = a.flag0 or
      ((`case_sensitive` shl bp_TGScannerConfig_case_sensitive) and
      bm_TGScannerConfig_case_sensitive)

proc TGScannerConfig_skip_comment_multi*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_skip_comment_multi) shr
      bp_TGScannerConfig_skip_comment_multi

proc TGScannerConfig_set_skip_comment_multi*(a: PGScannerConfig,
    `skip_comment_multi`: guint) =
  a.flag0 = a.flag0 or
      ((`skip_comment_multi` shl bp_TGScannerConfig_skip_comment_multi) and
      bm_TGScannerConfig_skip_comment_multi)

proc TGScannerConfig_skip_comment_single*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_skip_comment_single) shr
      bp_TGScannerConfig_skip_comment_single

proc TGScannerConfig_set_skip_comment_single*(a: PGScannerConfig,
    `skip_comment_single`: guint) =
  a.flag0 = a.flag0 or
      ((`skip_comment_single` shl bp_TGScannerConfig_skip_comment_single) and
      bm_TGScannerConfig_skip_comment_single)

proc TGScannerConfig_scan_comment_multi*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scan_comment_multi) shr
      bp_TGScannerConfig_scan_comment_multi

proc TGScannerConfig_set_scan_comment_multi*(a: PGScannerConfig,
    `scan_comment_multi`: guint) =
  a.flag0 = a.flag0 or
      ((`scan_comment_multi` shl bp_TGScannerConfig_scan_comment_multi) and
      bm_TGScannerConfig_scan_comment_multi)

proc TGScannerConfig_scan_identifier*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scan_identifier) shr
      bp_TGScannerConfig_scan_identifier

proc TGScannerConfig_set_scan_identifier*(a: PGScannerConfig,
    `scan_identifier`: guint) =
  a.flag0 = a.flag0 or
      ((`scan_identifier` shl bp_TGScannerConfig_scan_identifier) and
      bm_TGScannerConfig_scan_identifier)

proc TGScannerConfig_scan_identifier_1char*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scan_identifier_1char) shr
      bp_TGScannerConfig_scan_identifier_1char

proc TGScannerConfig_set_scan_identifier_1char*(a: PGScannerConfig,
    `scan_identifier_1char`: guint) =
  a.flag0 = a.flag0 or
      ((`scan_identifier_1char` shl bp_TGScannerConfig_scan_identifier_1char) and
      bm_TGScannerConfig_scan_identifier_1char)

proc TGScannerConfig_scan_identifier_NULL*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scan_identifier_NULL) shr
      bp_TGScannerConfig_scan_identifier_NULL

proc TGScannerConfig_set_scan_identifier_NULL*(a: PGScannerConfig,
    `scan_identifier_NULL`: guint) =
  a.flag0 = a.flag0 or
      ((`scan_identifier_NULL` shl bp_TGScannerConfig_scan_identifier_NULL) and
      bm_TGScannerConfig_scan_identifier_NULL)

proc TGScannerConfig_scan_symbols*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scan_symbols) shr
      bp_TGScannerConfig_scan_symbols

proc TGScannerConfig_set_scan_symbols*(a: PGScannerConfig,
                                       `scan_symbols`: guint) =
  a.flag0 = a.flag0 or
      ((`scan_symbols` shl bp_TGScannerConfig_scan_symbols) and
      bm_TGScannerConfig_scan_symbols)

proc TGScannerConfig_scan_binary*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scan_binary) shr
      bp_TGScannerConfig_scan_binary

proc TGScannerConfig_set_scan_binary*(a: PGScannerConfig,
                                      `scan_binary`: guint) =
  a.flag0 = a.flag0 or
      ((`scan_binary` shl bp_TGScannerConfig_scan_binary) and
      bm_TGScannerConfig_scan_binary)

proc TGScannerConfig_scan_octal*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scan_octal) shr
      bp_TGScannerConfig_scan_octal

proc TGScannerConfig_set_scan_octal*(a: PGScannerConfig, `scan_octal`: guint) =
  a.flag0 = a.flag0 or
      ((`scan_octal` shl bp_TGScannerConfig_scan_octal) and
      bm_TGScannerConfig_scan_octal)

proc TGScannerConfig_scan_float*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scan_float) shr
      bp_TGScannerConfig_scan_float

proc TGScannerConfig_set_scan_float*(a: PGScannerConfig, `scan_float`: guint) =
  a.flag0 = a.flag0 or
      ((`scan_float` shl bp_TGScannerConfig_scan_float) and
      bm_TGScannerConfig_scan_float)

proc TGScannerConfig_scan_hex*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scan_hex) shr
      bp_TGScannerConfig_scan_hex

proc TGScannerConfig_set_scan_hex*(a: PGScannerConfig, `scan_hex`: guint) =
  a.flag0 = a.flag0 or
      ((`scan_hex` shl bp_TGScannerConfig_scan_hex) and
      bm_TGScannerConfig_scan_hex)

proc TGScannerConfig_scan_hex_dollar*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scan_hex_dollar) shr
      bp_TGScannerConfig_scan_hex_dollar

proc TGScannerConfig_set_scan_hex_dollar*(a: PGScannerConfig,
    `scan_hex_dollar`: guint) =
  a.flag0 = a.flag0 or
      ((`scan_hex_dollar` shl bp_TGScannerConfig_scan_hex_dollar) and
      bm_TGScannerConfig_scan_hex_dollar)

proc TGScannerConfig_scan_string_sq*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scan_string_sq) shr
      bp_TGScannerConfig_scan_string_sq

proc TGScannerConfig_set_scan_string_sq*(a: PGScannerConfig,
    `scan_string_sq`: guint) =
  a.flag0 = a.flag0 or
      ((`scan_string_sq` shl bp_TGScannerConfig_scan_string_sq) and
      bm_TGScannerConfig_scan_string_sq)

proc TGScannerConfig_scan_string_dq*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scan_string_dq) shr
      bp_TGScannerConfig_scan_string_dq

proc TGScannerConfig_set_scan_string_dq*(a: PGScannerConfig,
    `scan_string_dq`: guint) =
  a.flag0 = a.flag0 or
      ((`scan_string_dq` shl bp_TGScannerConfig_scan_string_dq) and
      bm_TGScannerConfig_scan_string_dq)

proc TGScannerConfig_numbers_2_int*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_numbers_2_int) shr
      bp_TGScannerConfig_numbers_2_int

proc TGScannerConfig_set_numbers_2_int*(a: PGScannerConfig,
                                        `numbers_2_int`: guint) =
  a.flag0 = a.flag0 or
      ((`numbers_2_int` shl bp_TGScannerConfig_numbers_2_int) and
      bm_TGScannerConfig_numbers_2_int)

proc TGScannerConfig_int_2_float*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_int_2_float) shr
      bp_TGScannerConfig_int_2_float

proc TGScannerConfig_set_int_2_float*(a: PGScannerConfig,
                                      `int_2_float`: guint) =
  a.flag0 = a.flag0 or
      ((`int_2_float` shl bp_TGScannerConfig_int_2_float) and
      bm_TGScannerConfig_int_2_float)

proc TGScannerConfig_identifier_2_string*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_identifier_2_string) shr
      bp_TGScannerConfig_identifier_2_string

proc TGScannerConfig_set_identifier_2_string*(a: PGScannerConfig,
    `identifier_2_string`: guint) =
  a.flag0 = a.flag0 or
      ((`identifier_2_string` shl bp_TGScannerConfig_identifier_2_string) and
      bm_TGScannerConfig_identifier_2_string)

proc TGScannerConfig_char_2_token*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_char_2_token) shr
      bp_TGScannerConfig_char_2_token

proc TGScannerConfig_set_char_2_token*(a: PGScannerConfig,
                                       `char_2_token`: guint) =
  a.flag0 = a.flag0 or
      ((`char_2_token` shl bp_TGScannerConfig_char_2_token) and
      bm_TGScannerConfig_char_2_token)

proc TGScannerConfig_symbol_2_token*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_symbol_2_token) shr
      bp_TGScannerConfig_symbol_2_token

proc TGScannerConfig_set_symbol_2_token*(a: PGScannerConfig,
    `symbol_2_token`: guint) =
  a.flag0 = a.flag0 or
      ((`symbol_2_token` shl bp_TGScannerConfig_symbol_2_token) and
      bm_TGScannerConfig_symbol_2_token)

proc TGScannerConfig_scope_0_fallback*(a: PGScannerConfig): guint =
  result = (a.flag0 and bm_TGScannerConfig_scope_0_fallback) shr
      bp_TGScannerConfig_scope_0_fallback

proc TGScannerConfig_set_scope_0_fallback*(a: PGScannerConfig,
    `scope_0_fallback`: guint) =
  a.flag0 = a.flag0 or
      ((`scope_0_fallback` shl bp_TGScannerConfig_scope_0_fallback) and
      bm_TGScannerConfig_scope_0_fallback)

proc freeze_symbol_table*(scanner: PGScanner) =
  if scanner == nil: discard

proc thaw_symbol_table*(scanner: PGScanner) =
  if scanner == nil: discard

