# Included by headers/glib2.nim; do not import directly.
type
  TGFileError* = gint

  PGFileError* = ptr TGFileError
  TGFileTest* = int

  PGFileTest* = ptr TGFileTest
