# Included by headers/gtk2.nim; do not import directly.
type
  PTextLine* = ptr TTextLine
  TTextChildBody*{.final, pure.} = object
    obj*: PTextChildAnchor
    widgets*: PGSList
    tree*: PTextBTree
    line*: PTextLine

  PTextLineSegment* = ptr TTextLineSegment
  PTextLineSegmentClass* = ptr TTextLineSegmentClass
  TTextLineSegment*{.final, pure.} = object
    `type`*: PTextLineSegmentClass
    next*: PTextLineSegment
    char_count*: int32
    byte_count*: int32
    body*: TTextChildBody

  TTextSegSplitFunc* = TTextLineSegment
  TTextSegDeleteFunc* = proc (seg: PTextLineSegment, line: PTextLine,
                              tree_gone: gboolean): gboolean{.cdecl.}
  TTextSegCleanupFunc* = TTextLineSegment
  TTextSegLineChangeFunc* = proc (seg: PTextLineSegment, line: PTextLine){.cdecl.}
  TTextSegCheckFunc* = proc (seg: PTextLineSegment, line: PTextLine){.cdecl.}
  TTextLineSegmentClass*{.final, pure.} = object
    name*: cstring
    leftGravity*: gboolean
    splitFunc*: TTextSegSplitFunc
    deleteFunc*: TTextSegDeleteFunc
    cleanupFunc*: TTextSegCleanupFunc
    lineChangeFunc*: TTextSegLineChangeFunc
    checkFunc*: TTextSegCheckFunc

  TTextLine*{.final, pure.} = object
    parent*: PTextBTreeNode
    next*: PTextLine
    segments*: PTextLineSegment
    views*: PTextLineData

  TTextMarkBody*{.final, pure.} = object
    obj*: PTextMark
    name*: cstring
    tree*: PTextBTree
    line*: PTextLine
    flag0*: guint16

  PTextMarkBody* = ptr TTextMarkBody
  PTextChildBody* = ptr TTextChildBody
  PTextSegSplitFunc* = ptr TTextSegSplitFunc
  PTextSegCleanupFunc* = ptr TTextSegCleanupFunc
