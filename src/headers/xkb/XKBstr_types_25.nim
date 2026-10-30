# Included by headers/xkb.nim; do not import directly.
type
  XkbKeyAliasRec*{.final.} = object  #
                                      #          Names for everything
                                      #
    float*: array[0..XkbKeyNameLength - 1, char]
    alias*: array[0..XkbKeyNameLength - 1, char]

