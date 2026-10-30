# Generated from gtkpagesetup.h; included by headers/gtk2.nim.
proc page_setup_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_get_type".}
proc page_setup_new*(): ptr PageSetup {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_new".}
proc page_setup_copy*(`other`: ptr PageSetup): ptr PageSetup {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_copy".}
proc page_setup_get_orientation*(`setup`: ptr PageSetup): PageOrientation {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_get_orientation".}
proc page_setup_set_orientation*(`setup`: ptr PageSetup; `orientation`: PageOrientation) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_set_orientation".}
proc page_setup_get_paper_size*(`setup`: ptr PageSetup): ptr PaperSize {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_get_paper_size".}
proc page_setup_set_paper_size*(`setup`: ptr PageSetup; `size`: ptr PaperSize) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_set_paper_size".}
proc page_setup_get_top_margin*(`setup`: ptr PageSetup; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_get_top_margin".}
proc page_setup_set_top_margin*(`setup`: ptr PageSetup; `margin`: gdouble; `unit`: Unit) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_set_top_margin".}
proc page_setup_get_bottom_margin*(`setup`: ptr PageSetup; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_get_bottom_margin".}
proc page_setup_set_bottom_margin*(`setup`: ptr PageSetup; `margin`: gdouble; `unit`: Unit) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_set_bottom_margin".}
proc page_setup_get_left_margin*(`setup`: ptr PageSetup; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_get_left_margin".}
proc page_setup_set_left_margin*(`setup`: ptr PageSetup; `margin`: gdouble; `unit`: Unit) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_set_left_margin".}
proc page_setup_get_right_margin*(`setup`: ptr PageSetup; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_get_right_margin".}
proc page_setup_set_right_margin*(`setup`: ptr PageSetup; `margin`: gdouble; `unit`: Unit) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_set_right_margin".}
proc page_setup_set_paper_size_and_default_margins*(`setup`: ptr PageSetup; `size`: ptr PaperSize) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_set_paper_size_and_default_margins".}
proc page_setup_get_paper_width*(`setup`: ptr PageSetup; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_get_paper_width".}
proc page_setup_get_paper_height*(`setup`: ptr PageSetup; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_get_paper_height".}
proc page_setup_get_page_width*(`setup`: ptr PageSetup; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_get_page_width".}
proc page_setup_get_page_height*(`setup`: ptr PageSetup; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_get_page_height".}
proc page_setup_new_from_file*(`file_name`: cstring; `error`: ptr ptr GError): ptr PageSetup {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_new_from_file".}
proc page_setup_load_file*(`setup`: ptr PageSetup; `file_name`: cstring; `error`: ptr ptr GError): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_load_file".}
proc page_setup_to_file*(`setup`: ptr PageSetup; `file_name`: cstring; `error`: ptr ptr GError): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_to_file".}
proc page_setup_new_from_key_file*(`key_file`: ptr GKeyFile; `group_name`: cstring; `error`: ptr ptr GError): ptr PageSetup {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_new_from_key_file".}
proc page_setup_load_key_file*(`setup`: ptr PageSetup; `key_file`: ptr GKeyFile; `group_name`: cstring; `error`: ptr ptr GError): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_load_key_file".}
proc page_setup_to_key_file*(`setup`: ptr PageSetup; `key_file`: ptr GKeyFile; `group_name`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_to_key_file".}
