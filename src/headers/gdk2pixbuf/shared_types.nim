# Included by headers/gdk2pixbuf.nim; do not import directly.
type
  TPixbuf* {.pure, final, incompleteStruct.} = object
  PPixbuf* = ptr TPixbuf
  TPixbufAnimation = object
  PPixbufAnimation* = ptr TPixbufAnimation
  TPixbufAnimationIter = object
  PPixbufAnimationIter* = ptr TPixbufAnimationIter
  TPixbufAlphaMode* {.size: sizeof(cint).} = enum
    PIXBUF_ALPHA_BILEVEL, PIXBUF_ALPHA_FULL
  PPixbufAlphaMode* = ptr TPixbufAlphaMode
  TColorspace* {.size: sizeof(cint).} = enum
    COLORSPACE_RGB
  PColorspace* = ptr TColorspace
  TPixbufDestroyNotify* = proc (pixels: Pguchar, data: gpointer){.cdecl.}
  TPixbufError* {.size: sizeof(cint).} = enum
    PIXBUF_ERROR_CORRUPT_IMAGE, PIXBUF_ERROR_INSUFFICIENT_MEMORY,
    PIXBUF_ERROR_BAD_OPTION, PIXBUF_ERROR_UNKNOWN_TYPE,
    PIXBUF_ERROR_UNSUPPORTED_OPERATION, PIXBUF_ERROR_FAILED,
    PIXBUF_ERROR_INCOMPLETE_ANIMATION
  PPixbufError* = ptr TPixbufError
  TInterpType* {.size: sizeof(cint).} = enum
    INTERP_NEAREST, INTERP_TILES, INTERP_BILINEAR, INTERP_HYPER

  PInterpType* = ptr TInterpType
