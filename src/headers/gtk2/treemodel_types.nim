# Included by headers/gtk2.nim; do not import directly.
type
  TTreeModel {.pure, final, incompleteStruct.} = object
  PTreeModel* = ptr TTreeModel
  PPGtkTreeModel* = ptr PTreeModel
  TTreePath {.pure, final, incompleteStruct.} = object
  PTreePath* = ptr TTreePath
  TTreeModelFlags* = int32
  PTreeModelFlags* = ptr TTreeModelFlags
  TTreeIter*{.final, pure.} = object
    stamp*: gint
    user_data*: gpointer
    user_data2*: gpointer
    user_data3*: gpointer

  PTreeIter* = ptr TTreeIter
  TTreeModelIface* = object of TGTypeInterface
    row_changed*: proc (tree_model: PTreeModel, path: PTreePath, iter: PTreeIter){.
        cdecl.}
    row_inserted*: proc (tree_model: PTreeModel, path: PTreePath,
                         iter: PTreeIter){.cdecl.}
    row_has_child_toggled*: proc (tree_model: PTreeModel, path: PTreePath,
                                  iter: PTreeIter){.cdecl.}
    row_deleted*: proc (tree_model: PTreeModel, path: PTreePath){.cdecl.}
    rows_reordered*: proc (tree_model: PTreeModel, path: PTreePath,
                           iter: PTreeIter, new_order: Pgint){.cdecl.}
    get_flags*: proc (tree_model: PTreeModel): TTreeModelFlags{.cdecl.}
    get_n_columns*: proc (tree_model: PTreeModel): gint{.cdecl.}
    get_column_type*: proc (tree_model: PTreeModel, index: gint): GType{.cdecl.}
    get_iter*: proc (tree_model: PTreeModel, iter: PTreeIter, path: PTreePath): gboolean{.
        cdecl.}
    get_path*: proc (tree_model: PTreeModel, iter: PTreeIter): PTreePath{.cdecl.}
    get_value*: proc (tree_model: PTreeModel, iter: PTreeIter, column: gint,
                      value: PGValue){.cdecl.}
    iter_next*: proc (tree_model: PTreeModel, iter: PTreeIter): gboolean{.cdecl.}
    iter_children*: proc (tree_model: PTreeModel, iter: PTreeIter,
                          parent: PTreeIter): gboolean{.cdecl.}
    iter_has_child*: proc (tree_model: PTreeModel, iter: PTreeIter): gboolean{.
        cdecl.}
    iter_n_children*: proc (tree_model: PTreeModel, iter: PTreeIter): gint{.
        cdecl.}
    iter_nth_child*: proc (tree_model: PTreeModel, iter: PTreeIter,
                           parent: PTreeIter, n: gint): gboolean{.cdecl.}
    iter_parent*: proc (tree_model: PTreeModel, iter: PTreeIter,
                        child: PTreeIter): gboolean{.cdecl.}
    ref_node*: proc (tree_model: PTreeModel, iter: PTreeIter){.cdecl.}
    unref_node*: proc (tree_model: PTreeModel, iter: PTreeIter){.cdecl.}

  PTreeModelIface* = ptr TTreeModelIface
  TreeRowReference* {.pure, final, incompleteStruct.} = object
  PTreeRowReference* = ptr TreeRowReference
