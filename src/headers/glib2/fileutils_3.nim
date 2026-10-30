# Included by headers/glib2.nim; do not import directly.
const
  G_HOOK_FLAG_ACTIVE* = 1'u32 shl 0'u32
const
  G_HOOK_FLAG_IN_CALL* = 1'u32 shl 1'u32
const
  G_HOOK_FLAG_MASK* = 0x0000000F'u32

const
  G_HOOK_FLAG_USER_SHIFT* = 4'u32
const
  bm_TGHookList_hook_size* = 0x0000FFFF'u32
const
  bp_TGHookList_hook_size* = 0'u32
const
  bm_TGHookList_is_setup* = 0x00010000'u32
const
  bp_TGHookList_is_setup* = 16'u32

