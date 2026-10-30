# Included by headers/glib2.nim; do not import directly.
proc previous*(list: PGList): PGList =
  if list != nil:
    result = list.prev
  else:
    result = nil

proc next*(list: PGList): PGList =
  if list != nil:
    result = list.next
  else:
    result = nil

