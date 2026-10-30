# Included by headers/pango.nim; do not import directly.
type
  TAttrList* {.pure, final.} = object
  PAttrList* = ptr TAttrList
  TAttrIterator* {.pure, final.} = object
  PAttrIterator* = ptr TAttrIterator
  TAttrType* = int32
  PAttrType* = ptr TAttrType
  TUnderline* = int32
  PUnderline* = ptr TUnderline
  PAttribute* = ptr TAttribute
  PAttrClass* = ptr TAttrClass
  TAttribute*{.final, pure.} = object
    klass*: PAttrClass
    start_index*: int
    end_index*: int

  TAttrClass*{.final, pure.} = object
    `type`*: TAttrType
    copy*: proc (attr: PAttribute): PAttribute{.cdecl.}
    destroy*: proc (attr: PAttribute){.cdecl.}
    equal*: proc (attr1: PAttribute, attr2: PAttribute): gboolean{.cdecl.}

  TAttrString*{.final, pure.} = object
    attr*: TAttribute
    value*: cstring

  PAttrString* = ptr TAttrString
  TAttrInt*{.final, pure.} = object
    attr*: TAttribute
    value*: int32

  PAttrInt* = ptr TAttrInt
  TAttrFloat*{.final, pure.} = object
    attr*: TAttribute
    value*: gdouble

  PAttrFloat* = ptr TAttrFloat
  TAttrFontDesc*{.final, pure.} = object
    attr*: TAttribute
    desc*: PFontDescription

  PAttrFontDesc* = ptr TAttrFontDesc
