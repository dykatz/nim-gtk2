# Included by headers/gtk2.nim. GTK2.24 public builder/buildable APIs.
type
  TBuilder* {.pure, final, incompleteStruct.} = object
  PBuilder* = ptr TBuilder
  TBuildable* {.pure, final, incompleteStruct.} = object
  PBuildable* = ptr TBuildable
  TBuilderConnectFunc* = proc (builder: PBuilder, obj: PGObject,
    signalName, handlerName: cstring, connectObject: PGObject,
    flags: TGConnectFlags, data: pointer) {.cdecl.}
proc builder_get_type*(): GType {.cdecl, dynlib: lib, importc: "gtk_builder_get_type".}
proc builder_new*(): PBuilder {.cdecl, dynlib: lib, importc: "gtk_builder_new".}
proc builder_error_quark*(): TGQuark {.cdecl, dynlib: lib, importc: "gtk_builder_error_quark".}
proc builder_add_from_string*(builder: PBuilder, buffer: cstring, length: gsize, error: ptr ptr GError): guint {.cdecl, dynlib: lib, importc: "gtk_builder_add_from_string".}
proc builder_add_from_file*(builder: PBuilder, filename: cstring, error: ptr ptr GError): guint {.cdecl, dynlib: lib, importc: "gtk_builder_add_from_file".}
proc builder_get_object*(builder: PBuilder, name: cstring): PGObject {.cdecl, dynlib: lib, importc: "gtk_builder_get_object".}
proc builder_get_objects*(builder: PBuilder): PGSList {.cdecl, dynlib: lib, importc: "gtk_builder_get_objects".}
proc builder_connect_signals_full*(builder: PBuilder, fn: TBuilderConnectFunc, data: pointer) {.cdecl, dynlib: lib, importc: "gtk_builder_connect_signals_full".}
proc builder_set_translation_domain*(builder: PBuilder, domain: cstring) {.cdecl, dynlib: lib, importc: "gtk_builder_set_translation_domain".}
proc builder_get_translation_domain*(builder: PBuilder): cstring {.cdecl, dynlib: lib, importc: "gtk_builder_get_translation_domain".}
proc builder_get_type_from_name*(builder: PBuilder, name: cstring): GType {.cdecl, dynlib: lib, importc: "gtk_builder_get_type_from_name".}
proc buildable_get_type*(): GType {.cdecl, dynlib: lib, importc: "gtk_buildable_get_type".}
proc buildable_get_name*(obj: PBuildable): cstring {.cdecl, dynlib: lib, importc: "gtk_buildable_get_name".}
