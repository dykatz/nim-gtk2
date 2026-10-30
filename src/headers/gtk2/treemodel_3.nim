# Included by headers/gtk2.nim; do not import directly.
proc get*(tree_model: PTreeModel, iter: PTreeIter){.varargs,
    importc: "gtk_tree_model_get", cdecl, dynlib: lib.}
proc get_valist*(tree_model: PTreeModel, iter: PTreeIter){.varargs,
    importc: "gtk_tree_model_get_valist", cdecl, dynlib: lib.}
