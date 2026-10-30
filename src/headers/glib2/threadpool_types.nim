# Included by headers/glib2.nim; do not import directly.
type
  TGThreadPool*{.final.} = object
    fn*: TGFunc
    user_data*: gpointer
    exclusive*: gboolean


  PGThreadPool* = ptr TGThreadPool
