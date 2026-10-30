# Included by headers/xkb.nim; do not import directly.
type
  XkbControlsRec*{.final.} = object
    mk_dflt_btn*: int8
    num_groups*: int8
    groups_wrap*: int8
    internal*: XkbModsRec
    ignore_lock*: XkbModsRec
    enabled_ctrls*: int16
    repeat_delay*: int16
    repeat_interval*: int16
    slow_keys_delay*: int16
    debounce_delay*: int16
    mk_delay*: int16
    mk_interval*: int16
    mk_time_to_max*: int16
    mk_max_speed*: int16
    mk_curve*: int16
    ax_options*: int16
    ax_timeout*: int16
    axt_opts_mask*: int16
    axt_opts_values*: int16
    axt_ctrls_mask*: int16
    axt_ctrls_values*: int16
    per_key_repeat*: array[0..XkbPerKeyBitArraySize - 1, int8]

  PXkbControlsPtr* = ptr XkbControlsRec
