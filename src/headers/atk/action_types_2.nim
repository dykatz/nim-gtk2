# Included by headers/atk.nim; do not import directly.
type
  TActionIface* = object of TGTypeInterface
    do_action*: proc (action: PAction, i: gint): gboolean{.cdecl.}
    get_n_actions*: proc (action: PAction): gint{.cdecl.}
    get_description*: proc (action: PAction, i: gint): cstring{.cdecl.}
    get_name*: proc (action: PAction, i: gint): cstring{.cdecl.}
    get_keybinding*: proc (action: PAction, i: gint): cstring{.cdecl.}
    set_description*: proc (action: PAction, i: gint, desc: cstring): gboolean{.
        cdecl.}
    pad1*: TFunction
    pad2*: TFunction

  PActionIface* = ptr TActionIface
