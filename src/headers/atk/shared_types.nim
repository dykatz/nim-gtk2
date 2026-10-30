# Included by headers/atk.nim; do not import directly.
type
  TFunction* = proc (data: gpointer): gboolean{.cdecl.}
  PGPtrArray = pointer
  TAttributeSet* = TGSList
  PAttributeSet* = ptr TAttributeSet
  TEventListenerInitProc* = proc (){.cdecl.}
  TEventListenerInit* = proc (para1: TEventListenerInitProc){.cdecl.}
  TKeySnoopFunc* = proc (event: PKeyEventStruct, func_data: gpointer): gint{.
      cdecl.}
