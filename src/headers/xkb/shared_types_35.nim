# Included by headers/xkb.nim; do not import directly.
type
  XkbMapChangesRec*{.final.} = object
    changed*: int16
    min_key_code*: KeyCode
    max_key_code*: KeyCode
    first_type*: int8
    num_types*: int8
    first_key_sym*: KeyCode
    num_key_syms*: int8
    first_key_act*: KeyCode
    num_key_acts*: int8
    first_key_behavior*: KeyCode
    num_key_behaviors*: int8
    first_key_explicit*: KeyCode
    num_key_explicit*: int8
    first_modmap_key*: KeyCode
    num_modmap_keys*: int8
    first_vmodmap_key*: KeyCode
    num_vmodmap_keys*: int8
    pad*: int8
    vmods*: int16

  PXkbMapChangesPtr* = ptr XkbMapChangesRec
