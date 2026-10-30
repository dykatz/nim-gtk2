# Included by headers/atk.nim; do not import directly.
type
  TTextIface* = object of TGTypeInterface
    get_text*: proc (text: PText, start_offset: gint, end_offset: gint): cstring{.
        cdecl.}
    get_text_after_offset*: proc (text: PText, offset: gint,
                                  boundary_type: TTextBoundary,
                                  start_offset: Pgint, end_offset: Pgint): cstring{.
        cdecl.}
    get_text_at_offset*: proc (text: PText, offset: gint,
                               boundary_type: TTextBoundary,
                               start_offset: Pgint, end_offset: Pgint): cstring{.
        cdecl.}
    get_character_at_offset*: proc (text: PText, offset: gint): gunichar{.cdecl.}
    get_text_before_offset*: proc (text: PText, offset: gint,
                                   boundary_type: TTextBoundary,
                                   start_offset: Pgint, end_offset: Pgint): cstring{.
        cdecl.}
    get_caret_offset*: proc (text: PText): gint{.cdecl.}
    get_run_attributes*: proc (text: PText, offset: gint, start_offset: Pgint,
                               end_offset: Pgint): PAttributeSet{.cdecl.}
    get_default_attributes*: proc (text: PText): PAttributeSet{.cdecl.}
    get_character_extents*: proc (text: PText, offset: gint, x: Pgint, y: Pgint,
                                  width: Pgint, height: Pgint,
                                  coords: TCoordType){.cdecl.}
    get_character_count*: proc (text: PText): gint{.cdecl.}
    get_offset_at_point*: proc (text: PText, x: gint, y: gint,
                                coords: TCoordType): gint{.cdecl.}
    get_n_selections*: proc (text: PText): gint{.cdecl.}
    get_selection*: proc (text: PText, selection_num: gint, start_offset: Pgint,
                          end_offset: Pgint): cstring{.cdecl.}
    add_selection*: proc (text: PText, start_offset: gint, end_offset: gint): gboolean{.
        cdecl.}
    remove_selection*: proc (text: PText, selection_num: gint): gboolean{.cdecl.}
    set_selection*: proc (text: PText, selection_num: gint, start_offset: gint,
                          end_offset: gint): gboolean{.cdecl.}
    set_caret_offset*: proc (text: PText, offset: gint): gboolean{.cdecl.}
    text_changed*: proc (text: PText, position: gint, length: gint){.cdecl.}
    text_caret_moved*: proc (text: PText, location: gint){.cdecl.}
    text_selection_changed*: proc (text: PText){.cdecl.}
    pad29*: TFunction
    pad30*: TFunction
    pad31*: TFunction
    pad32*: TFunction

  PTextIface* = ptr TTextIface
