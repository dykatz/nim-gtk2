# Included by headers/gtk2.nim; do not import directly.
type
  PWindowGeometryInfo* = pointer
  TWindowGroup* = object of TGObject
    grabs*: PGSList

  PWindowGroup* = ptr TWindowGroup
  TWindowGroupClass* = object of TGObjectClass
    reserved40: proc (){.cdecl.}
    reserved41: proc (){.cdecl.}
    reserved42: proc (){.cdecl.}
    reserved43: proc (){.cdecl.}

  PWindowGroupClass* = ptr TWindowGroupClass
