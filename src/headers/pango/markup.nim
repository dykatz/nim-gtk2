# Included by headers/pango.nim; do not import directly.
proc parse_markup*(markup_text: cstring, length: int32, accel_marker: gunichar,
                   attr_list: var PAttrList, text: PPchar,
                   accel_char: Pgunichar, error: pointer): gboolean{.cdecl,
    dynlib: lib, importc: "pango_parse_markup".}
const
  bm_TPangoLogAttr_is_line_break* = 0x0001'u16
const
  bp_TPangoLogAttr_is_line_break* = 0'u16
const
  bm_TPangoLogAttr_is_mandatory_break* = 0x0002'u16
const
  bp_TPangoLogAttr_is_mandatory_break* = 1'u16
const
  bm_TPangoLogAttr_is_char_break* = 0x0004'u16
const
  bp_TPangoLogAttr_is_char_break* = 2'u16
const
  bm_TPangoLogAttr_is_white* = 0x0008'u16
const
  bp_TPangoLogAttr_is_white* = 3'u16
const
  bm_TPangoLogAttr_is_cursor_position* = 0x0010'u16
const
  bp_TPangoLogAttr_is_cursor_position* = 4'u16
const
  bm_TPangoLogAttr_is_word_start* = 0x0020'u16
const
  bp_TPangoLogAttr_is_word_start* = 5'u16
const
  bm_TPangoLogAttr_is_word_end* = 0x0040'u16
const
  bp_TPangoLogAttr_is_word_end* = 6'u16
const
  bm_TPangoLogAttr_is_sentence_boundary* = 0x0080'u16
const
  bp_TPangoLogAttr_is_sentence_boundary* = 7'u16
const
  bm_TPangoLogAttr_is_sentence_start* = 0x0100'u16
const
  bp_TPangoLogAttr_is_sentence_start* = 8'u16
const
  bm_TPangoLogAttr_is_sentence_end* = 0x0200'u16
const
  bp_TPangoLogAttr_is_sentence_end* = 9'u16

