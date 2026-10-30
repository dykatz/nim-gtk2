# Included by headers/glib2.nim; do not import directly.
type
  TGSignalFlags* = int32
  PGSignalFlags* = ptr TGSignalFlags
  TGSignalInvocationHint*{.final.} = object
    signal_id*: guint
    detail*: TGQuark
    run_type*: TGSignalFlags

  PGSignalInvocationHint* = ptr TGSignalInvocationHint
  TGSignalQuery*{.final.} = object
    signal_id*: guint
    signal_name*: cstring
    itype*: GType
    signal_flags*: TGSignalFlags
    return_type*: GType
    n_params*: guint
    param_types*: PGType


  PGSignalQuery* = ptr TGSignalQuery
