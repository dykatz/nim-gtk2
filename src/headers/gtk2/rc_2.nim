# Included by headers/gtk2.nim; do not import directly.
proc RC_STYLE_get*(anObject: pointer): PRcStyle
proc RC_STYLE_CLASS*(klass: pointer): PRcStyleClass
proc IS_RC_STYLE*(anObject: pointer): bool
proc IS_RC_STYLE_CLASS*(klass: pointer): bool
proc RC_STYLE_GET_CLASS*(obj: pointer): PRcStyleClass
proc engine_specified*(a: PRcStyle): guint
proc set_engine_specified*(a: PRcStyle, `engine_specified`: guint)
proc rc_init*(){.cdecl, dynlib: lib, importc: "_gtk_rc_init".}
proc rc_add_default_file*(filename: cstring){.cdecl, dynlib: lib,
    importc: "gtk_rc_add_default_file".}
proc rc_set_default_files*(filenames: PPgchar){.cdecl, dynlib: lib,
    importc: "gtk_rc_set_default_files".}
proc rc_get_default_files*(): PPgchar{.cdecl, dynlib: lib,
                                       importc: "gtk_rc_get_default_files".}
proc rc_get_style*(widget: PWidget): PStyle{.cdecl, dynlib: lib,
    importc: "gtk_rc_get_style".}
proc rc_get_style_by_paths*(settings: PSettings, widget_path: cstring,
                            class_path: cstring, thetype: GType): PStyle{.cdecl,
    dynlib: lib, importc: "gtk_rc_get_style_by_paths".}
proc rc_reparse_all_for_settings*(settings: PSettings, force_load: gboolean): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_rc_reparse_all_for_settings".}
proc rc_find_pixmap_in_path*(settings: PSettings, scanner: PGScanner,
                             pixmap_file: cstring): cstring{.cdecl, dynlib: lib,
    importc: "gtk_rc_find_pixmap_in_path".}
proc rc_parse*(filename: cstring){.cdecl, dynlib: lib, importc: "gtk_rc_parse".}
proc rc_parse_string*(rc_string: cstring){.cdecl, dynlib: lib,
    importc: "gtk_rc_parse_string".}
proc rc_reparse_all*(): gboolean{.cdecl, dynlib: lib,
                                  importc: "gtk_rc_reparse_all".}
proc rc_style_get_type*(): GType{.cdecl, dynlib: lib,
                                  importc: "gtk_rc_style_get_type".}
proc rc_style_new*(): PRcStyle{.cdecl, dynlib: lib, importc: "gtk_rc_style_new".}
proc copy*(orig: PRcStyle): PRcStyle{.cdecl, dynlib: lib,
    importc: "gtk_rc_style_copy".}
proc reference*(rc_style: PRcStyle){.cdecl, dynlib: lib,
                                        importc: "gtk_rc_style_ref".}
proc unref*(rc_style: PRcStyle){.cdecl, dynlib: lib,
    importc: "gtk_rc_style_unref".}
proc rc_find_module_in_path*(module_file: cstring): cstring{.cdecl, dynlib: lib,
    importc: "gtk_rc_find_module_in_path".}
proc rc_get_theme_dir*(): cstring{.cdecl, dynlib: lib,
                                   importc: "gtk_rc_get_theme_dir".}
proc rc_get_module_dir*(): cstring{.cdecl, dynlib: lib,
                                    importc: "gtk_rc_get_module_dir".}
proc rc_get_im_module_path*(): cstring{.cdecl, dynlib: lib,
                                        importc: "gtk_rc_get_im_module_path".}
proc rc_get_im_module_file*(): cstring{.cdecl, dynlib: lib,
                                        importc: "gtk_rc_get_im_module_file".}
proc rc_scanner_new*(): PGScanner{.cdecl, dynlib: lib,
                                   importc: "gtk_rc_scanner_new".}
proc rc_parse_color*(scanner: PGScanner, color: gdk2.PColor): guint{.cdecl,
    dynlib: lib, importc: "gtk_rc_parse_color".}
proc rc_parse_state*(scanner: PGScanner, state: PStateType): guint{.cdecl,
    dynlib: lib, importc: "gtk_rc_parse_state".}
proc rc_parse_priority*(scanner: PGScanner, priority: PPathPriorityType): guint{.
    cdecl, dynlib: lib, importc: "gtk_rc_parse_priority".}
proc lookup_rc_property*(rc_style: PRcStyle, type_name: TGQuark,
                                  property_name: TGQuark): PRcProperty{.cdecl,
    dynlib: lib, importc: "_gtk_rc_style_lookup_rc_property".}
