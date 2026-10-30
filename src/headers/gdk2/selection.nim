# Included by headers/gdk2.nim; do not import directly.
proc selection_owner_set_for_display*(display: PDisplay, owner: PWindow,
                                      selection: TAtom, time: guint32,
                                      send_event: gboolean): gboolean{.cdecl,
    dynlib: lib, importc: "gdk_selection_owner_set_for_display".}
proc selection_owner_get_for_display*(display: PDisplay, selection: TAtom): PWindow{.
    cdecl, dynlib: lib, importc: "gdk_selection_owner_get_for_display".}
proc selection_convert*(requestor: PWindow, selection: TAtom, target: TAtom,
                        time: guint32){.cdecl, dynlib: lib,
                                        importc: "gdk_selection_convert".}
proc selection_property_get*(requestor: PWindow, data: PPguchar,
                             prop_type: PAtom, prop_format: Pgint): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_selection_property_get".}
proc selection_send_notify_for_display*(display: PDisplay, requestor: guint32,
                                        selection: TAtom, target: TAtom,
                                        `property`: TAtom, time: guint32){.
    cdecl, dynlib: lib, importc: "gdk_selection_send_notify_for_display".}
