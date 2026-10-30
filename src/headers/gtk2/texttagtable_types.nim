# Included by headers/gtk2.nim; do not import directly.
type
  TTextTagTable* = object of TGObject
    hash*: PGHashTable
    anonymous*: PGSList
    anon_count*: gint
    buffers*: PGSList

  PTextTagTable* = ptr TTextTagTable
