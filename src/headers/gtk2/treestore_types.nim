# Included by headers/gtk2.nim; do not import directly.
type
  TTreeStore* = object of TGObject
    stamp*: gint
    root*: gpointer
    last*: gpointer
    n_columns*: gint
    sort_column_id*: gint
    sort_list*: PGList
    order*: TSortType
    column_headers*: PGType
    default_sort_func*: TTreeIterCompareFunc
    default_sort_data*: gpointer
    default_sort_destroy*: TDestroyNotify
    TreeStore_flag0*: guint16

  PTreeStore* = ptr TTreeStore
  TTreeStoreClass* = object of TGObjectClass
    reserved751: proc (){.cdecl.}
    reserved752: proc (){.cdecl.}
    reserved753: proc (){.cdecl.}
    reserved754: proc (){.cdecl.}

  PTreeStoreClass* = ptr TTreeStoreClass
