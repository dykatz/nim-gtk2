# Included by headers/gtk2.nim; do not import directly.
proc TYPE_IM_MULTICONTEXT*(): GType
proc IM_MULTICONTEXT*(obj: pointer): PIMMulticontext
proc IM_MULTICONTEXT_CLASS*(klass: pointer): PIMMulticontextClass
proc IS_IM_MULTICONTEXT*(obj: pointer): bool
proc IS_IM_MULTICONTEXT_CLASS*(klass: pointer): bool
proc IM_MULTICONTEXT_GET_CLASS*(obj: pointer): PIMMulticontextClass
proc im_multicontext_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_im_multicontext_get_type".}
proc im_multicontext_new*(): PIMContext{.cdecl, dynlib: lib,
    importc: "gtk_im_multicontext_new".}
proc append_menuitems*(context: PIMMulticontext,
                                       menushell: PMenuShell){.cdecl,
    dynlib: lib, importc: "gtk_im_multicontext_append_menuitems".}
