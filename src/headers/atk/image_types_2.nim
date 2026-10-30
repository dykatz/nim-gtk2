# Included by headers/atk.nim; do not import directly.
type
  TImageIface* = object of TGTypeInterface
    get_image_position*: proc (image: PImage, x: Pgint, y: Pgint,
                               coord_type: TCoordType){.cdecl.}
    get_image_description*: proc (image: PImage): cstring{.cdecl.}
    get_image_size*: proc (image: PImage, width: Pgint, height: Pgint){.cdecl.}
    set_image_description*: proc (image: PImage, description: cstring): gboolean{.
        cdecl.}
    pad15*: TFunction
    pad16*: TFunction

  PImageIface* = ptr TImageIface
