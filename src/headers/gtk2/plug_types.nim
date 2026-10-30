# Included by headers/gtk2.nim; do not import directly.
type
  TPlug* = object of TWindow
    socket_window*: gdk2.PWindow
    modality_window*: PWidget
    modality_group*: PWindowGroup
    grabbed_keys*: PGHashTable
    Plug_flag0*: guint16

  PPlug* = ptr TPlug
