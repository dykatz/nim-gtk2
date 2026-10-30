# Included by headers/atk.nim; do not import directly.
proc TYPE_REGISTRY*(): GType =
  result = registry_get_type()

proc REGISTRY*(obj: pointer): PRegistry =
  result = cast[PRegistry](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_REGISTRY()))

proc REGISTRY_CLASS*(klass: pointer): PRegistryClass =
  result = cast[PRegistryClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_REGISTRY()))

proc IS_REGISTRY*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_REGISTRY())

proc IS_REGISTRY_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_REGISTRY())

proc REGISTRY_GET_CLASS*(obj: pointer): PRegistryClass =
  result = cast[PRegistryClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_REGISTRY()))

