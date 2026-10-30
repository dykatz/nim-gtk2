# Included by headers/glib2.nim; do not import directly.
type
  PGHook* = ptr TGHook
  TGHook*{.final.} = object
    data*: gpointer
    next*: PGHook
    prev*: PGHook
    ref_count*: guint
    hook_id*: gulong
    flags*: guint
    fn*: gpointer
    destroy*: TGDestroyNotify

