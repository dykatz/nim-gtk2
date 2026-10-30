# Included by headers/gtk2.nim; do not import directly.
type
  TSelectionData*{.final, pure.} = object
    selection*: gdk2.TAtom
    target*: gdk2.TAtom
    thetype*: gdk2.TAtom
    format*: gint
    data*: Pguchar
    length*: gint
    display*: gdk2.PDisplay

  PSelectionData* = ptr TSelectionData
  TTargetEntry*{.final, pure.} = object
    target*: cstring
    flags*: guint
    info*: guint

  PTargetEntry* = ptr TTargetEntry
  TTargetList*{.final, pure.} = object
    list*: PGList
    ref_count*: guint

  PTargetList* = ptr TTargetList
  TTargetPair*{.final, pure.} = object
    target*: gdk2.TAtom
    flags*: guint
    info*: guint

  PTargetPair* = ptr TTargetPair
