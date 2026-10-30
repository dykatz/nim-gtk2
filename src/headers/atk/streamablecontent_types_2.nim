# Included by headers/atk.nim; do not import directly.
type
  TStreamableContentIface* = object of TGTypeInterface
    get_n_mime_types*: proc (streamable: PStreamableContent): gint{.cdecl.}
    get_mime_type*: proc (streamable: PStreamableContent, i: gint): cstring{.
        cdecl.}
    get_stream*: proc (streamable: PStreamableContent, mime_type: cstring): PGIOChannel{.
        cdecl.}
    pad21*: TFunction
    pad22*: TFunction
    pad23*: TFunction
    pad24*: TFunction

  PStreamableContentIface* = ptr TStreamableContentIface
