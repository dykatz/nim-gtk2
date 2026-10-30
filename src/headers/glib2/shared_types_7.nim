# Included by headers/glib2.nim; do not import directly.
type
  TGSignalEmissionHook* = proc (ihint: PGSignalInvocationHint,
                                n_param_values: guint, param_values: PGValue,
                                data: gpointer): gboolean{.cdecl.}
  TGSignalAccumulator* = proc (ihint: PGSignalInvocationHint,
                               return_accu: PGValue, handler_return: PGValue,
                               data: gpointer): gboolean{.cdecl.}
