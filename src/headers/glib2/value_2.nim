# Included by headers/glib2.nim; do not import directly.
proc HOLDS_CHAR*(value: PGValue): bool
proc HOLDS_UCHAR*(value: PGValue): bool
proc HOLDS_BOOLEAN*(value: PGValue): bool
proc HOLDS_INT*(value: PGValue): bool
proc HOLDS_UINT*(value: PGValue): bool
proc HOLDS_LONG*(value: PGValue): bool
proc HOLDS_ULONG*(value: PGValue): bool
proc HOLDS_INT64*(value: PGValue): bool
proc HOLDS_UINT64*(value: PGValue): bool
proc HOLDS_FLOAT*(value: PGValue): bool
proc HOLDS_DOUBLE*(value: PGValue): bool
proc HOLDS_STRING*(value: PGValue): bool
proc HOLDS_POINTER*(value: PGValue): bool
