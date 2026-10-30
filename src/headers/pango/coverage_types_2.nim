# Included by headers/pango.nim; do not import directly.
type
  TCoverage*{.final, pure.} = object
    ref_count*: int
    n_blocks*: int32
    data_size*: int32
    blocks*: PBlockInfo

  PCoverage* = ptr TCoverage
