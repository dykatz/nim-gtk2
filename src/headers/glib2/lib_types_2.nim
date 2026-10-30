# Included by headers/glib2.nim; do not import directly.
const
  G_MODULE_BIND_LAZY* = 1 shl 0
const
  G_MODULE_BIND_MASK* = 1

proc g_module_supported*(): gboolean{.cdecl, dynlib: gmodulelib,
                                      importc: "g_module_supported".}
proc g_module_open*(file_name: cstring, flags: TGModuleFlags): PGModule{.cdecl,
    dynlib: gmodulelib, importc: "g_module_open".}
proc close*(module: PGModule): gboolean{.cdecl, dynlib: gmodulelib,
    importc: "g_module_close".}
proc make_resident*(module: PGModule){.cdecl, dynlib: gmodulelib,
    importc: "g_module_make_resident".}
proc g_module_error*(): cstring{.cdecl, dynlib: gmodulelib,
                                 importc: "g_module_error".}
proc symbol*(module: PGModule, symbol_name: cstring, symbol: Pgpointer): gboolean{.
    cdecl, dynlib: gmodulelib, importc: "g_module_symbol".}
proc name*(module: PGModule): cstring{.cdecl, dynlib: gmodulelib,
    importc: "g_module_name".}
proc g_module_build_path*(directory: cstring, module_name: cstring): cstring{.
    cdecl, dynlib: gmodulelib, importc: "g_module_build_path".}
