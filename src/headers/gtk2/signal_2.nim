# Included by headers/gtk2.nim; do not import directly.
proc signal_new*(name: cstring, signal_flags: TSignalRunType,
                 object_type: TType, function_offset: guint,
                 marshaller: TSignalMarshaller, return_val: TType, n_args: guint): guint{.
    varargs, importc: "gtk_signal_new", cdecl, dynlib: lib.}
proc signal_emit*(anObject: PObject, signal_id: guint){.varargs, cdecl,
    importc: "gtk_signal_emit", dynlib: lib.}
proc signal_emit_by_name*(anObject: PObject, name: cstring){.varargs, cdecl,
    importc: "gtk_signal_emit_by_name", dynlib: lib.}
