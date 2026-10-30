# Included by headers/glib2.nim; do not import directly.
proc G_TYPE_MAKE_FUNDAMENTAL*(x: int): GType =
  result = GType(x shl G_TYPE_FUNDAMENTAL_SHIFT)

proc G_TYPE_IS_FUNDAMENTAL*(theType: GType): bool =
  result = theType <= G_TYPE_FUNDAMENTAL_MAX

proc G_TYPE_IS_DERIVED*(theType: GType): bool =
  result = theType > G_TYPE_FUNDAMENTAL_MAX

proc G_TYPE_IS_INTERFACE*(theType: GType): bool =
  result = (G_TYPE_FUNDAMENTAL(theType)) == G_TYPE_INTERFACE

proc G_TYPE_IS_CLASSED*(theType: GType): gboolean =
  result = private_g_type_test_flags(theType, G_TYPE_FLAG_CLASSED)

proc G_TYPE_IS_INSTANTIATABLE*(theType: GType): bool =
  result = private_g_type_test_flags(theType, G_TYPE_FLAG_INSTANTIATABLE)

proc G_TYPE_IS_DERIVABLE*(theType: GType): bool =
  result = private_g_type_test_flags(theType, G_TYPE_FLAG_DERIVABLE)

proc G_TYPE_IS_DEEP_DERIVABLE*(theType: GType): bool =
  result = private_g_type_test_flags(theType, G_TYPE_FLAG_DEEP_DERIVABLE)

proc G_TYPE_IS_ABSTRACT*(theType: GType): bool =
  result = private_g_type_test_flags(theType, G_TYPE_FLAG_ABSTRACT)

proc G_TYPE_IS_VALUE_ABSTRACT*(theType: GType): bool =
  result = private_g_type_test_flags(theType, G_TYPE_FLAG_VALUE_ABSTRACT)

proc G_TYPE_IS_VALUE_TYPE*(theType: GType): bool =
  result = private_g_type_check_is_value_type(theType)

proc G_TYPE_HAS_VALUE_TABLE*(theType: GType): bool =
  result = (g_type_value_table_peek(theType)) != nil

proc G_TYPE_CHECK_INSTANCE*(instance: pointer): gboolean =
  result = private_g_type_check_instance(cast[PGTypeInstance](instance))

