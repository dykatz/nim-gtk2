# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SETTINGS*(): GType
proc SETTINGS*(obj: pointer): PSettings
proc SETTINGS_CLASS*(klass: pointer): PSettingsClass
proc IS_SETTINGS*(obj: pointer): bool
proc IS_SETTINGS_CLASS*(klass: pointer): bool
proc SETTINGS_GET_CLASS*(obj: pointer): PSettingsClass
proc settings_get_type*(): GType{.cdecl, dynlib: lib,
                                  importc: "gtk_settings_get_type".}
proc settings_get_for_screen*(screen: gdk2.PScreen): PSettings{.cdecl,
    dynlib: lib, importc: "gtk_settings_get_for_screen".}
proc settings_install_property*(pspec: PGParamSpec){.cdecl, dynlib: lib,
    importc: "gtk_settings_install_property".}
proc settings_install_property_parser*(pspec: PGParamSpec,
                                       parser: TRcPropertyParser){.cdecl,
    dynlib: lib, importc: "gtk_settings_install_property_parser".}
proc rc_property_parse_color*(pspec: PGParamSpec, gstring: PGString,
                              property_value: PGValue): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_rc_property_parse_color".}
proc rc_property_parse_enum*(pspec: PGParamSpec, gstring: PGString,
                             property_value: PGValue): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_rc_property_parse_enum".}
proc rc_property_parse_flags*(pspec: PGParamSpec, gstring: PGString,
                              property_value: PGValue): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_rc_property_parse_flags".}
proc rc_property_parse_requisition*(pspec: PGParamSpec, gstring: PGString,
                                    property_value: PGValue): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_rc_property_parse_requisition".}
proc rc_property_parse_border*(pspec: PGParamSpec, gstring: PGString,
                               property_value: PGValue): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_rc_property_parse_border".}
proc set_property_value*(settings: PSettings, name: cstring,
                                  svalue: PSettingsValue){.cdecl, dynlib: lib,
    importc: "gtk_settings_set_property_value".}
proc set_string_property*(settings: PSettings, name: cstring,
                                   v_string: cstring, origin: cstring){.cdecl,
    dynlib: lib, importc: "gtk_settings_set_string_property".}
proc set_long_property*(settings: PSettings, name: cstring,
                                 v_long: glong, origin: cstring){.cdecl,
    dynlib: lib, importc: "gtk_settings_set_long_property".}
proc set_double_property*(settings: PSettings, name: cstring,
                                   v_double: gdouble, origin: cstring){.cdecl,
    dynlib: lib, importc: "gtk_settings_set_double_property".}
proc settings_handle_event*(event: gdk2.PEventSetting){.cdecl, dynlib: lib,
    importc: "_gtk_settings_handle_event".}
proc rc_property_parser_from_type*(thetype: GType): TRcPropertyParser{.cdecl,
    dynlib: lib, importc: "_gtk_rc_property_parser_from_type".}
proc settings_parse_convert*(parser: TRcPropertyParser, src_value: PGValue,
                             pspec: PGParamSpec, dest_value: PGValue): gboolean{.
    cdecl, dynlib: lib, importc: "_gtk_settings_parse_convert".}
