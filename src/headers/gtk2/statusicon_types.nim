# Included by headers/gtk2.nim; do not import directly.
type
  TStatusIconPrivate*{.final, pure.} = object
    dummy_widget*: PWidget
    nid*: pointer
    tray_icon*: PWidget
    image*: PWidget
    last_click_x*: gint
    last_click_y*: gint
    taskbar_top*: gint
    orientation*: POrientation
    tooltip_text*: cstring
    title*: cstring
    size*: gint
    image_width*: gint
    image_height*: gint
    storage_type*: gtk2.PImageType
    image_data*: TImageData
    blank_icon*: PPixbuf
    blinking_timeout*: gint
    blinking*: gint
    blink_off*: gint
    visible*: gint
  PStatusIconPrivate* = ptr TStatusIconPrivate
  TStatusIcon* = object of TGObject
    priv*: PStatusIconPrivate
  PStatusIcon* = ptr TStatusIcon
  TStatusIconClass* = object of TGObjectClass
    activate*: proc (status_icon: PStatusIcon){.cdecl.}
    popup_menu*: proc (status_icon: PStatusIcon, button: guint,activate_time: guint32){.cdecl.}
    size_changed*: proc (status_icon: PStatusIcon,size: gint): gboolean{.cdecl.}
    button_press_event*: proc (status_icon: PStatusIcon,event: PEventButton):gboolean{.cdecl.}
    button_release_event*: proc (status_icon: PStatusIcon,event: PEventButton):gboolean{.cdecl.}
    scroll_event*: proc (status_icon: PStatusIcon,event: PEventButton):gboolean{.cdecl.}
    query_tooltip*: proc (status_icon: PStatusIcon,x: gint,y:gint,
      keyboard_mode: gboolean,tooltip: PTooltip):gboolean{.cdecl.}
    reserved1*: proc (){.cdecl.}
    reserved2*: proc (){.cdecl.}

  PStatusIconClass* = ptr TStatusIconClass
