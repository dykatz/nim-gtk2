# Included by headers/glib2.nim; do not import directly.
proc g_relation_new*(fields: gint): PGRelation{.cdecl, dynlib: gliblib,
    importc: "g_relation_new".}
proc destroy*(relation: PGRelation){.cdecl, dynlib: gliblib,
    importc: "g_relation_destroy".}
proc index*(relation: PGRelation, field: gint, hash_func: TGHashFunc,
                       key_equal_func: TGEqualFunc){.cdecl, dynlib: gliblib,
    importc: "g_relation_index".}
proc delete*(relation: PGRelation, key: gconstpointer, field: gint): gint{.
    cdecl, dynlib: gliblib, importc: "g_relation_delete".}
proc select*(relation: PGRelation, key: gconstpointer, field: gint): PGTuples{.
    cdecl, dynlib: gliblib, importc: "g_relation_select".}
proc count*(relation: PGRelation, key: gconstpointer, field: gint): gint{.
    cdecl, dynlib: gliblib, importc: "g_relation_count".}
proc print*(relation: PGRelation){.cdecl, dynlib: gliblib,
    importc: "g_relation_print".}
proc destroy*(tuples: PGTuples){.cdecl, dynlib: gliblib,
    importc: "g_tuples_destroy".}
proc index*(tuples: PGTuples, index: gint, field: gint): gpointer{.
    cdecl, dynlib: gliblib, importc: "g_tuples_index".}
