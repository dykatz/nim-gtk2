# Included by headers/glib2.nim; do not import directly.
const
  G_CSET_A_2_Z_UCASE* = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const
  G_CSET_a_2_z_lcase* = "abcdefghijklmnopqrstuvwxyz"
const
  G_CSET_DIGITS* = "0123456789"

const
  bm_TGScannerConfig_case_sensitive* = 0x00000001'u32
const
  bp_TGScannerConfig_case_sensitive* = 0'u32
const
  bm_TGScannerConfig_skip_comment_multi* = 0x00000002'u32
const
  bp_TGScannerConfig_skip_comment_multi* = 1'u32
const
  bm_TGScannerConfig_skip_comment_single* = 0x00000004'u32
const
  bp_TGScannerConfig_skip_comment_single* = 2'u32
const
  bm_TGScannerConfig_scan_comment_multi* = 0x00000008'u32
const
  bp_TGScannerConfig_scan_comment_multi* = 3'u32
const
  bm_TGScannerConfig_scan_identifier* = 0x00000010'u32
const
  bp_TGScannerConfig_scan_identifier* = 4'u32
const
  bm_TGScannerConfig_scan_identifier_1char* = 0x00000020'u32
const
  bp_TGScannerConfig_scan_identifier_1char* = 5'u32
const
  bm_TGScannerConfig_scan_identifier_NULL* = 0x00000040'u32
const
  bp_TGScannerConfig_scan_identifier_NULL* = 6'u32
const
  bm_TGScannerConfig_scan_symbols* = 0x00000080'u32
const
  bp_TGScannerConfig_scan_symbols* = 7'u32
const
  bm_TGScannerConfig_scan_binary* = 0x00000100'u32
const
  bp_TGScannerConfig_scan_binary* = 8'u32
const
  bm_TGScannerConfig_scan_octal* = 0x00000200'u32
const
  bp_TGScannerConfig_scan_octal* = 9'u32
const
  bm_TGScannerConfig_scan_float* = 0x00000400'u32
const
  bp_TGScannerConfig_scan_float* = 10'u32
const
  bm_TGScannerConfig_scan_hex* = 0x00000800'u32
const
  bp_TGScannerConfig_scan_hex* = 11'u32
const
  bm_TGScannerConfig_scan_hex_dollar* = 0x00001000'u32
const
  bp_TGScannerConfig_scan_hex_dollar* = 12'u32
const
  bm_TGScannerConfig_scan_string_sq* = 0x00002000'u32
const
  bp_TGScannerConfig_scan_string_sq* = 13'u32
const
  bm_TGScannerConfig_scan_string_dq* = 0x00004000'u32
const
  bp_TGScannerConfig_scan_string_dq* = 14'u32
const
  bm_TGScannerConfig_numbers_2_int* = 0x00008000'u32
const
  bp_TGScannerConfig_numbers_2_int* = 15'u32
const
  bm_TGScannerConfig_int_2_float* = 0x00010000'u32
const
  bp_TGScannerConfig_int_2_float* = 16'u32
const
  bm_TGScannerConfig_identifier_2_string* = 0x00020000'u32
const
  bp_TGScannerConfig_identifier_2_string* = 17'u32
const
  bm_TGScannerConfig_char_2_token* = 0x00040000'u32
const
  bp_TGScannerConfig_char_2_token* = 18'u32
const
  bm_TGScannerConfig_symbol_2_token* = 0x00080000'u32
const
  bp_TGScannerConfig_symbol_2_token* = 19'u32
const
  bm_TGScannerConfig_scope_0_fallback* = 0x00100000'u32
const
  bp_TGScannerConfig_scope_0_fallback* = 20'u32

