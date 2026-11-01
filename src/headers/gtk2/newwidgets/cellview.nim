# Generated from gtkcellview.h; included by headers/gtk2.nim.
proc cell_view_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_cell_view_get_type".}
proc cell_view_new*(): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_cell_view_new".}
proc cell_view_new_with_text*(`text`: cstring): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_cell_view_new_with_text".}
proc cell_view_new_with_markup*(`markup`: cstring): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_cell_view_new_with_markup".}
proc cell_view_new_with_pixbuf*(`pixbuf`: gdk2pixbuf.PPixbuf): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_cell_view_new_with_pixbuf".}
proc cell_view_set_model*(`cell_view`: ptr CellView; `model`: ptr TTreeModel) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_cell_view_set_model".}
proc cell_view_get_model*(`cell_view`: ptr CellView): ptr TTreeModel {.cdecl, gcsafe, dynlib: lib, importc: "gtk_cell_view_get_model".}
proc cell_view_set_displayed_row*(`cell_view`: ptr CellView; `path`: ptr TTreePath) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_cell_view_set_displayed_row".}
proc cell_view_get_displayed_row*(`cell_view`: ptr CellView): ptr TTreePath {.cdecl, gcsafe, dynlib: lib, importc: "gtk_cell_view_get_displayed_row".}
proc cell_view_get_size_of_row*(`cell_view`: ptr CellView; `path`: ptr TTreePath; `requisition`: ptr TRequisition): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_cell_view_get_size_of_row".}
proc cell_view_set_background_color*(`cell_view`: ptr CellView; `color`: ptr gdk2.TColor) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_cell_view_set_background_color".}
