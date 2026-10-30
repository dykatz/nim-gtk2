# Included by headers/gtk2.nim; do not import directly.
type
  PTreeSortable* = pointer
  TTreeSortableIface* = object of TGTypeInterface
    sort_column_changed*: proc (sortable: PTreeSortable){.cdecl.}
    get_sort_column_id*: proc (sortable: PTreeSortable, sort_column_id: Pgint,
                               order: PSortType): gboolean{.cdecl.}
    set_sort_column_id*: proc (sortable: PTreeSortable, sort_column_id: gint,
                               order: TSortType){.cdecl.}
    set_sort_func*: proc (sortable: PTreeSortable, sort_column_id: gint,
                          fn: TTreeIterCompareFunc, data: gpointer,
                          destroy: TDestroyNotify){.cdecl.}
    set_default_sort_func*: proc (sortable: PTreeSortable,
                                  fn: TTreeIterCompareFunc, data: gpointer,
                                  destroy: TDestroyNotify){.cdecl.}
    has_default_sort_func*: proc (sortable: PTreeSortable): gboolean{.cdecl.}

  PTreeSortableIface* = ptr TTreeSortableIface
