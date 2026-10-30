# Included by headers/atk.nim; do not import directly.
proc TYPE_IMAGE*(): GType
proc IS_IMAGE*(obj: pointer): bool
proc IMAGE*(obj: pointer): PImage
proc IMAGE_GET_IFACE*(obj: pointer): PImageIface
proc image_get_type*(): GType{.cdecl, dynlib: lib, importc: "atk_image_get_type".}
proc get_image_description*(image: PImage): cstring{.cdecl, dynlib: lib,
    importc: "atk_image_get_image_description".}
proc get_image_size*(image: PImage, width: Pgint, height: Pgint){.cdecl,
    dynlib: lib, importc: "atk_image_get_image_size".}
proc set_image_description*(image: PImage, description: cstring): gboolean{.
    cdecl, dynlib: lib, importc: "atk_image_set_image_description".}
proc get_image_position*(image: PImage, x: Pgint, y: Pgint,
                               coord_type: TCoordType){.cdecl, dynlib: lib,
    importc: "atk_image_get_image_position".}
