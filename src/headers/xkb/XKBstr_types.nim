# Included by headers/xkb.nim; do not import directly.
type
  XkbStateRec*{.final.} = object
    group*: int8
    locked_group*: int8
    base_group*: int16
    latched_group*: int16
    mods*: int8
    base_mods*: int8
    latched_mods*: int8
    locked_mods*: int8
    compat_state*: int8
    grab_mods*: int8
    compat_grab_mods*: int8
    lookup_mods*: int8
    compat_lookup_mods*: int8
    ptr_buttons*: int16

