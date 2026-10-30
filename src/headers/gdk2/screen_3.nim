# Included by headers/gdk2.nim; do not import directly.
proc TYPE_SCREEN*(): GType =
  nil

proc SCREEN*(anObject: pointer): PScreen =
  result = cast[PScreen](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_SCREEN()))

proc SCREEN_CLASS*(klass: pointer): PScreenClass =
  result = cast[PScreenClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_SCREEN()))

proc IS_SCREEN*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_SCREEN())

proc IS_SCREEN_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_SCREEN())

proc SCREEN_GET_CLASS*(obj: pointer): PScreenClass =
  result = cast[PScreenClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_SCREEN()))

proc SELECTION_PRIMARY*(): TAtom =
  result = `MAKE_ATOM`(1)

proc SELECTION_SECONDARY*(): TAtom =
  result = `MAKE_ATOM`(2)

proc SELECTION_CLIPBOARD*(): TAtom =
  result = `MAKE_ATOM`(69)

proc TARGET_BITMAP*(): TAtom =
  result = `MAKE_ATOM`(5)

proc TARGET_COLORMAP*(): TAtom =
  result = `MAKE_ATOM`(7)

proc TARGET_DRAWABLE*(): TAtom =
  result = `MAKE_ATOM`(17)

proc TARGET_PIXMAP*(): TAtom =
  result = `MAKE_ATOM`(20)

proc TARGET_STRING*(): TAtom =
  result = `MAKE_ATOM`(31)

proc SELECTION_TYPE_ATOM*(): TAtom =
  result = `MAKE_ATOM`(4)

proc SELECTION_TYPE_BITMAP*(): TAtom =
  result = `MAKE_ATOM`(5)

proc SELECTION_TYPE_COLORMAP*(): TAtom =
  result = `MAKE_ATOM`(7)

proc SELECTION_TYPE_DRAWABLE*(): TAtom =
  result = `MAKE_ATOM`(17)

proc SELECTION_TYPE_INTEGER*(): TAtom =
  result = `MAKE_ATOM`(19)

proc SELECTION_TYPE_PIXMAP*(): TAtom =
  result = `MAKE_ATOM`(20)

proc SELECTION_TYPE_WINDOW*(): TAtom =
  result = `MAKE_ATOM`(33)

proc SELECTION_TYPE_STRING*(): TAtom =
  result = `MAKE_ATOM`(31)

proc ATOM_TO_POINTER*(atom: TAtom): pointer =
  result = cast[pointer](atom)

proc POINTER_TO_ATOM*(p: pointer): TAtom =
  result = cast[TAtom](p)

proc `MAKE_ATOM`*(val: guint): TAtom =
  result = cast[TAtom](val)

proc NONE*(): TAtom =
  result = `MAKE_ATOM`(0)

