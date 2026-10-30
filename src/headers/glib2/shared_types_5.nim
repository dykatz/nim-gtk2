# Included by headers/glib2.nim; do not import directly.
type
  PGClosure* = ptr TGClosure
  PGClosureNotifyData* = ptr TGClosureNotifyData
  TGClosureNotify* = proc (data: gpointer, closure: PGClosure){.cdecl.}
  TGClosure*{.final.} = object
    flag0*: uint32
    marshal*: proc (closure: PGClosure, return_value: PGValue,
                    n_param_values: guint, param_values: PGValue,
                    invocation_hint, marshal_data: gpointer){.cdecl.}
    data*: gpointer
    notifiers*: PGClosureNotifyData

  TGClosureNotifyData*{.final.} = object
    data*: gpointer
    notify*: TGClosureNotify


  TGCallBackProcedure* = proc (){.cdecl.}
  TGCallback* = proc (){.cdecl, gcsafe.}
  TGClosureMarshal* = proc (closure: PGClosure, return_value: PGValue,
                            n_param_values: guint, param_values: PGValue,
                            invocation_hint: gpointer, marshal_data: gpointer){.
      cdecl.}
