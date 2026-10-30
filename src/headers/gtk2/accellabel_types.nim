# Included by headers/gtk2.nim; do not import directly.
type
  TAccelLabel* = object of TLabel
    queue_id*: guint
    accel_padding*: guint
    accel_widget*: PWidget
    accel_closure*: PGClosure
    accel_group*: PAccelGroup
    accel_string*: cstring
    accel_string_width*: guint16

  PAccelLabel* = ptr TAccelLabel
