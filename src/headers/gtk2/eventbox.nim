# Included by headers/gtk2.nim; do not import directly.
proc TYPE_EVENT_BOX*(): GType
proc EVENT_BOX*(obj: pointer): PEventBox
proc EVENT_BOX_CLASS*(klass: pointer): PEventBoxClass
proc IS_EVENT_BOX*(obj: pointer): bool
proc IS_EVENT_BOX_CLASS*(klass: pointer): bool
proc EVENT_BOX_GET_CLASS*(obj: pointer): PEventBoxClass
proc event_box_get_type*(): TType{.cdecl, dynlib: lib,
                                   importc: "gtk_event_box_get_type".}
proc event_box_new*(): PEventBox{.cdecl, dynlib: lib,
                                  importc: "gtk_event_box_new".}
const
  FNM_PATHNAME* = 1 shl 0
const
  FNM_NOESCAPE* = 1 shl 1
const
  FNM_PERIOD* = 1 shl 2

const
  FNM_FILE_NAME* = FNM_PATHNAME
const
  FNM_LEADING_DIR* = 1 shl 3
const
  FNM_CASEFOLD* = 1 shl 4

const
  FNM_NOMATCH* = 1

proc fnmatch*(`pattern`: char, `string`: char, `flags`: gint): gint{.cdecl,
    dynlib: lib, importc: "fnmatch".}
