# Included by headers/atk.nim; do not import directly.
type
  TPropertyChangeHandler* = proc (para1: PObject, para2: PPropertyValues){.cdecl.}
  TFocusHandler* = proc (para1: PObject, para2: gboolean){.cdecl.}
  TEventListener* = proc (para1: PObject){.cdecl.}
