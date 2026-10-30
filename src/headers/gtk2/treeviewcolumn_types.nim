# Included by headers/gtk2.nim; do not import directly.
type
  TTreeViewColumnSizing* = enum
    TREE_VIEW_COLUMN_GROW_ONLY, TREE_VIEW_COLUMN_AUTOSIZE,
    TREE_VIEW_COLUMN_FIXED
  PTreeViewColumnSizing* = ptr TTreeViewColumnSizing
  TTreeViewColumn* = object of TObject
    tree_view*: PWidget
    button*: PWidget
    child*: PWidget
    arrow*: PWidget
    alignment*: PWidget
    window*: gdk2.PWindow
    editable_widget*: PCellEditable
    xalign*: gfloat
    property_changed_signal*: guint
    spacing*: gint
    column_type*: TTreeViewColumnSizing
    requested_width*: gint
    button_request*: gint
    resized_width*: gint
    width*: gint
    fixed_width*: gint
    min_width*: gint
    max_width*: gint
    drag_x*: gint
    drag_y*: gint
    title*: cstring
    cell_list*: PGList
    sort_clicked_signal*: guint
    sort_column_changed_signal*: guint
    sort_column_id*: gint
    sort_order*: TSortType
    TreeViewColumn_flag0*: guint16

  PTreeViewColumn* = ptr TTreeViewColumn
  TTreeViewColumnClass* = object of TObjectClass
    clicked*: proc (tree_column: PTreeViewColumn){.cdecl.}
    reserved751: proc (){.cdecl.}
    reserved752: proc (){.cdecl.}
    reserved753: proc (){.cdecl.}
    reserved754: proc (){.cdecl.}

  PTreeViewColumnClass* = ptr TTreeViewColumnClass
