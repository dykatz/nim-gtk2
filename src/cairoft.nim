#
# Translation of cairo-ft.h
# by Jeffrey Pohlmeyer
# updated to version 1.4 by Luiz Américo Pereira Câmara 2007
#

import
  cairo, freetype

include "cairo_pragma.nim"
#todo: properly define FcPattern:
#It will require translate FontConfig header

#*
#typedef struct _XftPattern {
#  int		    num;
#  int		    size;
#  XftPatternElt   *elts;
# } XftPattern;
# typedef FcPattern XftPattern;
#

type
  FcPattern* = pointer
  PFcPattern* = ptr FcPattern

proc ftFontFaceCreateForPattern*(pattern: PFcPattern): ptr FontFace {.libcairo, importc: "cairo_ft_font_face_create_for_pattern".}
proc ftFontOptionsSubstitute*(options: ptr FontOptions, pattern: PFcPattern){. libcairo, importc: "cairo_ft_font_options_substitute".}
proc ftFontFaceCreateForFtFace*(face: FT_Face, load_flags: int32): ptr FontFace {.libcairo, importc: "cairo_ft_font_face_create_for_ft_face".}
proc ftScaledFontLockFace*(scaled_font: ptr ScaledFont): FT_Face {.libcairo, importc: "cairo_ft_scaled_font_lock_face".}
proc ftScaledFontUnlockFace*(scaled_font: ptr ScaledFont) {.libcairo, importc: "cairo_ft_scaled_font_unlock_face".}
