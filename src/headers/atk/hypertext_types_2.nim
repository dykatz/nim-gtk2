# Included by headers/atk.nim; do not import directly.
type
  THypertextIface* = object of TGTypeInterface
    get_link*: proc (hypertext: PHypertext, link_index: gint): PHyperlink{.cdecl.}
    get_n_links*: proc (hypertext: PHypertext): gint{.cdecl.}
    get_link_index*: proc (hypertext: PHypertext, char_index: gint): gint{.cdecl.}
    pad11*: TFunction
    pad12*: TFunction
    pad13*: TFunction
    pad14*: TFunction

  PHypertextIface* = ptr THypertextIface
