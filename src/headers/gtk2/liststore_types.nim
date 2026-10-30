# Included by headers/gtk2.nim; do not import directly.
type
  TListStore* = object of TGObject
    stamp*: gint
    root*: gpointer
    tail*: gpointer
    sort_list*: PGList
    n_columns*: gint
    sort_column_id*: gint
    order*: TSortType
    column_headers*: PGType
    length*: gint
    default_sort_func*: TTreeIterCompareFunc
    default_sort_data*: gpointer
    default_sort_destroy*: TDestroyNotify
    ListStore_flag0*: guint16

  PListStore* = ptr TListStore
  TListStoreClass* = object of TGObjectClass
    reserved501: proc (){.cdecl.}
    reserved502: proc (){.cdecl.}
    reserved503: proc (){.cdecl.}
    reserved504: proc (){.cdecl.}

  PListStoreClass* = ptr TListStoreClass
