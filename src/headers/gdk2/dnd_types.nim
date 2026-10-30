# Included by headers/gdk2.nim; do not import directly.
type
  TDragAction* = int32
  PDragAction* = ptr TDragAction
  TDragProtocol* = enum
    DRAG_PROTO_MOTIF, DRAG_PROTO_XDND, DRAG_PROTO_ROOTWIN, DRAG_PROTO_NONE,
    DRAG_PROTO_WIN32_DROPFILES, DRAG_PROTO_OLE2, DRAG_PROTO_LOCAL
  PDragProtocol* = ptr TDragProtocol
  TDragContext* = object of TGObject
    protocol*: TDragProtocol
    is_source*: gboolean
    source_window*: PWindow
    dest_window*: PWindow
    targets*: PGList
    actions*: TDragAction
    suggested_action*: TDragAction
    action*: TDragAction
    start_time*: guint32
    windowing_data*: gpointer

  PDragContext* = ptr TDragContext
  TDragContextClass* = object of TGObjectClass
  PDragContextClass* = ptr TDragContextClass
