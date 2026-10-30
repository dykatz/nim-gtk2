# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TREE_STORE*(): GType =
  result = tree_store_get_type()

proc TREE_STORE*(obj: pointer): PTreeStore =
  result = cast[PTreeStore](CHECK_CAST(obj, TYPE_TREE_STORE()))

proc TREE_STORE_CLASS*(klass: pointer): PTreeStoreClass =
  result = cast[PTreeStoreClass](CHECK_CLASS_CAST(klass, TYPE_TREE_STORE()))

proc IS_TREE_STORE*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_TREE_STORE())

proc IS_TREE_STORE_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_TREE_STORE())

proc TREE_STORE_GET_CLASS*(obj: pointer): PTreeStoreClass =
  result = cast[PTreeStoreClass](CHECK_GET_CLASS(obj, TYPE_TREE_STORE()))

proc columns_dirty*(a: PTreeStore): guint =
  result = (a.TreeStoreflag0 and bm_TGtkTreeStore_columns_dirty) shr
      bp_TGtkTreeStore_columns_dirty

proc set_columns_dirty*(a: PTreeStore, `columns_dirty`: guint) =
  a.TreeStoreflag0 = a.TreeStoreflag0 or
      (uint16(`columns_dirty` shl bp_TGtkTreeStore_columns_dirty) and
      bm_TGtkTreeStore_columns_dirty)

