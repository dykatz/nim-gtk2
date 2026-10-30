# Included by headers/gtk2.nim; do not import directly.
proc link_button_get_type*():GType {.cdecl,
    importc: "gtk_link_button_get_type", dynlib: lib.}
proc link_button_new*(uri: cstring): PWidget {.cdecl,
    importc: "gtk_link_button_new", dynlib: lib.}
proc link_button_new_with_label*(uri: cstring,label: cstring): PWidget {.cdecl,
    importc: "gtk_link_button_new_with_label", dynlib: lib.}
proc link_button_get_uri*(link_button: PLinkButton): cstring {.cdecl,
    importc: "gtk_link_button_get_uri", dynlib: lib.}
proc link_button_set_uri*(link_button: PLinkButton,uri: cstring) {.cdecl,
    importc: "gtk_link_button_set_uri", dynlib: lib.}
proc link_button_get_visited*(link_button: PLinkButton): gboolean {.cdecl,
    importc: "gtk_link_button_get_visited", dynlib: lib.}
proc link_button_set_visited*(link_button: PLinkButton,visited: gboolean) {.cdecl,
    importc: "gtk_link_button_set_visited", dynlib: lib.}

proc TYPE_LINK_BUTTON*(): GType =
  result = link_button_get_type()
proc `LINK_BUTTON`*(anObject: pointer): PLinkButton =
  result = cast[PLinkButton](CHECK_CAST(anObject, TYPE_LINK_BUTTON()))
proc LINK_BUTTON_CLASS*(klass: pointer): PLinkButtonClass =
  result = cast[PLinkButtonClass](CHECK_CLASS_CAST(klass, TYPE_LINK_BUTTON()))
proc IS_LINK_BUTTON*(anObject: pointer): bool =
  result = CHECK_TYPE(anObject, TYPE_LINK_BUTTON())
proc IS_LINK_BUTTON_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_LINK_BUTTON())
proc LINK_BUTTON_GET_CLASS*(anObject: pointer): PLinkButtonClass =
  result = cast[PLinkButtonClass](CHECK_GET_CLASS(anObject, TYPE_LINK_BUTTON()))

