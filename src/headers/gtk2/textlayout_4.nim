# Included by headers/gtk2.nim; do not import directly.
# Legacy line-data helpers/constants remain for the separate private line audit.
const
  bm_TGtkTextLineData_width* = 0x00FFFFFF'u32
  bp_TGtkTextLineData_width* = 0'u32
  bm_TGtkTextLineData_valid* = 0xFF000000'u32
  bp_TGtkTextLineData_valid* = 24'u32
proc width*(a: PTextLineData): guint =
  result = a.flag0 and bm_TGtkTextLineData_width

proc set_width*(a: PTextLineData, NewWidth: guint) =
  a.flag0 = (bm_TGtkTextLineData_width and NewWidth) or a.flag0

proc valid*(a: PTextLineData): guint =
  result = (a.flag0 and bm_TGtkTextLineData_valid) shr
      bp_TGtkTextLineData_valid

proc set_valid*(a: PTextLineData, `valid`: guint) =
  a.flag0 = a.flag0 or
      ((`valid` shl bp_TGtkTextLineData_valid) and bm_TGtkTextLineData_valid)

