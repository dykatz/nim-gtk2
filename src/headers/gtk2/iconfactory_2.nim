# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ICON_FACTORY*(): GType =
  result = icon_factory_get_type()

proc ICON_FACTORY*(anObject: pointer): PIconFactory =
  result = cast[PIconFactory](G_TYPE_CHECK_INSTANCE_CAST(anObject,
      TYPE_ICON_FACTORY()))

proc ICON_FACTORY_CLASS*(klass: pointer): PIconFactoryClass =
  result = cast[PIconFactoryClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_ICON_FACTORY()))

proc IS_ICON_FACTORY*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_ICON_FACTORY())

proc IS_ICON_FACTORY_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_ICON_FACTORY())

proc ICON_FACTORY_GET_CLASS*(obj: pointer): PIconFactoryClass =
  result = cast[PIconFactoryClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_ICON_FACTORY()))

proc TYPE_ICON_SET*(): GType =
  result = icon_set_get_type()

proc TYPE_ICON_SOURCE*(): GType =
  result = icon_source_get_type()

