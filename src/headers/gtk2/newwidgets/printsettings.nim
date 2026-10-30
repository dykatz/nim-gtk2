# Generated from gtkprintsettings.h; included by headers/gtk2.nim.
proc print_settings_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_type".}
proc print_settings_new*(): ptr PrintSettings {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_new".}
proc print_settings_copy*(`other`: ptr PrintSettings): ptr PrintSettings {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_copy".}
proc print_settings_new_from_file*(`file_name`: cstring; `error`: ptr ptr GError): ptr PrintSettings {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_new_from_file".}
proc print_settings_load_file*(`settings`: ptr PrintSettings; `file_name`: cstring; `error`: ptr ptr GError): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_load_file".}
proc print_settings_to_file*(`settings`: ptr PrintSettings; `file_name`: cstring; `error`: ptr ptr GError): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_to_file".}
proc print_settings_new_from_key_file*(`key_file`: ptr GKeyFile; `group_name`: cstring; `error`: ptr ptr GError): ptr PrintSettings {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_new_from_key_file".}
proc print_settings_load_key_file*(`settings`: ptr PrintSettings; `key_file`: ptr GKeyFile; `group_name`: cstring; `error`: ptr ptr GError): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_load_key_file".}
proc print_settings_to_key_file*(`settings`: ptr PrintSettings; `key_file`: ptr GKeyFile; `group_name`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_to_key_file".}
proc print_settings_has_key*(`settings`: ptr PrintSettings; `key`: cstring): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_has_key".}
proc print_settings_get*(`settings`: ptr PrintSettings; `key`: cstring): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get".}
proc print_settings_set*(`settings`: ptr PrintSettings; `key`: cstring; `value`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set".}
proc print_settings_unset*(`settings`: ptr PrintSettings; `key`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_unset".}
proc print_settings_foreach*(`settings`: ptr PrintSettings; `func`: PrintSettingsFunc; `user_data`: pointer) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_foreach".}
proc print_settings_get_bool*(`settings`: ptr PrintSettings; `key`: cstring): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_bool".}
proc print_settings_set_bool*(`settings`: ptr PrintSettings; `key`: cstring; `value`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_bool".}
proc print_settings_get_double*(`settings`: ptr PrintSettings; `key`: cstring): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_double".}
proc print_settings_get_double_with_default*(`settings`: ptr PrintSettings; `key`: cstring; `def`: gdouble): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_double_with_default".}
proc print_settings_set_double*(`settings`: ptr PrintSettings; `key`: cstring; `value`: gdouble) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_double".}
proc print_settings_get_length*(`settings`: ptr PrintSettings; `key`: cstring; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_length".}
proc print_settings_set_length*(`settings`: ptr PrintSettings; `key`: cstring; `value`: gdouble; `unit`: Unit) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_length".}
proc print_settings_get_int*(`settings`: ptr PrintSettings; `key`: cstring): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_int".}
proc print_settings_get_int_with_default*(`settings`: ptr PrintSettings; `key`: cstring; `def`: gint): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_int_with_default".}
proc print_settings_set_int*(`settings`: ptr PrintSettings; `key`: cstring; `value`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_int".}
proc print_settings_get_printer*(`settings`: ptr PrintSettings): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_printer".}
proc print_settings_set_printer*(`settings`: ptr PrintSettings; `printer`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_printer".}
proc print_settings_get_orientation*(`settings`: ptr PrintSettings): PageOrientation {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_orientation".}
proc print_settings_set_orientation*(`settings`: ptr PrintSettings; `orientation`: PageOrientation) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_orientation".}
proc print_settings_get_paper_size*(`settings`: ptr PrintSettings): ptr PaperSize {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_paper_size".}
proc print_settings_set_paper_size*(`settings`: ptr PrintSettings; `paper_size`: ptr PaperSize) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_paper_size".}
proc print_settings_get_paper_width*(`settings`: ptr PrintSettings; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_paper_width".}
proc print_settings_set_paper_width*(`settings`: ptr PrintSettings; `width`: gdouble; `unit`: Unit) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_paper_width".}
proc print_settings_get_paper_height*(`settings`: ptr PrintSettings; `unit`: Unit): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_paper_height".}
proc print_settings_set_paper_height*(`settings`: ptr PrintSettings; `height`: gdouble; `unit`: Unit) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_paper_height".}
proc print_settings_get_use_color*(`settings`: ptr PrintSettings): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_use_color".}
proc print_settings_set_use_color*(`settings`: ptr PrintSettings; `use_color`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_use_color".}
proc print_settings_get_collate*(`settings`: ptr PrintSettings): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_collate".}
proc print_settings_set_collate*(`settings`: ptr PrintSettings; `collate`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_collate".}
proc print_settings_get_reverse*(`settings`: ptr PrintSettings): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_reverse".}
proc print_settings_set_reverse*(`settings`: ptr PrintSettings; `reverse`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_reverse".}
proc print_settings_get_duplex*(`settings`: ptr PrintSettings): PrintDuplex {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_duplex".}
proc print_settings_set_duplex*(`settings`: ptr PrintSettings; `duplex`: PrintDuplex) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_duplex".}
proc print_settings_get_quality*(`settings`: ptr PrintSettings): PrintQuality {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_quality".}
proc print_settings_set_quality*(`settings`: ptr PrintSettings; `quality`: PrintQuality) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_quality".}
proc print_settings_get_n_copies*(`settings`: ptr PrintSettings): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_n_copies".}
proc print_settings_set_n_copies*(`settings`: ptr PrintSettings; `num_copies`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_n_copies".}
proc print_settings_get_number_up*(`settings`: ptr PrintSettings): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_number_up".}
proc print_settings_set_number_up*(`settings`: ptr PrintSettings; `number_up`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_number_up".}
proc print_settings_get_number_up_layout*(`settings`: ptr PrintSettings): NumberUpLayout {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_number_up_layout".}
proc print_settings_set_number_up_layout*(`settings`: ptr PrintSettings; `number_up_layout`: NumberUpLayout) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_number_up_layout".}
proc print_settings_get_resolution*(`settings`: ptr PrintSettings): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_resolution".}
proc print_settings_set_resolution*(`settings`: ptr PrintSettings; `resolution`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_resolution".}
proc print_settings_get_resolution_x*(`settings`: ptr PrintSettings): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_resolution_x".}
proc print_settings_get_resolution_y*(`settings`: ptr PrintSettings): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_resolution_y".}
proc print_settings_set_resolution_xy*(`settings`: ptr PrintSettings; `resolution_x`: gint; `resolution_y`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_resolution_xy".}
proc print_settings_get_printer_lpi*(`settings`: ptr PrintSettings): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_printer_lpi".}
proc print_settings_set_printer_lpi*(`settings`: ptr PrintSettings; `lpi`: gdouble) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_printer_lpi".}
proc print_settings_get_scale*(`settings`: ptr PrintSettings): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_scale".}
proc print_settings_set_scale*(`settings`: ptr PrintSettings; `scale`: gdouble) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_scale".}
proc print_settings_get_print_pages*(`settings`: ptr PrintSettings): PrintPages {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_print_pages".}
proc print_settings_set_print_pages*(`settings`: ptr PrintSettings; `pages`: PrintPages) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_print_pages".}
proc print_settings_get_page_ranges*(`settings`: ptr PrintSettings; `num_ranges`: ptr gint): ptr PageRange {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_page_ranges".}
proc print_settings_set_page_ranges*(`settings`: ptr PrintSettings; `page_ranges`: ptr PageRange; `num_ranges`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_page_ranges".}
proc print_settings_get_page_set*(`settings`: ptr PrintSettings): PageSet {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_page_set".}
proc print_settings_set_page_set*(`settings`: ptr PrintSettings; `page_set`: PageSet) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_page_set".}
proc print_settings_get_default_source*(`settings`: ptr PrintSettings): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_default_source".}
proc print_settings_set_default_source*(`settings`: ptr PrintSettings; `default_source`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_default_source".}
proc print_settings_get_media_type*(`settings`: ptr PrintSettings): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_media_type".}
proc print_settings_set_media_type*(`settings`: ptr PrintSettings; `media_type`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_media_type".}
proc print_settings_get_dither*(`settings`: ptr PrintSettings): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_dither".}
proc print_settings_set_dither*(`settings`: ptr PrintSettings; `dither`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_dither".}
proc print_settings_get_finishings*(`settings`: ptr PrintSettings): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_finishings".}
proc print_settings_set_finishings*(`settings`: ptr PrintSettings; `finishings`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_finishings".}
proc print_settings_get_output_bin*(`settings`: ptr PrintSettings): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_get_output_bin".}
proc print_settings_set_output_bin*(`settings`: ptr PrintSettings; `output_bin`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_settings_set_output_bin".}
