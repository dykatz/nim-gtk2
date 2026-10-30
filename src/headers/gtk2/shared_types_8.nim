# Included by headers/gtk2.nim; do not import directly.
type
  TTextTagTableForeach* = proc (tag: PTextTag, data: gpointer){.cdecl.}
  TTextTagInfo*{.final, pure.} = object
    tag*: PTextTag
    tag_root*: PTextBTreeNode
    toggle_count*: gint

  PTextTagInfo* = ptr TTextTagInfo
  TTextToggleBody*{.final, pure.} = object
    info*: PTextTagInfo
    inNodeCounts*: gboolean

  PTextToggleBody* = ptr TTextToggleBody
