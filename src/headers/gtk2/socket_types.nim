# Included by headers/gtk2.nim; do not import directly.
type
  TSocket* = object of TContainer
    request_width*: guint16
    request_height*: guint16
    current_width*: guint16
    current_height*: guint16
    plug_window*: gdk2.PWindow
    plug_widget*: PWidget
    xembed_version*: gshort
    Socket_flag0*: guint16
    accel_group*: PAccelGroup
    toplevel*: PWidget

  PSocket* = ptr TSocket
  TSocketClass* = object of TContainerClass
    plug_added*: proc (socket: PSocket){.cdecl.}
    plug_removed*: proc (socket: PSocket): gboolean{.cdecl.}
    reserved621: proc (){.cdecl.}
    reserved622: proc (){.cdecl.}
    reserved623: proc (){.cdecl.}
    reserved624: proc (){.cdecl.}

  PSocketClass* = ptr TSocketClass
