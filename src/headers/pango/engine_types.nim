# Included by headers/pango.nim; do not import directly.
type
  TEngineInfo*{.final, pure.} = object
    id*: cstring
    engine_type*: cstring
    render_type*: cstring
    ranges*: PEngineRange
    n_ranges*: gint

  PEngineInfo* = ptr TEngineInfo
  TEngine*{.final, pure.} = object
    id*: cstring
    `type`*: cstring
    length*: gint

  PEngine* = ptr TEngine
