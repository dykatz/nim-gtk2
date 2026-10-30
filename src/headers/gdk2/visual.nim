# Included by headers/gdk2.nim; do not import directly.
proc TYPE_VISUAL*(): GType
proc VISUAL*(anObject: pointer): PVisual
proc VISUAL_CLASS*(klass: pointer): PVisualClass
proc IS_VISUAL*(anObject: pointer): bool
proc IS_VISUAL_CLASS*(klass: pointer): bool
proc VISUAL_GET_CLASS*(obj: pointer): PVisualClass
proc visual_get_type*(): GType{.cdecl, dynlib: lib,
                                importc: "gdk_visual_get_type".}
