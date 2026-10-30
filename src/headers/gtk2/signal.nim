# Included by headers/gtk2.nim; do not import directly.
proc signal_connect_full*(anObject: PObject, name: cstring, fun: TSignalFunc,
                          unknown1: pointer, func_data: gpointer,
                          unknown2: pointer, unknown3, unknown4: int): gulong{.
    importc: "gtk_signal_connect_full", cdecl, dynlib: lib.}
proc signal_compat_matched*(anObject: PObject, fun: TSignalFunc,
                            data: gpointer, m: TGSignalMatchType, u: int){.
    importc: "gtk_signal_compat_matched", cdecl, dynlib: lib.}
