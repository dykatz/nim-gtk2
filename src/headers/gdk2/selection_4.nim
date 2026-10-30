# Included by headers/gdk2.nim; do not import directly.
proc ATOM_TO_POINTER*(atom: TAtom): pointer
proc POINTER_TO_ATOM*(p: pointer): TAtom
proc `MAKE_ATOM`*(val: guint): TAtom
proc NONE*(): TAtom
