# Included by headers/atk.nim; do not import directly.
proc TYPE_HYPERLINK*(): GType
proc HYPERLINK*(obj: pointer): PHyperlink
proc HYPERLINK_CLASS*(klass: pointer): PHyperlinkClass
proc IS_HYPERLINK*(obj: pointer): bool
proc IS_HYPERLINK_CLASS*(klass: pointer): bool
proc HYPERLINK_GET_CLASS*(obj: pointer): PHyperlinkClass
proc hyperlink_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "atk_hyperlink_get_type".}
proc get_uri*(link: PHyperlink, i: gint): cstring{.cdecl, dynlib: lib,
    importc: "atk_hyperlink_get_uri".}
proc get_object*(link: PHyperlink, i: gint): PObject{.cdecl,
    dynlib: lib, importc: "atk_hyperlink_get_object".}
proc get_end_index*(link: PHyperlink): gint{.cdecl, dynlib: lib,
    importc: "atk_hyperlink_get_end_index".}
proc get_start_index*(link: PHyperlink): gint{.cdecl, dynlib: lib,
    importc: "atk_hyperlink_get_start_index".}
proc is_valid*(link: PHyperlink): gboolean{.cdecl, dynlib: lib,
    importc: "atk_hyperlink_is_valid".}
proc get_n_anchors*(link: PHyperlink): gint{.cdecl, dynlib: lib,
    importc: "atk_hyperlink_get_n_anchors".}
