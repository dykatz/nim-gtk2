# Included by headers/glib2.nim; do not import directly.
const
  G_IO_FLAG_APPEND* = 1 shl 0
const
  G_IO_FLAG_NONBLOCK* = 1 shl 1
const
  G_IO_FLAG_IS_READABLE* = 1 shl 2
const
  G_IO_FLAG_IS_WRITEABLE* = 1 shl 3
const
  G_IO_FLAG_IS_SEEKABLE* = 1 shl 4
const
  G_IO_FLAG_MASK* = (1 shl 5) - 1
const
  G_IO_FLAG_GET_MASK* = G_IO_FLAG_MASK
const
  G_IO_FLAG_SET_MASK* = G_IO_FLAG_APPEND or G_IO_FLAG_NONBLOCK

