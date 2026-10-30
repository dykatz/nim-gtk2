# Included by headers/glib2.nim; do not import directly.
proc init*(value: PGValue, g_type: GType): PGValue{.cdecl,
    dynlib: gobjectlib, importc: "g_value_init".}
proc copy*(src_value: PGValue, dest_value: PGValue){.cdecl,
    dynlib: gobjectlib, importc: "g_value_copy".}
proc reset*(value: PGValue): PGValue{.cdecl, dynlib: gobjectlib,
    importc: "g_value_reset".}
proc unset*(value: PGValue){.cdecl, dynlib: gobjectlib,
                                     importc: "g_value_unset".}
proc set_instance*(value: PGValue, instance: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_instance".}
proc fits_pointer*(value: PGValue): gboolean{.cdecl, dynlib: gobjectlib,
    importc: "g_value_fits_pointer".}
proc peek_pointer*(value: PGValue): gpointer{.cdecl, dynlib: gobjectlib,
    importc: "g_value_peek_pointer".}
proc g_value_type_compatible*(src_type: GType, dest_type: GType): gboolean{.
    cdecl, dynlib: gobjectlib, importc: "g_value_type_compatible".}
proc g_value_type_transformable*(src_type: GType, dest_type: GType): gboolean{.
    cdecl, dynlib: gobjectlib, importc: "g_value_type_transformable".}
proc transform*(src_value: PGValue, dest_value: PGValue): gboolean{.
    cdecl, dynlib: gobjectlib, importc: "g_value_transform".}
proc g_value_register_transform_func*(src_type: GType, dest_type: GType,
                                      transform_func: TGValueTransform){.cdecl,
    dynlib: gobjectlib, importc: "g_value_register_transform_func".}
const
  G_VALUE_NOCOPY_CONTENTS* = 1 shl 27

