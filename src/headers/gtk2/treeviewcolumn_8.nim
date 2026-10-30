# Included by headers/gtk2.nim; do not import directly.
proc COLUMN_REQUESTED_WIDTH*(column: PTreeViewColumn): int32 =
  var MinWidth, MaxWidth: int
  if column.min_width != - 1'i32:
    MinWidth = column.min_width
  else:
    MinWidth = column.requested_width
  if column.max_width != - 1'i32:
    MaxWidth = column.max_width
  else:
    MaxWidth = column.requested_width
  result = CLAMP(column.requested_width, MinWidth, MaxWidth).int32

