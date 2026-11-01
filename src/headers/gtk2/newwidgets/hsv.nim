# Generated from gtkhsv.h; included by headers/gtk2.nim.
proc hsv_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_hsv_get_type".}
proc hsv_new*(): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_hsv_new".}
proc hsv_set_color*(`hsv`: ptr HSV; `h`: cdouble; `s`: cdouble; `v`: cdouble) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_hsv_set_color".}
proc hsv_get_color*(`hsv`: ptr HSV; `h`: ptr gdouble; `s`: ptr gdouble; `v`: ptr gdouble) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_hsv_get_color".}
proc hsv_set_metrics*(`hsv`: ptr HSV; `size`: gint; `ring_width`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_hsv_set_metrics".}
proc hsv_get_metrics*(`hsv`: ptr HSV; `size`: ptr gint; `ring_width`: ptr gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_hsv_get_metrics".}
proc hsv_is_adjusting*(`hsv`: ptr HSV): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_hsv_is_adjusting".}
proc hsv_to_rgb*(`h`: gdouble; `s`: gdouble; `v`: gdouble; `r`: ptr gdouble; `g`: ptr gdouble; `b`: ptr gdouble) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_hsv_to_rgb".}
proc rgb_to_hsv*(`r`: gdouble; `g`: gdouble; `b`: gdouble; `h`: ptr gdouble; `s`: ptr gdouble; `v`: ptr gdouble) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_rgb_to_hsv".}
