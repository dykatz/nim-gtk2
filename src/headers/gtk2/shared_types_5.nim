# Included by headers/gtk2.nim; do not import directly.
type
  PWidget* = ptr TWidget
  TWidget* = object of TObject
    private_flags*: guint16
    state*: guint8
    saved_state*: guint8
    name*: cstring
    style*: PStyle
    requisition*: TRequisition
    allocation*: TAllocation
    window*: gdk2.PWindow
    parent*: PWidget

  TContainer* = object of TWidget
    focus_child*: PWidget
    Container_flag0*: uint32

  TBin* = object of TContainer
    child*: PWidget

  PWindow* = ptr TWindow
  TWindow* = object of TBin
    title*: cstring
    wmclass_name*: cstring
    wmclass_class*: cstring
    wm_role*: cstring
    focus_widget*: PWidget
    default_widget*: PWidget
    transient_parent*: PWindow
    geometry_info*: PWindowGeometryInfo
    frame*: gdk2.PWindow
    group*: PWindowGroup
    configure_request_count*: guint16
    window_flag0*: uint32
    frame_left*: guint
    frame_top*: guint
    frame_right*: guint
    frame_bottom*: guint
    keys_changed_handler*: guint
    mnemonic_modifier*: gdk2.TModifierType
    screen*: gdk2.PScreen

  TCallback* = proc (widget: PWidget, data: gpointer){.cdecl.}
  TWindowKeysForeachFunc* = proc (window: PWindow, keyval: guint,
                                  modifiers: gdk2.TModifierType,
                                  is_mnemonic: gboolean, data: gpointer){.cdecl.}
  TItemFactoryCallback1* = proc (callback_data: gpointer,
                                 callback_action: guint, widget: PWidget){.cdecl.}
  TKeySnoopFunc* = proc (grab_widget: PWidget, event: gdk2.PEventKey,
                         func_data: gpointer): gint{.cdecl.}
  ProgressLayout = object of TWidget
    adjustment: PAdjustment
    offscreen_pixmap: gdk2.PPixmap
    format: cstring
    x_align: gfloat
    y_align: gfloat
    Progress_flag0: guint16

  ProgressLayoutPtr = ptr ProgressLayout
