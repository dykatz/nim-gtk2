# Included by headers/glib2.nim; do not import directly.
proc TGScannerConfig_case_sensitive*(a: PGScannerConfig): guint
proc TGScannerConfig_set_case_sensitive*(a: PGScannerConfig,
    `case_sensitive`: guint)
proc TGScannerConfig_skip_comment_multi*(a: PGScannerConfig): guint
proc TGScannerConfig_set_skip_comment_multi*(a: PGScannerConfig,
    `skip_comment_multi`: guint)
proc TGScannerConfig_skip_comment_single*(a: PGScannerConfig): guint
proc TGScannerConfig_set_skip_comment_single*(a: PGScannerConfig,
    `skip_comment_single`: guint)
proc TGScannerConfig_scan_comment_multi*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scan_comment_multi*(a: PGScannerConfig,
    `scan_comment_multi`: guint)
proc TGScannerConfig_scan_identifier*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scan_identifier*(a: PGScannerConfig,
    `scan_identifier`: guint)
proc TGScannerConfig_scan_identifier_1char*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scan_identifier_1char*(a: PGScannerConfig,
    `scan_identifier_1char`: guint)
proc TGScannerConfig_scan_identifier_NULL*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scan_identifier_NULL*(a: PGScannerConfig,
    `scan_identifier_NULL`: guint)
proc TGScannerConfig_scan_symbols*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scan_symbols*(a: PGScannerConfig,
                                       `scan_symbols`: guint)
proc TGScannerConfig_scan_binary*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scan_binary*(a: PGScannerConfig,
                                      `scan_binary`: guint)
proc TGScannerConfig_scan_octal*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scan_octal*(a: PGScannerConfig, `scan_octal`: guint)
proc TGScannerConfig_scan_float*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scan_float*(a: PGScannerConfig, `scan_float`: guint)
proc TGScannerConfig_scan_hex*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scan_hex*(a: PGScannerConfig, `scan_hex`: guint)
proc TGScannerConfig_scan_hex_dollar*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scan_hex_dollar*(a: PGScannerConfig,
    `scan_hex_dollar`: guint)
proc TGScannerConfig_scan_string_sq*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scan_string_sq*(a: PGScannerConfig,
    `scan_string_sq`: guint)
proc TGScannerConfig_scan_string_dq*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scan_string_dq*(a: PGScannerConfig,
    `scan_string_dq`: guint)
proc TGScannerConfig_numbers_2_int*(a: PGScannerConfig): guint
proc TGScannerConfig_set_numbers_2_int*(a: PGScannerConfig,
                                        `numbers_2_int`: guint)
proc TGScannerConfig_int_2_float*(a: PGScannerConfig): guint
proc TGScannerConfig_set_int_2_float*(a: PGScannerConfig,
                                      `int_2_float`: guint)
proc TGScannerConfig_identifier_2_string*(a: PGScannerConfig): guint
proc TGScannerConfig_set_identifier_2_string*(a: PGScannerConfig,
    `identifier_2_string`: guint)
proc TGScannerConfig_char_2_token*(a: PGScannerConfig): guint
proc TGScannerConfig_set_char_2_token*(a: PGScannerConfig,
                                       `char_2_token`: guint)
proc TGScannerConfig_symbol_2_token*(a: PGScannerConfig): guint
proc TGScannerConfig_set_symbol_2_token*(a: PGScannerConfig,
    `symbol_2_token`: guint)
proc TGScannerConfig_scope_0_fallback*(a: PGScannerConfig): guint
proc TGScannerConfig_set_scope_0_fallback*(a: PGScannerConfig,
    `scope_0_fallback`: guint)
proc new*(config_templ: PGScannerConfig): PGScanner{.cdecl,
    dynlib: gliblib, importc: "g_scanner_new".}
proc destroy*(scanner: PGScanner){.cdecl, dynlib: gliblib,
    importc: "g_scanner_destroy".}
proc input_file*(scanner: PGScanner, input_fd: gint){.cdecl,
    dynlib: gliblib, importc: "g_scanner_input_file".}
proc sync_file_offset*(scanner: PGScanner){.cdecl, dynlib: gliblib,
    importc: "g_scanner_sync_file_offset".}
proc input_text*(scanner: PGScanner, text: cstring, text_len: guint){.
    cdecl, dynlib: gliblib, importc: "g_scanner_input_text".}
proc get_next_token*(scanner: PGScanner): TGTokenType{.cdecl,
    dynlib: gliblib, importc: "g_scanner_get_next_token".}
proc peek_next_token*(scanner: PGScanner): TGTokenType{.cdecl,
    dynlib: gliblib, importc: "g_scanner_peek_next_token".}
proc cur_token*(scanner: PGScanner): TGTokenType{.cdecl,
    dynlib: gliblib, importc: "g_scanner_cur_token".}
proc cur_value*(scanner: PGScanner): TGTokenValue{.cdecl,
    dynlib: gliblib, importc: "g_scanner_cur_value".}
proc cur_line*(scanner: PGScanner): guint{.cdecl, dynlib: gliblib,
    importc: "g_scanner_cur_line".}
proc cur_position*(scanner: PGScanner): guint{.cdecl, dynlib: gliblib,
    importc: "g_scanner_cur_position".}
proc eof*(scanner: PGScanner): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_scanner_eof".}
proc set_scope*(scanner: PGScanner, scope_id: guint): guint{.cdecl,
    dynlib: gliblib, importc: "g_scanner_set_scope".}
proc scope_add_symbol*(scanner: PGScanner, scope_id: guint,
                                 symbol: cstring, value: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_scanner_scope_add_symbol".}
proc scope_remove_symbol*(scanner: PGScanner, scope_id: guint,
                                    symbol: cstring){.cdecl, dynlib: gliblib,
    importc: "g_scanner_scope_remove_symbol".}
proc scope_lookup_symbol*(scanner: PGScanner, scope_id: guint,
                                    symbol: cstring): gpointer{.cdecl,
    dynlib: gliblib, importc: "g_scanner_scope_lookup_symbol".}
proc scope_foreach_symbol*(scanner: PGScanner, scope_id: guint,
                                     fn: TGHFunc, user_data: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_scanner_scope_foreach_symbol".}
proc lookup_symbol*(scanner: PGScanner, symbol: cstring): gpointer{.
    cdecl, dynlib: gliblib, importc: "g_scanner_lookup_symbol".}
proc unexp_token*(scanner: PGScanner, expected_token: TGTokenType,
                            identifier_spec: cstring, symbol_spec: cstring,
                            symbol_name: cstring, `message`: cstring,
                            is_error: gint){.cdecl, dynlib: gliblib,
    importc: "g_scanner_unexp_token".}
