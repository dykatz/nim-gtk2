# Included by headers/gtk2.nim; do not import directly.
proc TYPE_IM_CONTEXT_SIMPLE*(): GType
proc IM_CONTEXT_SIMPLE*(obj: pointer): PIMContextSimple
proc IM_CONTEXT_SIMPLE_CLASS*(klass: pointer): PIMContextSimpleClass
proc IS_IM_CONTEXT_SIMPLE*(obj: pointer): bool
proc IS_IM_CONTEXT_SIMPLE_CLASS*(klass: pointer): bool
proc IM_CONTEXT_SIMPLE_GET_CLASS*(obj: pointer): PIMContextSimpleClass
proc in_hex_sequence*(a: PIMContextSimple): guint
proc set_in_hex_sequence*(a: PIMContextSimple, `in_hex_sequence`: guint)
proc im_context_simple_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_im_context_simple_get_type".}
proc im_context_simple_new*(): PIMContext{.cdecl, dynlib: lib,
    importc: "gtk_im_context_simple_new".}
proc simple_add_table*(context_simple: PIMContextSimple,
                                  data: Pguint16, max_seq_len: gint,
                                  n_seqs: gint){.cdecl, dynlib: lib,
    importc: "gtk_im_context_simple_add_table".}
