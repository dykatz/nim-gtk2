# Included by headers/glib2.nim; do not import directly.
converter gbool*(nimbool: bool): gboolean =
  return ord(nimbool).gboolean

converter toBool*(gbool: gboolean): bool =
  return int(gbool) == 1

const
  G_TYPE_FUNDAMENTAL_SHIFT* = 2
const
  G_TYPE_FUNDAMENTAL_MAX* = GType(255 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_INVALID* = GType(0 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_NONE* = GType(1 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_INTERFACE* = GType(2 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_CHAR* = GType(3 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_UCHAR* = GType(4 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_BOOLEAN* = GType(5 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_INT* = GType(6 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_UINT* = GType(7 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_LONG* = GType(8 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_ULONG* = GType(9 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_INT64* = GType(10 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_UINT64* = GType(11 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_ENUM* = GType(12 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_FLAGS* = GType(13 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_FLOAT* = GType(14 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_DOUBLE* = GType(15 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_STRING* = GType(16 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_POINTER* = GType(17 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_BOXED* = GType(18 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_PARAM* = GType(19 shl G_TYPE_FUNDAMENTAL_SHIFT)
const
  G_TYPE_OBJECT* = GType(20 shl G_TYPE_FUNDAMENTAL_SHIFT)

const
  G_PRIORITY_HIGH_IDLE* = 100
const
  G_PRIORITY_DEFAULT_IDLE* = 200
const
  G_PRIORITY_LOW* = 300
const
  G_PRIORITY_HIGH* = -100
const
  G_PRIORITY_DEFAULT* = 0


proc G_TYPE_MAKE_FUNDAMENTAL*(x: int): GType
const
  G_TYPE_RESERVED_GLIB_FIRST* = 21
const
  G_TYPE_RESERVED_GLIB_LAST* = 31
const
  G_TYPE_RESERVED_BSE_FIRST* = 32
const
  G_TYPE_RESERVED_BSE_LAST* = 48
const
  G_TYPE_RESERVED_USER_FIRST* = 49

proc G_TYPE_IS_FUNDAMENTAL*(theType: GType): bool
proc G_TYPE_IS_DERIVED*(theType: GType): bool
proc G_TYPE_IS_INTERFACE*(theType: GType): bool
proc G_TYPE_IS_CLASSED*(theType: GType): gboolean
proc G_TYPE_IS_INSTANTIATABLE*(theType: GType): bool
proc G_TYPE_IS_DERIVABLE*(theType: GType): bool
proc G_TYPE_IS_DEEP_DERIVABLE*(theType: GType): bool
proc G_TYPE_IS_ABSTRACT*(theType: GType): bool
proc G_TYPE_IS_VALUE_ABSTRACT*(theType: GType): bool
proc G_TYPE_IS_VALUE_TYPE*(theType: GType): bool
proc G_TYPE_HAS_VALUE_TABLE*(theType: GType): bool
proc G_TYPE_CHECK_INSTANCE*(instance: pointer): gboolean
