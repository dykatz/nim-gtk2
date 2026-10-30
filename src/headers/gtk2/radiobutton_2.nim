# Included by headers/gtk2.nim; do not import directly.
proc TYPE_RADIO_BUTTON*(): GType =
  result = radio_button_get_type()

proc RADIO_BUTTON*(obj: pointer): PRadioButton =
  result = cast[PRadioButton](CHECK_CAST(obj, TYPE_RADIO_BUTTON()))

proc RADIO_BUTTON_CLASS*(klass: pointer): PRadioButtonClass =
  result = cast[PRadioButtonClass](CHECK_CLASS_CAST(klass, TYPE_RADIO_BUTTON()))

proc IS_RADIO_BUTTON*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_RADIO_BUTTON())

proc IS_RADIO_BUTTON_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_RADIO_BUTTON())

proc RADIO_BUTTON_GET_CLASS*(obj: pointer): PRadioButtonClass =
  result = cast[PRadioButtonClass](CHECK_GET_CLASS(obj, TYPE_RADIO_BUTTON()))

