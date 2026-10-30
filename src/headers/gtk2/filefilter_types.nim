# Included by headers/gtk2.nim; do not import directly.
type
  TFileFilter {.pure, final.} = object
  PFileFilter* = ptr TFileFilter
  PPGtkFileFilter* = ptr PFileFilter
  TFileFilterFlags* = enum
    FILE_FILTER_FILENAME = 1 shl 0, FILE_FILTER_URI = 1 shl 1,
    FILE_FILTER_DISPLAY_NAME = 1 shl 2, FILE_FILTER_MIME_TYPE = 1 shl 3
  PFileFilterFlags* = ptr TFileFilterFlags
  TFileFilterInfo*{.final, pure.} = object
    contains*: TFileFilterFlags
    filename*: cstring
    uri*: cstring
    display_name*: cstring
    mime_type*: cstring

  PFileFilterInfo* = ptr TFileFilterInfo
