# Included by headers/gtk2.nim; do not import directly.
type
  TSizeGroup* = object of TGObject
    widgets*: PGSList
    mode*: guint8
    SizeGroup_flag0*: guint16
    requisition*: TRequisition

  PSizeGroup* = ptr TSizeGroup
  TSizeGroupClass* = object of TGObjectClass
    reserved611: proc (){.cdecl.}
    reserved612: proc (){.cdecl.}
    reserved613: proc (){.cdecl.}
    reserved614: proc (){.cdecl.}

  PSizeGroupClass* = ptr TSizeGroupClass
  TSizeGroupMode* = enum
    SIZE_GROUP_NONE, SIZE_GROUP_HORIZONTAL, SIZE_GROUP_VERTICAL, SIZE_GROUP_BOTH
  PSizeGroupMode* = ptr TSizeGroupMode
