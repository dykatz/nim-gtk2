# Included by headers/gtk2.nim; do not import directly.
type
  TTreeModelSort* = object of TGObject
    root*: gpointer
    stamp*: gint
    child_flags*: guint
    child_model*: PTreeModel
    zero_ref_count*: gint
    sort_list*: PGList
    sort_column_id*: gint
    order*: TSortType
    default_sort_func*: TTreeIterCompareFunc
    default_sort_data*: gpointer
    default_sort_destroy*: TDestroyNotify
    changed_id*: guint
    inserted_id*: guint
    has_child_toggled_id*: guint
    deleted_id*: guint
    reordered_id*: guint

  PTreeModelSort* = ptr TTreeModelSort
  TTreeModelSortClass* = object of TGObjectClass
    reserved491: proc (){.cdecl.}
    reserved492: proc (){.cdecl.}
    reserved493: proc (){.cdecl.}
    reserved494: proc (){.cdecl.}

  PTreeModelSortClass* = ptr TTreeModelSortClass
