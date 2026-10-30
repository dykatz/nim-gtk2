# Included by headers/atk.nim; do not import directly.
proc TYPE_HYPERTEXT*(): GType
proc IS_HYPERTEXT*(obj: pointer): bool
proc HYPERTEXT*(obj: pointer): PHypertext
proc HYPERTEXT_GET_IFACE*(obj: pointer): PHypertextIface
proc hypertext_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "atk_hypertext_get_type".}
proc get_link*(hypertext: PHypertext, link_index: gint): PHyperlink{.
    cdecl, dynlib: lib, importc: "atk_hypertext_get_link".}
proc get_n_links*(hypertext: PHypertext): gint{.cdecl, dynlib: lib,
    importc: "atk_hypertext_get_n_links".}
proc get_link_index*(hypertext: PHypertext, char_index: gint): gint{.
    cdecl, dynlib: lib, importc: "atk_hypertext_get_link_index".}
