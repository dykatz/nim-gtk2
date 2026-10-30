# Included by headers/xkb.nim; do not import directly.
proc XkbLegalXILedClass*(c: int): bool
proc XkbLegalXIBellClass*(c: int): bool
proc XkbExplicitXIDevice*(c: int): bool
proc XkbExplicitXIClass*(c: int): bool
proc XkbExplicitXIId*(c: int): bool
proc XkbSingleXIClass*(c: int): bool
proc XkbSingleXIId*(c: int): bool
