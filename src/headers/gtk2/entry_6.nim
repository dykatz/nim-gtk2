# Included by headers/gtk2.nim; do not import directly.
# Only public GType checks/casts remain; no GtkEntry private-bitfield helpers.
proc TYPE_ENTRY*(): GType =
  result = entry_get_type()

proc ENTRY*(obj: pointer): PEntry =
  result = cast[PEntry](CHECK_CAST(obj, TYPE_ENTRY()))

proc ENTRY_CLASS*(klass: pointer): PEntryClass =
  result = cast[PEntryClass](CHECK_CLASS_CAST(klass, TYPE_ENTRY()))

proc IS_ENTRY*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_ENTRY())

proc IS_ENTRY_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_ENTRY())

proc ENTRY_GET_CLASS*(obj: pointer): PEntryClass =
  result = cast[PEntryClass](CHECK_GET_CLASS(obj, TYPE_ENTRY()))
