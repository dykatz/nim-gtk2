# Included by headers/glib2.nim; do not import directly.
const
  GLIB_SYSDEF_POLLIN* = 1
const
  GLIB_SYSDEF_POLLOUT* = 4
const
  GLIB_SYSDEF_POLLPRI* = 2
const
  GLIB_SYSDEF_POLLERR* = 8
const
  GLIB_SYSDEF_POLLHUP* = 16
const
  GLIB_SYSDEF_POLLNVAL* = 32

proc GUINT_TO_POINTER*(i: guint): pointer
