# Included by headers/gtk2.nim; do not import directly.
type
  PEditable* = pointer
  TEditableClass* = object of TGTypeInterface
    insert_text*: proc (editable: PEditable, text: cstring, length: gint,
                        position: Pgint){.cdecl.}
    delete_text*: proc (editable: PEditable, start_pos: gint, end_pos: gint){.
        cdecl.}
    changed*: proc (editable: PEditable){.cdecl.}
    do_insert_text*: proc (editable: PEditable, text: cstring, length: gint,
                           position: Pgint){.cdecl.}
    do_delete_text*: proc (editable: PEditable, start_pos: gint, end_pos: gint){.
        cdecl.}
    get_chars*: proc (editable: PEditable, start_pos: gint, end_pos: gint): cstring{.
        cdecl.}
    set_selection_bounds*: proc (editable: PEditable, start_pos: gint,
                                 end_pos: gint){.cdecl.}
    get_selection_bounds*: proc (editable: PEditable, start_pos: Pgint,
                                 end_pos: Pgint): gboolean{.cdecl.}
    set_position*: proc (editable: PEditable, position: gint){.cdecl.}
    get_position*: proc (editable: PEditable): gint{.cdecl.}

  PEditableClass* = ptr TEditableClass
