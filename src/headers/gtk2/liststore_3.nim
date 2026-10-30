# Included by headers/gtk2.nim; do not import directly.
proc TYPE_LIST_STORE*(): GType =
  result = list_store_get_type()

proc LIST_STORE*(obj: pointer): PListStore =
  result = cast[PListStore](CHECK_CAST(obj, TYPE_LIST_STORE()))

proc LIST_STORE_CLASS*(klass: pointer): PListStoreClass =
  result = cast[PListStoreClass](CHECK_CLASS_CAST(klass, TYPE_LIST_STORE()))

proc IS_LIST_STORE*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_LIST_STORE())

proc IS_LIST_STORE_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_LIST_STORE())

proc LIST_STORE_GET_CLASS*(obj: pointer): PListStoreClass =
  result = cast[PListStoreClass](CHECK_GET_CLASS(obj, TYPE_LIST_STORE()))

proc columns_dirty*(a: PListStore): guint =
  result = (a.ListStoreflag0 and bm_TGtkListStore_columns_dirty) shr
      bp_TGtkListStore_columns_dirty

proc set_columns_dirty*(a: PListStore, `columns_dirty`: guint) =
  a.ListStoreflag0 = a.ListStoreflag0 or
      (uint16(`columns_dirty` shl bp_TGtkListStore_columns_dirty) and
      bm_TGtkListStore_columns_dirty)

