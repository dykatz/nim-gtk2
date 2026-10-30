# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SCROLLBAR*(): GType
proc SCROLLBAR*(obj: pointer): PScrollbar
proc SCROLLBAR_CLASS*(klass: pointer): PScrollbarClass
proc IS_SCROLLBAR*(obj: pointer): bool
proc IS_SCROLLBAR_CLASS*(klass: pointer): bool
proc SCROLLBAR_GET_CLASS*(obj: pointer): PScrollbarClass
proc scrollbar_get_type*(): TType{.cdecl, dynlib: lib,
                                   importc: "gtk_scrollbar_get_type".}
