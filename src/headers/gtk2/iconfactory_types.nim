# Included by headers/gtk2.nim; do not import directly.
type
  TIconFactory* = object of TGObject
    icons*: PGHashTable

  PIconFactory* = ptr TIconFactory
  TIconFactoryClass* = object of TGObjectClass
    reserved431: proc (){.cdecl.}
    reserved432: proc (){.cdecl.}
    reserved433: proc (){.cdecl.}
    reserved434: proc (){.cdecl.}

  PIconFactoryClass* = ptr TIconFactoryClass
