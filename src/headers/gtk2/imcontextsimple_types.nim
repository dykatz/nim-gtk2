# Included by headers/gtk2.nim; do not import directly.
type
  TIMContextSimple* = object of TIMContext
    tables*: PGSList
    compose_buffer*: array[0..(MAX_COMPOSE_LEN + 1) - 1, guint]
    tentative_match*: gunichar
    tentative_match_len*: gint
    IMContextSimple_flag0*: guint16

  PIMContextSimple* = ptr TIMContextSimple
  TIMContextSimpleClass* = object of TIMContextClass
  PIMContextSimpleClass* = ptr TIMContextSimpleClass
