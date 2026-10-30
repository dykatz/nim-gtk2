# Included by headers/gtk2.nim; do not import directly.
proc TYPE_BUTTON*(): GType =
  result = button_get_type()

proc BUTTON*(obj: pointer): PButton =
  result = cast[PButton](CHECK_CAST(obj, TYPE_BUTTON()))

proc BUTTON_CLASS*(klass: pointer): PButtonClass =
  result = cast[PButtonClass](CHECK_CLASS_CAST(klass, TYPE_BUTTON()))

proc IS_BUTTON*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_BUTTON())

proc IS_BUTTON_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_BUTTON())

proc BUTTON_GET_CLASS*(obj: pointer): PButtonClass =
  result = cast[PButtonClass](CHECK_GET_CLASS(obj, TYPE_BUTTON()))

proc constructed*(a: PButton): guint =
  result = (a.button_flag0 and bm_TGtkButton_constructed) shr
      bp_TGtkButton_constructed

proc set_constructed*(a: PButton, `constructed`: guint) =
  a.button_flag0 = a.button_flag0 or
      (uint16(`constructed` shl bp_TGtkButton_constructed) and
      bm_TGtkButton_constructed)

proc in_button*(a: PButton): guint =
  result = ((a.button_flag0 and bm_TGtkButton_in_button) shr
      bp_TGtkButton_in_button).guint

proc set_in_button*(a: PButton, `in_button`: guint) =
  a.button_flag0 = a.button_flag0 or
      (uint16(`in_button` shl bp_TGtkButton_in_button) and
      bm_TGtkButton_in_button)

proc button_down*(a: PButton): guint =
  result = ((a.button_flag0 and bm_TGtkButton_button_down) shr
      bp_TGtkButton_button_down).guint

proc set_button_down*(a: PButton, `button_down`: guint) =
  a.button_flag0 = a.button_flag0 or
      (uint16(`button_down` shl bp_TGtkButton_button_down) and
      bm_TGtkButton_button_down)

proc relief*(a: PButton): guint =
  result = ((a.button_flag0 and bm_TGtkButton_relief) shr bp_TGtkButton_relief).guint

proc use_underline*(a: PButton): guint =
  result = ((a.button_flag0 and bm_TGtkButton_use_underline) shr
      bp_TGtkButton_use_underline).guint

proc set_use_underline*(a: PButton, `use_underline`: guint) =
  a.button_flag0 = a.button_flag0 or
      (uint16(`use_underline` shl bp_TGtkButton_use_underline) and
      bm_TGtkButton_use_underline)

proc use_stock*(a: PButton): guint =
  result = ((a.button_flag0 and bm_TGtkButton_use_stock) shr
      bp_TGtkButton_use_stock).guint

proc set_use_stock*(a: PButton, `use_stock`: guint) =
  a.button_flag0 = a.button_flag0 or
      (uint16(`use_stock` shl bp_TGtkButton_use_stock) and
      bm_TGtkButton_use_stock)

proc depressed*(a: PButton): guint =
  result = ((a.button_flag0 and bm_TGtkButton_depressed) shr
      bp_TGtkButton_depressed).guint

proc set_depressed*(a: PButton, `depressed`: guint) =
  a.button_flag0 = a.button_flag0 or
      (uint16(`depressed` shl bp_TGtkButton_depressed) and
      bm_TGtkButton_depressed)

proc depress_on_activate*(a: PButton): guint =
  result = ((a.button_flag0 and bm_TGtkButton_depress_on_activate) shr
      bp_TGtkButton_depress_on_activate).guint

proc set_depress_on_activate*(a: PButton, `depress_on_activate`: guint) =
  a.button_flag0 = a.button_flag0 or
      (uint16(`depress_on_activate` shl bp_TGtkButton_depress_on_activate) and
      bm_TGtkButton_depress_on_activate)

