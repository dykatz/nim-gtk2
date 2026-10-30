# Included by headers/gtk2.nim; do not import directly.
proc TYPE_FILE_FILTER*(): GType
proc FILE_FILTER*(obj: pointer): PFileFilter
proc IS_FILE_FILTER*(obj: pointer): gboolean
proc file_filter_get_type*(): GType{.cdecl, dynlib: lib,
                                     importc: "gtk_file_filter_get_type".}
proc file_filter_new*(): PFileFilter{.cdecl, dynlib: lib,
                                      importc: "gtk_file_filter_new".}
proc set_name*(filter: PFileFilter, name: cstring){.cdecl,
    dynlib: lib, importc: "gtk_file_filter_set_name".}
proc get_name*(filter: PFileFilter): cstring{.cdecl, dynlib: lib,
    importc: "gtk_file_filter_get_name".}
proc add_mime_type*(filter: PFileFilter, mime_type: cstring){.cdecl,
    dynlib: lib, importc: "gtk_file_filter_add_mime_type".}
proc add_pattern*(filter: PFileFilter, pattern: cstring){.cdecl,
    dynlib: lib, importc: "gtk_file_filter_add_pattern".}
proc add_custom*(filter: PFileFilter, needed: TFileFilterFlags,
                             fn: TFileFilterFunc, data: gpointer,
                             notify: TGDestroyNotify){.cdecl, dynlib: lib,
    importc: "gtk_file_filter_add_custom".}
proc get_needed*(filter: PFileFilter): TFileFilterFlags{.cdecl,
    dynlib: lib, importc: "gtk_file_filter_get_needed".}
proc filter*(filter: PFileFilter, filter_info: PFileFilterInfo): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_file_filter_filter".}
proc TYPE_FILE_FILTER(): GType =
  result = file_filter_get_type()

proc FILE_FILTER(obj: pointer): PFileFilter =
  result = cast[PFileFilter](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_FILE_FILTER()))

proc IS_FILE_FILTER(obj: pointer): gboolean =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_FILE_FILTER())

