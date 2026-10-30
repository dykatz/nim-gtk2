# Included by headers/gdk2.nim; do not import directly.
type
  TWindowClass* = enum
    INPUT_OUTPUT, INPUT_ONLY
  PWindowClass* = ptr TWindowClass
  TWindowType* = enum
    WINDOW_ROOT, WINDOW_TOPLEVEL, WINDOW_CHILD, WINDOW_DIALOG, WINDOW_TEMP,
    WINDOW_FOREIGN
  PWindowType* = ptr TWindowType
  TWindowAttributesType* = int32
  PWindowAttributesType* = ptr TWindowAttributesType
  TWindowHints* = int32
  PWindowHints* = ptr TWindowHints
  TWindowTypeHint* = enum
    WINDOW_TYPE_HINT_NORMAL, WINDOW_TYPE_HINT_DIALOG, WINDOW_TYPE_HINT_MENU,
    WINDOW_TYPE_HINT_TOOLBAR, WINDOW_TYPE_HINT_SPLASHSCREEN,
    WINDOW_TYPE_HINT_UTILITY, WINDOW_TYPE_HINT_DOCK,
    WINDOW_TYPE_HINT_DESKTOP, WINDOW_TYPE_HINT_DROPDOWN_MENU,
    WINDOW_TYPE_HINT_POPUP_MENU, WINDOW_TYPE_HINT_TOOLTIP,
    WINDOW_TYPE_HINT_NOTIFICATION, WINDOW_TYPE_HINT_COMBO,
    WINDOW_TYPE_HINT_DND
  PWindowTypeHint* = ptr TWindowTypeHint
  TWMDecoration* = int32
  PWMDecoration* = ptr TWMDecoration
  TWMFunction* = int32
  PWMFunction* = ptr TWMFunction
  TGravity* = int
  PGravity* = ptr TGravity
  TWindowEdge* = enum
    WINDOW_EDGE_NORTH_WEST, WINDOW_EDGE_NORTH, WINDOW_EDGE_NORTH_EAST,
    WINDOW_EDGE_WEST, WINDOW_EDGE_EAST, WINDOW_EDGE_SOUTH_WEST,
    WINDOW_EDGE_SOUTH, WINDOW_EDGE_SOUTH_EAST
  PWindowEdge* = ptr TWindowEdge
  TWindowAttr*{.final, pure.} = object
    title*: cstring
    event_mask*: gint
    x*: gint
    y*: gint
    width*: gint
    height*: gint
    wclass*: TWindowClass
    visual*: PVisual
    colormap*: PColormap
    window_type*: TWindowType
    cursor*: PCursor
    wmclass_name*: cstring
    wmclass_class*: cstring
    override_redirect*: gboolean

  PWindowAttr* = ptr TWindowAttr
  TGeometry*{.final, pure.} = object
    min_width*: gint
    min_height*: gint
    max_width*: gint
    max_height*: gint
    base_width*: gint
    base_height*: gint
    width_inc*: gint
    height_inc*: gint
    min_aspect*: gdouble
    max_aspect*: gdouble
    win_gravity*: TGravity

  PGeometry* = ptr TGeometry
  TPointerHooks*{.final, pure.} = object
    get_pointer*: proc (window: PWindow, x: Pgint, y: Pgint, mask: PModifierType): PWindow{.
        cdecl.}
    window_at_pointer*: proc (screen: PScreen, win_x: Pgint, win_y: Pgint): PWindow{.
        cdecl.}

  PPointerHooks* = ptr TPointerHooks
  PWindowObject* = ptr TWindowObject
  TWindowObject* = object of TDrawable
    impl*: PDrawable
    parent*: PWindowObject
    user_data*: gpointer
    x*: gint
    y*: gint
    extension_events*: gint
    filters*: PGList
    children*: PGList
    bg_color*: TColor
    bg_pixmap*: PPixmap
    paint_stack*: PGSList
    update_area*: PRegion
    update_freeze_count*: guint
    window_type*: guint8
    depth*: guint8
    resize_count*: guint8
    state*: TWindowState
    flag0*: guint16
    event_mask*: TEventMask

  TWindowObjectClass* = object of TDrawableClass
  PWindowObjectClass* = ptr TWindowObjectClass
