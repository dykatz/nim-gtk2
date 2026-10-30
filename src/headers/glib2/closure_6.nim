# Included by headers/glib2.nim; do not import directly.
proc N_NOTIFIERS*(cl: PGClosure): uint32 =
  result = ((meta_marshal(cl) + ((n_guards(cl)) shl 1'u32)) +
      (n_fnotifiers(cl))) + (n_inotifiers(cl))

proc CCLOSURE_SWAP_DATA*(cclosure: PGClosure): uint32 =
  result = derivative_flag(cclosure)

proc G_CALLBACK*(f: pointer): TGCallback =
  result = cast[TGCallback](f)

proc ref_count*(a: PGClosure): guint =
  result = (a.flag0 and bm_TGClosure_ref_count) shr bp_TGClosure_ref_count

proc set_ref_count*(a: PGClosure, `ref_count`: guint) =
  a.flag0 = a.flag0 or
      ((`ref_count` shl bp_TGClosure_ref_count) and bm_TGClosure_ref_count)

proc meta_marshal*(a: PGClosure): guint =
  result = (a.flag0 and bm_TGClosure_meta_marshal) shr
      bp_TGClosure_meta_marshal

proc set_meta_marshal*(a: PGClosure, `meta_marshal`: guint) =
  a.flag0 = a.flag0 or
      ((`meta_marshal` shl bp_TGClosure_meta_marshal) and
      bm_TGClosure_meta_marshal)

proc n_guards*(a: PGClosure): guint =
  result = (a.flag0 and bm_TGClosure_n_guards) shr bp_TGClosure_n_guards

proc set_n_guards*(a: PGClosure, `n_guards`: guint) =
  a.flag0 = a.flag0 or
      ((`n_guards` shl bp_TGClosure_n_guards) and bm_TGClosure_n_guards)

proc n_fnotifiers*(a: PGClosure): guint =
  result = (a.flag0 and bm_TGClosure_n_fnotifiers) shr
      bp_TGClosure_n_fnotifiers

proc set_n_fnotifiers*(a: PGClosure, `n_fnotifiers`: guint) =
  a.flag0 = a.flag0 or
      ((`n_fnotifiers` shl bp_TGClosure_n_fnotifiers) and
      bm_TGClosure_n_fnotifiers)

proc n_inotifiers*(a: PGClosure): guint =
  result = (a.flag0 and bm_TGClosure_n_inotifiers) shr
      bp_TGClosure_n_inotifiers

proc set_n_inotifiers*(a: PGClosure, `n_inotifiers`: guint) =
  a.flag0 = a.flag0 or
      ((`n_inotifiers` shl bp_TGClosure_n_inotifiers) and
      bm_TGClosure_n_inotifiers)

proc in_inotify*(a: PGClosure): guint =
  result = (a.flag0 and bm_TGClosure_in_inotify) shr bp_TGClosure_in_inotify

proc set_in_inotify*(a: PGClosure, `in_inotify`: guint) =
  a.flag0 = a.flag0 or
      ((`in_inotify` shl bp_TGClosure_in_inotify) and bm_TGClosure_in_inotify)

proc floating*(a: PGClosure): guint =
  result = (a.flag0 and bm_TGClosure_floating) shr bp_TGClosure_floating

proc set_floating*(a: PGClosure, `floating`: guint) =
  a.flag0 = a.flag0 or
      ((`floating` shl bp_TGClosure_floating) and bm_TGClosure_floating)

proc derivative_flag*(a: PGClosure): guint =
  result = (a.flag0 and bm_TGClosure_derivative_flag) shr
      bp_TGClosure_derivative_flag

proc set_derivative_flag*(a: PGClosure, `derivative_flag`: guint) =
  a.flag0 = a.flag0 or
      ((`derivative_flag` shl bp_TGClosure_derivative_flag) and
      bm_TGClosure_derivative_flag)

proc in_marshal*(a: PGClosure): guint =
  result = (a.flag0 and bm_TGClosure_in_marshal) shr bp_TGClosure_in_marshal

proc set_in_marshal*(a: PGClosure, in_marshal: guint) =
  a.flag0 = a.flag0 or
      ((in_marshal shl bp_TGClosure_in_marshal) and bm_TGClosure_in_marshal)

proc is_invalid*(a: PGClosure): guint =
  result = (a.flag0 and bm_TGClosure_is_invalid) shr bp_TGClosure_is_invalid

proc set_is_invalid*(a: PGClosure, is_invalid: guint) =
  a.flag0 = a.flag0 or
      ((is_invalid shl bp_TGClosure_is_invalid) and bm_TGClosure_is_invalid)

proc g_signal_connect*(instance: gpointer, detailed_signal: cstring,
                       c_handler: TGCallback, data: gpointer): gulong =
  result = g_signal_connect_data(instance, detailed_signal, c_handler, data,
                                 nil, TGConnectFlags(0))

proc g_signal_connect_after*(instance: gpointer, detailed_signal: cstring,
                             c_handler: TGCallback, data: gpointer): gulong =
  result = g_signal_connect_data(instance, detailed_signal, c_handler, data,
                                 nil, G_CONNECT_AFTER)

proc g_signal_connect_swapped*(instance: gpointer, detailed_signal: cstring,
                               c_handler: TGCallback, data: gpointer): gulong =
  result = g_signal_connect_data(instance, detailed_signal, c_handler, data,
                                 nil, G_CONNECT_SWAPPED)

proc g_signal_handlers_disconnect_by_func*(instance: gpointer,
    fn, data: gpointer): guint =
  result = g_signal_handlers_disconnect_matched(instance,
      TGSignalMatchType(G_SIGNAL_MATCH_FUNC or G_SIGNAL_MATCH_DATA), 0, 0, nil,
      fn, data)

proc g_signal_handlers_block_by_func*(instance: gpointer, fn, data: gpointer) =
  discard g_signal_handlers_block_matched(instance,
      TGSignalMatchType(G_SIGNAL_MATCH_FUNC or G_SIGNAL_MATCH_DATA), 0, 0, nil,
      fn, data)

proc g_signal_handlers_unblock_by_func*(instance: gpointer, fn, data: gpointer) =
  discard g_signal_handlers_unblock_matched(instance,
      TGSignalMatchType(G_SIGNAL_MATCH_FUNC or G_SIGNAL_MATCH_DATA), 0, 0, nil,
      fn, data)

proc G_TYPE_IS_OBJECT*(theType: GType): bool =
  result = (G_TYPE_FUNDAMENTAL(theType)) == G_TYPE_OBJECT

