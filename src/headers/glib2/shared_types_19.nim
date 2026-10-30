# Included by headers/glib2.nim; do not import directly.
type
  TGTime* = gint32
  PGTime* = ptr TGTime
  TGDateYear* = guint16
  PGDateYear* = ptr TGDateYear
  TGDateDay* = guint8
  PGDateDay* = ptr TGDateDay
  Ttm*{.final.} = object
    tm_sec*: gint
    tm_min*: gint
    tm_hour*: gint
    tm_mday*: gint
    tm_mon*: gint
    tm_year*: gint
    tm_wday*: gint
    tm_yday*: gint
    tm_isdst*: gint
    tm_gmtoff*: glong
    tm_zone*: cstring


  Ptm* = ptr Ttm
