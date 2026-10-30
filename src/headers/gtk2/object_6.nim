# Included by headers/gtk2.nim; do not import directly.
proc signal_connect*(anObject: PObject, name: cstring, fun: TSignalFunc,
                     func_data: gpointer): gulong =
  result = signal_connect_full(anObject, name, fun, nil, func_data, nil, 0, 0)

proc signal_connect_after*(anObject: PObject, name: cstring, fun: TSignalFunc,
                           func_data: gpointer): gulong =
  result = signal_connect_full(anObject, name, fun, nil, func_data, nil, 0, 1)

proc signal_connect_object*(anObject: PObject, name: cstring,
                            fun: TSignalFunc, slot_object: gpointer): gulong =
  result = signal_connect_full(anObject, name, fun, nil, slot_object, nil, 1,
                               0)

proc signal_connect_object_after*(anObject: PObject, name: cstring,
                                  fun: TSignalFunc, slot_object: gpointer): gulong =
  result = signal_connect_full(anObject, name, fun, nil, slot_object, nil, 1,
                               1)

proc signal_disconnect*(anObject: gpointer, handler_id: gulong) =
  g_signal_handler_disconnect(anObject, handler_id)

proc signal_handler_block*(anObject: gpointer, handler_id: gulong) =
  g_signal_handler_block(anObject, handler_id)

proc signal_handler_unblock*(anObject: gpointer, handler_id: gulong) =
  g_signal_handler_unblock(anObject, handler_id)

proc signal_disconnect_by_data*(anObject: PObject, data: gpointer) =
  signal_compat_matched(anObject, nil, data, G_SIGNAL_MATCH_DATA, 0)

proc signal_disconnect_by_func*(anObject: PObject, fun: TSignalFunc,
                                data: gpointer) =
  signal_compat_matched(anObject, fun, data, cast[TGSignalMatchType](G_SIGNAL_MATCH_FUNC or
      G_SIGNAL_MATCH_DATA), 0)

proc signal_handler_block_by_func*(anObject: PObject, fun: TSignalFunc,
                                   data: gpointer) =
  signal_compat_matched(anObject, fun, data, TGSignalMatchType(
      G_SIGNAL_MATCH_FUNC or G_SIGNAL_MATCH_DATA), 0)

proc signal_handler_block_by_data*(anObject: PObject, data: gpointer) =
  signal_compat_matched(anObject, nil, data, G_SIGNAL_MATCH_DATA, 1)

proc signal_handler_unblock_by_func*(anObject: PObject, fun: TSignalFunc,
                                     data: gpointer) =
  signal_compat_matched(anObject, fun, data, cast[TGSignalMatchType](G_SIGNAL_MATCH_FUNC or
      G_SIGNAL_MATCH_DATA), 0)

proc signal_handler_unblock_by_data*(anObject: PObject, data: gpointer) =
  signal_compat_matched(anObject, nil, data, G_SIGNAL_MATCH_DATA, 2)

proc signal_handler_pending*(anObject: PObject, signal_id: guint,
                             may_be_blocked: gboolean): gboolean =
  result = g_signal_has_handler_pending(anObject, signal_id, 0, may_be_blocked)

proc signal_handler_pending_by_func*(anObject: PObject, signal_id: guint,
                                     may_be_blocked: gboolean,
                                     fun: TSignalFunc,
                                     data: gpointer): gboolean =
  var t: TGSignalMatchType
  t = cast[TGSignalMatchType](G_SIGNAL_MATCH_ID or G_SIGNAL_MATCH_FUNC or
      G_SIGNAL_MATCH_DATA)
  if not may_be_blocked:
    t = t or cast[TGSignalMatchType](G_SIGNAL_MATCH_UNBLOCKED)
  result = g_signal_handler_find(anObject, t, signal_id, 0, nil, fun, data) !=
      0

