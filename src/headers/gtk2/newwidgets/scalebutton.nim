# Generated from gtkscalebutton.h; included by headers/gtk2.nim.
proc scale_button_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_scale_button_get_type".}
proc scale_button_new*(`size`: TIconSize; `min`: gdouble; `max`: gdouble; `step`: gdouble; `icons`: ptr cstring): ptr ScaleButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_scale_button_new".}
proc scale_button_set_icons*(`button`: ptr ScaleButton; `icons`: ptr cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_scale_button_set_icons".}
proc scale_button_get_value*(`button`: ptr ScaleButton): gdouble {.cdecl, gcsafe, dynlib: lib, importc: "gtk_scale_button_get_value".}
proc scale_button_set_value*(`button`: ptr ScaleButton; `value`: gdouble) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_scale_button_set_value".}
proc scale_button_get_adjustment*(`button`: ptr ScaleButton): ptr TAdjustment {.cdecl, gcsafe, dynlib: lib, importc: "gtk_scale_button_get_adjustment".}
proc scale_button_set_adjustment*(`button`: ptr ScaleButton; `adjustment`: ptr TAdjustment) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_scale_button_set_adjustment".}
proc scale_button_get_plus_button*(`button`: ptr ScaleButton): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_scale_button_get_plus_button".}
proc scale_button_get_minus_button*(`button`: ptr ScaleButton): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_scale_button_get_minus_button".}
proc scale_button_get_popup*(`button`: ptr ScaleButton): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_scale_button_get_popup".}
