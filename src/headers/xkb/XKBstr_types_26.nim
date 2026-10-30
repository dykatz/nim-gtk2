# Included by headers/xkb.nim; do not import directly.
type
  XkbNamesRec*{.final.} = object  #
                                   #      Key Type index and mask for the four standard key types.
                                   #
    keycodes*: Atom
    geometry*: Atom
    symbols*: Atom
    types*: Atom
    compat*: Atom
    vmods*: array[0..XkbNumVirtualMods - 1, Atom]
    indicators*: array[0..XkbNumIndicators - 1, Atom]
    groups*: array[0..XkbNumKbdGroups - 1, Atom]
    keys*: PXkbKeyNamePtr
    key_aliases*: PXkbKeyAliasPtr
    radio_groups*: PAtom
    phys_symbols*: Atom
    num_keys*: int8
    num_key_aliases*: int8
    num_rg*: int16

