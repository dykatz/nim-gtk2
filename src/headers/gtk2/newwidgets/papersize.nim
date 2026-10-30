# Generated from gtkpapersize.h; included by headers/gtk2.nim.
proc paper_size_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_get_type".}
proc paper_size_new*(`name`: cstring): ptr PaperSize {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_new".}
proc paper_size_new_from_ppd*(`ppd_name`: cstring; `ppd_display_name`: cstring; `width`: gdouble; `height`: gdouble): ptr PaperSize {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_new_from_ppd".}
proc paper_size_new_custom*(`name`: cstring; `display_name`: cstring; `width`: gdouble; `height`: gdouble; `unit`: Unit): ptr PaperSize {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_new_custom".}
proc paper_size_copy*(`other`: ptr PaperSize): ptr PaperSize {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_copy".}
proc paper_size_free*(`size`: ptr PaperSize) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_free".}
proc paper_size_is_equal*(`size1`: ptr PaperSize; `size2`: ptr PaperSize): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_is_equal".}
proc paper_size_get_paper_sizes*(`include_custom`: gboolean): ptr TGList {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_get_paper_sizes".}
proc paper_size_get_name*(`size`: ptr PaperSize): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_get_name".}
proc paper_size_get_display_name*(`size`: ptr PaperSize): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_get_display_name".}
proc paper_size_get_ppd_name*(`size`: ptr PaperSize): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_get_ppd_name".}
proc paper_size_get_width*(`size`: ptr PaperSize; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_get_width".}
proc paper_size_get_height*(`size`: ptr PaperSize; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_get_height".}
proc paper_size_is_custom*(`size`: ptr PaperSize): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_is_custom".}
proc paper_size_set_size*(`size`: ptr PaperSize; `width`: gdouble; `height`: gdouble; `unit`: Unit) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_set_size".}
proc paper_size_get_default_top_margin*(`size`: ptr PaperSize; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_get_default_top_margin".}
proc paper_size_get_default_bottom_margin*(`size`: ptr PaperSize; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_get_default_bottom_margin".}
proc paper_size_get_default_left_margin*(`size`: ptr PaperSize; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_get_default_left_margin".}
proc paper_size_get_default_right_margin*(`size`: ptr PaperSize; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_get_default_right_margin".}
proc paper_size_get_default*(): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_get_default".}
proc paper_size_new_from_key_file*(`key_file`: ptr GKeyFile; `group_name`: cstring; `error`: ptr ptr GError): ptr PaperSize {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_new_from_key_file".}
proc paper_size_to_key_file*(`size`: ptr PaperSize; `key_file`: ptr GKeyFile; `group_name`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_paper_size_to_key_file".}
