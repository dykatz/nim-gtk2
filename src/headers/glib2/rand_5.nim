# Included by headers/glib2.nim; do not import directly.
proc boolean*(rand: PGRand): gboolean =
  result = (int(rand_int(rand)) and (1 shl 15)) != 0

proc g_random_boolean*(): gboolean =
  result = (int(g_random_int()) and (1 shl 15)) != 0

