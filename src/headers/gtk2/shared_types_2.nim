# Included by headers/gtk2.nim; do not import directly.
type
  TTreeViewSearchEqualFunc* = proc (model: PTreeModel, column: gint,
                                    key: cstring, iter: PTreeIter,
                                    search_data: gpointer): gboolean{.cdecl.}
  TTreeModelForeachFunc* = proc (model: PTreeModel, path: PTreePath,
                                 iter: PTreeIter, data: gpointer): gboolean{.
      cdecl.}
  TTreeIterCompareFunc* = proc (model: PTreeModel, a: PTreeIter, b: PTreeIter,
                                user_data: gpointer): gint{.cdecl.}
  TTreeSelectionForeachFunc* = proc (model: PTreeModel, path: PTreePath,
                                     iter: PTreeIter, data: gpointer){.cdecl.}
