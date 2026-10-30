# Included by headers/glib2.nim; do not import directly.
proc TGHookList_hook_size*(a: PGHookList): guint =
  result = (a.flag0 and bm_TGHookList_hook_size) shr bp_TGHookList_hook_size

proc TGHookList_set_hook_size*(a: PGHookList, `hook_size`: guint) =
  a.flag0 = a.flag0 or
      ((`hook_size` shl bp_TGHookList_hook_size) and bm_TGHookList_hook_size)

proc TGHookList_is_setup*(a: PGHookList): guint =
  result = (a.flag0 and bm_TGHookList_is_setup) shr bp_TGHookList_is_setup

proc TGHookList_set_is_setup*(a: PGHookList, `is_setup`: guint) =
  a.flag0 = a.flag0 or
      ((`is_setup` shl bp_TGHookList_is_setup) and bm_TGHookList_is_setup)

proc G_HOOK*(hook: pointer): PGHook =
  result = cast[PGHook](hook)

proc FLAGS*(hook: PGHook): guint =
  result = hook.flags

proc ACTIVE*(hook: PGHook): bool =
  result = (hook.flags and G_HOOK_FLAG_ACTIVE) != 0'u32

proc IN_CALL*(hook: PGHook): bool =
  result = (hook.flags and G_HOOK_FLAG_IN_CALL) != 0'u32

proc IS_VALID*(hook: PGHook): bool =
  result = (hook.hook_id != 0) and ACTIVE(hook)

proc IS_UNLINKED*(hook: PGHook): bool =
  result = (hook.next == nil) and (hook.prev == nil) and (hook.hook_id == 0) and
      (hook.ref_count == 0'u32)

proc append*(hook_list: PGHookList, hook: PGHook) =
  insert_before(hook_list, nil, hook)

