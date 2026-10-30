# Included by headers/gdk2.nim; do not import directly.
proc TYPE_FONT*(): GType
proc font_get_type*(): GType{.cdecl, dynlib: lib, importc: "gdk_font_get_type".}
proc font_load_for_display*(display: PDisplay, font_name: cstring): PFont{.
    cdecl, dynlib: lib, importc: "gdk_font_load_for_display".}
proc fontset_load_for_display*(display: PDisplay, fontset_name: cstring): PFont{.
    cdecl, dynlib: lib, importc: "gdk_fontset_load_for_display".}
proc font_from_description_for_display*(display: PDisplay,
                                        font_desc: PFontDescription): PFont{.
    cdecl, dynlib: lib, importc: "gdk_font_from_description_for_display".}
proc reference*(font: PFont): PFont{.cdecl, dynlib: lib, importc: "gdk_font_ref".}
proc unref*(font: PFont){.cdecl, dynlib: lib, importc: "gdk_font_unref".}
proc id*(font: PFont): gint{.cdecl, dynlib: lib, importc: "gdk_font_id".}
proc equal*(fonta: PFont, fontb: PFont): gboolean{.cdecl, dynlib: lib,
    importc: "gdk_font_equal".}
proc string_width*(font: PFont, `string`: cstring): gint{.cdecl, dynlib: lib,
    importc: "gdk_string_width".}
proc text_width*(font: PFont, text: cstring, text_length: gint): gint{.cdecl,
    dynlib: lib, importc: "gdk_text_width".}
proc text_width_wc*(font: PFont, text: PWChar, text_length: gint): gint{.cdecl,
    dynlib: lib, importc: "gdk_text_width_wc".}
proc char_width*(font: PFont, character: gchar): gint{.cdecl, dynlib: lib,
    importc: "gdk_char_width".}
proc char_width_wc*(font: PFont, character: TWChar): gint{.cdecl, dynlib: lib,
    importc: "gdk_char_width_wc".}
proc string_measure*(font: PFont, `string`: cstring): gint{.cdecl, dynlib: lib,
    importc: "gdk_string_measure".}
proc text_measure*(font: PFont, text: cstring, text_length: gint): gint{.cdecl,
    dynlib: lib, importc: "gdk_text_measure".}
proc char_measure*(font: PFont, character: gchar): gint{.cdecl, dynlib: lib,
    importc: "gdk_char_measure".}
proc string_height*(font: PFont, `string`: cstring): gint{.cdecl, dynlib: lib,
    importc: "gdk_string_height".}
proc text_height*(font: PFont, text: cstring, text_length: gint): gint{.cdecl,
    dynlib: lib, importc: "gdk_text_height".}
proc char_height*(font: PFont, character: gchar): gint{.cdecl, dynlib: lib,
    importc: "gdk_char_height".}
proc text_extents*(font: PFont, text: cstring, text_length: gint,
                   lbearing: Pgint, rbearing: Pgint, width: Pgint,
                   ascent: Pgint, descent: Pgint){.cdecl, dynlib: lib,
    importc: "gdk_text_extents".}
proc text_extents_wc*(font: PFont, text: PWChar, text_length: gint,
                      lbearing: Pgint, rbearing: Pgint, width: Pgint,
                      ascent: Pgint, descent: Pgint){.cdecl, dynlib: lib,
    importc: "gdk_text_extents_wc".}
proc string_extents*(font: PFont, `string`: cstring, lbearing: Pgint,
                     rbearing: Pgint, width: Pgint, ascent: Pgint,
                     descent: Pgint){.cdecl, dynlib: lib,
                                      importc: "gdk_string_extents".}
proc get_display*(font: PFont): PDisplay{.cdecl, dynlib: lib,
    importc: "gdk_font_get_display".}
