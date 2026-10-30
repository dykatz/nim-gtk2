# Included by headers/gdk2.nim; do not import directly.
proc DEVICE*(anObject: pointer): PDevice
proc DEVICE_CLASS*(klass: pointer): PDeviceClass
proc IS_DEVICE*(anObject: pointer): bool
proc IS_DEVICE_CLASS*(klass: pointer): bool
proc DEVICE_GET_CLASS*(obj: pointer): PDeviceClass
proc device_get_type*(): GType{.cdecl, dynlib: lib,
                                importc: "gdk_device_get_type".}
proc set_source*(device: PDevice, source: TInputSource){.cdecl,
    dynlib: lib, importc: "gdk_device_set_source".}
proc set_mode*(device: PDevice, mode: TInputMode): gboolean{.cdecl,
    dynlib: lib, importc: "gdk_device_set_mode".}
proc set_key*(device: PDevice, index: guint, keyval: guint,
                     modifiers: TModifierType){.cdecl, dynlib: lib,
    importc: "gdk_device_set_key".}
proc set_axis_use*(device: PDevice, index: guint, use: TAxisUse){.cdecl,
    dynlib: lib, importc: "gdk_device_set_axis_use".}
proc get_state*(device: PDevice, window: PWindow, axes: Pgdouble,
                       mask: PModifierType){.cdecl, dynlib: lib,
    importc: "gdk_device_get_state".}
proc get_history*(device: PDevice, window: PWindow, start: guint32,
                         stop: guint32, s: var PPTimeCoord, n_events: Pgint): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_device_get_history".}
proc device_free_history*(events: PPTimeCoord, n_events: gint){.cdecl,
    dynlib: lib, importc: "gdk_device_free_history".}
proc get_axis*(device: PDevice, axes: Pgdouble, use: TAxisUse,
                      value: Pgdouble): gboolean{.cdecl, dynlib: lib,
    importc: "gdk_device_get_axis".}
proc input_set_extension_events*(window: PWindow, mask: gint,
                                 mode: TExtensionMode){.cdecl, dynlib: lib,
    importc: "gdk_input_set_extension_events".}
proc device_get_core_pointer*(): PDevice{.cdecl, dynlib: lib,
    importc: "gdk_device_get_core_pointer".}
proc TYPE_KEYMAP*(): GType
