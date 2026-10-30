# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ITEM_FACTORY*(): GType =
  result = item_factory_get_type()

proc ITEM_FACTORY*(anObject: pointer): PItemFactory =
  result = cast[PItemFactory](CHECK_CAST(anObject, TYPE_ITEM_FACTORY()))

proc ITEM_FACTORY_CLASS*(klass: pointer): PItemFactoryClass =
  result = cast[PItemFactoryClass](CHECK_CLASS_CAST(klass, TYPE_ITEM_FACTORY()))

proc IS_ITEM_FACTORY*(anObject: pointer): bool =
  result = CHECK_TYPE(anObject, TYPE_ITEM_FACTORY())

proc IS_ITEM_FACTORY_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_ITEM_FACTORY())

proc ITEM_FACTORY_GET_CLASS*(obj: pointer): PItemFactoryClass =
  result = cast[PItemFactoryClass](CHECK_GET_CLASS(obj, TYPE_ITEM_FACTORY()))

