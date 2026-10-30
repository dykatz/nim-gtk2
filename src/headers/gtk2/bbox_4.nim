# Included by headers/gtk2.nim; do not import directly.
proc BUTTON_BOX*(obj: pointer): PButtonBox =
  result = cast[PButtonBox](CHECK_CAST(obj, TYPE_BUTTON_BOX()))

proc BUTTON_BOX_CLASS*(klass: pointer): PButtonBoxClass =
  result = cast[PButtonBoxClass](CHECK_CLASS_CAST(klass, TYPE_BUTTON_BOX()))

proc IS_BUTTON_BOX*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_BUTTON_BOX())

proc IS_BUTTON_BOX_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_BUTTON_BOX())

proc BUTTON_BOX_GET_CLASS*(obj: pointer): PButtonBoxClass =
  result = cast[PButtonBoxClass](CHECK_GET_CLASS(obj, TYPE_BUTTON_BOX()))

proc button_box_set_spacing*(b: pointer, s: gint) =
  set_spacing(BOX(b), s)

proc button_box_get_spacing*(b: pointer): gint =
  result = get_spacing(BOX(b))

