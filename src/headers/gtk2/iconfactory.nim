# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ICON_FACTORY*(): GType
proc ICON_FACTORY*(anObject: pointer): PIconFactory
proc ICON_FACTORY_CLASS*(klass: pointer): PIconFactoryClass
proc IS_ICON_FACTORY*(anObject: pointer): bool
proc IS_ICON_FACTORY_CLASS*(klass: pointer): bool
proc ICON_FACTORY_GET_CLASS*(obj: pointer): PIconFactoryClass
proc TYPE_ICON_SET*(): GType
proc TYPE_ICON_SOURCE*(): GType
proc icon_factory_get_type*(): GType{.cdecl, dynlib: lib,
                                      importc: "gtk_icon_factory_get_type".}
proc icon_factory_new*(): PIconFactory{.cdecl, dynlib: lib,
                                        importc: "gtk_icon_factory_new".}
proc add*(factory: PIconFactory, stock_id: cstring,
                       icon_set: PIconSet){.cdecl, dynlib: lib,
    importc: "gtk_icon_factory_add".}
proc lookup*(factory: PIconFactory, stock_id: cstring): PIconSet{.
    cdecl, dynlib: lib, importc: "gtk_icon_factory_lookup".}
proc add_default*(factory: PIconFactory){.cdecl, dynlib: lib,
    importc: "gtk_icon_factory_add_default".}
proc remove_default*(factory: PIconFactory){.cdecl, dynlib: lib,
    importc: "gtk_icon_factory_remove_default".}
proc icon_factory_lookup_default*(stock_id: cstring): PIconSet{.cdecl,
    dynlib: lib, importc: "gtk_icon_factory_lookup_default".}
proc icon_size_lookup*(size: TIconSize, width: Pgint, height: Pgint): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_icon_size_lookup".}
proc icon_size_register*(name: cstring, width: gint, height: gint): TIconSize{.
    cdecl, dynlib: lib, importc: "gtk_icon_size_register".}
proc icon_size_register_alias*(alias: cstring, target: TIconSize){.cdecl,
    dynlib: lib, importc: "gtk_icon_size_register_alias".}
proc icon_size_from_name*(name: cstring): TIconSize{.cdecl, dynlib: lib,
    importc: "gtk_icon_size_from_name".}
proc icon_size_get_name*(size: TIconSize): cstring{.cdecl, dynlib: lib,
    importc: "gtk_icon_size_get_name".}
proc icon_set_get_type*(): GType{.cdecl, dynlib: lib,
                                  importc: "gtk_icon_set_get_type".}
proc icon_set_new*(): PIconSet{.cdecl, dynlib: lib, importc: "gtk_icon_set_new".}
proc icon_set_new_from_pixbuf*(pixbuf: gdk2pixbuf.PPixbuf): PIconSet{.cdecl,
    dynlib: lib, importc: "gtk_icon_set_new_from_pixbuf".}
proc reference*(icon_set: PIconSet): PIconSet{.cdecl, dynlib: lib,
    importc: "gtk_icon_set_ref".}
proc unref*(icon_set: PIconSet){.cdecl, dynlib: lib,
    importc: "gtk_icon_set_unref".}
proc copy*(icon_set: PIconSet): PIconSet{.cdecl, dynlib: lib,
    importc: "gtk_icon_set_copy".}
proc render_icon*(icon_set: PIconSet, style: PStyle,
                           direction: TTextDirection, state: TStateType,
                           size: TIconSize, widget: PWidget, detail: cstring): gdk2pixbuf.PPixbuf{.
    cdecl, dynlib: lib, importc: "gtk_icon_set_render_icon".}
proc add_source*(icon_set: PIconSet, source: PIconSource){.cdecl,
    dynlib: lib, importc: "gtk_icon_set_add_source".}
proc get_sizes*(icon_set: PIconSet, sizes: PPGtkIconSize,
                         n_sizes: Pgint){.cdecl, dynlib: lib,
    importc: "gtk_icon_set_get_sizes".}
proc icon_source_get_type*(): GType{.cdecl, dynlib: lib,
                                     importc: "gtk_icon_source_get_type".}
proc icon_source_new*(): PIconSource{.cdecl, dynlib: lib,
                                      importc: "gtk_icon_source_new".}
proc copy*(source: PIconSource): PIconSource{.cdecl, dynlib: lib,
    importc: "gtk_icon_source_copy".}
proc free*(source: PIconSource){.cdecl, dynlib: lib,
    importc: "gtk_icon_source_free".}
proc set_filename*(source: PIconSource, filename: cstring){.cdecl,
    dynlib: lib, importc: "gtk_icon_source_set_filename".}
proc set_pixbuf*(source: PIconSource, pixbuf: gdk2pixbuf.PPixbuf){.cdecl,
    dynlib: lib, importc: "gtk_icon_source_set_pixbuf".}
proc get_filename*(source: PIconSource): cstring{.cdecl,
    dynlib: lib, importc: "gtk_icon_source_get_filename".}
proc get_pixbuf*(source: PIconSource): gdk2pixbuf.PPixbuf{.cdecl,
    dynlib: lib, importc: "gtk_icon_source_get_pixbuf".}
proc set_direction_wildcarded*(source: PIconSource,
    setting: gboolean){.cdecl, dynlib: lib,
                        importc: "gtk_icon_source_set_direction_wildcarded".}
proc set_state_wildcarded*(source: PIconSource, setting: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_icon_source_set_state_wildcarded".}
proc set_size_wildcarded*(source: PIconSource, setting: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_icon_source_set_size_wildcarded".}
proc get_size_wildcarded*(source: PIconSource): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_icon_source_get_size_wildcarded".}
proc get_state_wildcarded*(source: PIconSource): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_icon_source_get_state_wildcarded".}
proc get_direction_wildcarded*(source: PIconSource): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_icon_source_get_direction_wildcarded".}
proc set_direction*(source: PIconSource, direction: TTextDirection){.
    cdecl, dynlib: lib, importc: "gtk_icon_source_set_direction".}
proc set_state*(source: PIconSource, state: TStateType){.cdecl,
    dynlib: lib, importc: "gtk_icon_source_set_state".}
proc set_size*(source: PIconSource, size: TIconSize){.cdecl,
    dynlib: lib, importc: "gtk_icon_source_set_size".}
proc get_direction*(source: PIconSource): TTextDirection{.cdecl,
    dynlib: lib, importc: "gtk_icon_source_get_direction".}
proc get_state*(source: PIconSource): TStateType{.cdecl,
    dynlib: lib, importc: "gtk_icon_source_get_state".}
proc get_size*(source: PIconSource): TIconSize{.cdecl, dynlib: lib,
    importc: "gtk_icon_source_get_size".}
proc icon_set_invalidate_caches*(){.cdecl, dynlib: lib,
                                    importc: "_gtk_icon_set_invalidate_caches".}
proc icon_factory_list_ids*(): PGSList{.cdecl, dynlib: lib,
                                        importc: "_gtk_icon_factory_list_ids".}
