# Included by headers/atk.nim; do not import directly.
type
  TComponentIface* = object of TGTypeInterface
    add_focus_handler*: proc (component: PComponent, handler: TFocusHandler): guint{.
        cdecl.}
    contains*: proc (component: PComponent, x: gint, y: gint,
                     coord_type: TCoordType): gboolean{.cdecl.}
    ref_accessible_at_point*: proc (component: PComponent, x: gint, y: gint,
                                    coord_type: TCoordType): PObject{.cdecl.}
    get_extents*: proc (component: PComponent, x: Pgint, y: Pgint, width: Pgint,
                        height: Pgint, coord_type: TCoordType){.cdecl.}
    get_position*: proc (component: PComponent, x: Pgint, y: Pgint,
                         coord_type: TCoordType){.cdecl.}
    get_size*: proc (component: PComponent, width: Pgint, height: Pgint){.cdecl.}
    grab_focus*: proc (component: PComponent): gboolean{.cdecl.}
    remove_focus_handler*: proc (component: PComponent, handler_id: guint){.
        cdecl.}
    set_extents*: proc (component: PComponent, x: gint, y: gint, width: gint,
                        height: gint, coord_type: TCoordType): gboolean{.cdecl.}
    set_position*: proc (component: PComponent, x: gint, y: gint,
                         coord_type: TCoordType): gboolean{.cdecl.}
    set_size*: proc (component: PComponent, width: gint, height: gint): gboolean{.
        cdecl.}
    get_layer*: proc (component: PComponent): TLayer{.cdecl.}
    get_mdi_zorder*: proc (component: PComponent): gint{.cdecl.}
    pad1*: TFunction
    pad2*: TFunction

  PComponentIface* = ptr TComponentIface
