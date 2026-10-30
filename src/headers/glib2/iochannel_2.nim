# Included by headers/glib2.nim; do not import directly.
const
  G_LOG_FLAG_RECURSION* = 1 shl 0
const
  G_LOG_FLAG_FATAL* = 1 shl 1
const
  G_LOG_LEVEL_ERROR* = 1 shl 2
const
  G_LOG_LEVEL_CRITICAL* = 1 shl 3
const
  G_LOG_LEVEL_WARNING* = 1 shl 4
const
  G_LOG_LEVEL_MESSAGE* = 1 shl 5
const
  G_LOG_LEVEL_INFO* = 1 shl 6
const
  G_LOG_LEVEL_DEBUG* = 1 shl 7
const
  G_LOG_LEVEL_MASK* = not 3

const
  G_LOG_FATAL_MASK* = 5

