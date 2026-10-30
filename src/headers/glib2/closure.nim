# Included by headers/glib2.nim; do not import directly.
proc N_NOTIFIERS*(cl: PGClosure): uint32
proc CCLOSURE_SWAP_DATA*(cclosure: PGClosure): uint32
proc G_CALLBACK*(f: pointer): TGCallback
const
  bm_TGClosure_ref_count* = 0x00007FFF'u32
const
  bp_TGClosure_ref_count* = 0'u32
const
  bm_TGClosure_meta_marshal* = 0x00008000'u32
const
  bp_TGClosure_meta_marshal* = 15'u32
const
  bm_TGClosure_n_guards* = 0x00010000'u32
const
  bp_TGClosure_n_guards* = 16'u32
const
  bm_TGClosure_n_fnotifiers* = 0x00060000'u32
const
  bp_TGClosure_n_fnotifiers* = 17'u32
const
  bm_TGClosure_n_inotifiers* = 0x07F80000'u32
const
  bp_TGClosure_n_inotifiers* = 19'u32
const
  bm_TGClosure_in_inotify* = 0x08000000'u32
const
  bp_TGClosure_in_inotify* = 27'u32
const
  bm_TGClosure_floating* = 0x10000000'u32
const
  bp_TGClosure_floating* = 28'u32
const
  bm_TGClosure_derivative_flag* = 0x20000000'u32
const
  bp_TGClosure_derivative_flag* = 29'u32
const
  bm_TGClosure_in_marshal* = 0x40000000'u32
const
  bp_TGClosure_in_marshal* = 30'u32
const
  bm_TGClosure_is_invalid* = 0x80000000'u32
const
  bp_TGClosure_is_invalid* = 31'u32

proc ref_count*(a: PGClosure): guint
proc set_ref_count*(a: PGClosure, ref_count: guint)
proc meta_marshal*(a: PGClosure): guint
proc set_meta_marshal*(a: PGClosure, meta_marshal: guint)
proc n_guards*(a: PGClosure): guint
proc set_n_guards*(a: PGClosure, n_guards: guint)
proc n_fnotifiers*(a: PGClosure): guint
proc set_n_fnotifiers*(a: PGClosure, n_fnotifiers: guint)
proc n_inotifiers*(a: PGClosure): guint
proc in_inotify*(a: PGClosure): guint
proc set_in_inotify*(a: PGClosure, in_inotify: guint)
proc floating*(a: PGClosure): guint
proc set_floating*(a: PGClosure, floating: guint)
proc derivative_flag*(a: PGClosure): guint
proc set_derivative_flag*(a: PGClosure, derivative_flag: guint)
proc in_marshal*(a: PGClosure): guint
proc set_in_marshal*(a: PGClosure, in_marshal: guint)
proc is_invalid*(a: PGClosure): guint
proc set_is_invalid*(a: PGClosure, is_invalid: guint)
