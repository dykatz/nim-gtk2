# Included by headers/atk.nim; do not import directly.
type
  THyperlinkClass* = object of TGObjectClass
    get_uri*: proc (link: PHyperlink, i: gint): cstring{.cdecl.}
    get_object*: proc (link: PHyperlink, i: gint): PObject{.cdecl.}
    get_end_index*: proc (link: PHyperlink): gint{.cdecl.}
    get_start_index*: proc (link: PHyperlink): gint{.cdecl.}
    is_valid*: proc (link: PHyperlink): gboolean{.cdecl.}
    get_n_anchors*: proc (link: PHyperlink): gint{.cdecl.}
    pad7*: TFunction
    pad8*: TFunction
    pad9*: TFunction
    pad10*: TFunction

  PHyperlinkClass* = ptr THyperlinkClass
