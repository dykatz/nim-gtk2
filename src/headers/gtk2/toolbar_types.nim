# Included by headers/gtk2.nim; do not import directly.
type
  TToolbarChildType* = enum
    TOOLBAR_CHILD_SPACE, TOOLBAR_CHILD_BUTTON, TOOLBAR_CHILD_TOGGLEBUTTON,
    TOOLBAR_CHILD_RADIOBUTTON, TOOLBAR_CHILD_WIDGET
  PToolbarChildType* = ptr TToolbarChildType
  TToolbarSpaceStyle* = enum
    TOOLBAR_SPACE_EMPTY, TOOLBAR_SPACE_LINE
  PToolbarSpaceStyle* = ptr TToolbarSpaceStyle
  TToolbarChild*{.final, pure.} = object
    `type`*: TToolbarChildType
    widget*: PWidget
    icon*: PWidget
    label*: PWidget

  PToolbarChild* = ptr TToolbarChild
  TToolbar* = object of TContainer
    num_children*: gint
    children*: PGList
    orientation*: TOrientation
    Toolbar_style*: TToolbarStyle
    icon_size*: TIconSize
    legacyTooltips: pointer # Private ABI slot, not a GtkTooltips API.
    button_maxw*: gint
    button_maxh*: gint
    style_set_connection*: guint
    icon_size_connection*: guint
    Toolbar_flag0*: guint16

  PToolbar* = ptr TToolbar
  TToolbarClass* = object of TContainerClass
    orientation_changed*: proc (toolbar: PToolbar, orientation: TOrientation){.
        cdecl.}
    style_changed*: proc (toolbar: PToolbar, style: TToolbarStyle){.cdecl.}
    reserved731: proc (){.cdecl.}
    reserved732: proc (){.cdecl.}
    reserved733: proc (){.cdecl.}
    reserved734: proc (){.cdecl.}

  PToolbarClass* = ptr TToolbarClass
