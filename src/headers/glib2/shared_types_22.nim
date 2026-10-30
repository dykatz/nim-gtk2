# Included by headers/glib2.nim; do not import directly.
type
  TGIOFunc* = proc (source: PGIOChannel, condition: TGIOCondition,
                    data: gpointer): gboolean{.cdecl.}
