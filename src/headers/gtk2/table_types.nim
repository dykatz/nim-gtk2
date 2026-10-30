# Included by headers/gtk2.nim; do not import directly.
type
  TTableClass* = object of TContainerClass
  PTableClass* = ptr TTableClass
  TTableChild*{.final, pure.} = object
    widget*: PWidget
    left_attach*: guint16
    right_attach*: guint16
    top_attach*: guint16
    bottom_attach*: guint16
    xpadding*: guint16
    ypadding*: guint16
    TableChild_flag0*: guint16

  PTableChild* = ptr TTableChild
  TTableRowCol*{.final, pure.} = object
    requisition*: guint16
    allocation*: guint16
    spacing*: guint16
    flag0*: guint16

  PTableRowCol* = ptr TTableRowCol
  TTable* = object of TContainer
    children*: PGList
    rows*: PTableRowCol
    cols*: PTableRowCol
    nrows*: guint16
    ncols*: guint16
    column_spacing*: guint16
    row_spacing*: guint16
    Table_flag0*: guint16

  PTable* = ptr TTable
