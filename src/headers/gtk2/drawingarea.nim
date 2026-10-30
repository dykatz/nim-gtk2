# Included by headers/gtk2.nim; do not import directly.
proc TYPE_DRAWING_AREA*(): GType
proc DRAWING_AREA*(obj: pointer): PDrawingArea
proc DRAWING_AREA_CLASS*(klass: pointer): PDrawingAreaClass
proc IS_DRAWING_AREA*(obj: pointer): bool
proc IS_DRAWING_AREA_CLASS*(klass: pointer): bool
proc DRAWING_AREA_GET_CLASS*(obj: pointer): PDrawingAreaClass
proc drawing_area_get_type*(): TType{.cdecl, dynlib: lib,
                                      importc: "gtk_drawing_area_get_type".}
proc drawing_area_new*(): PDrawingArea{.cdecl, dynlib: lib,
                                        importc: "gtk_drawing_area_new".}
