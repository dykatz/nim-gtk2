# Included by headers/gtk2.nim; do not import directly.
type
  TEntryClass* = object of TWidgetClass
    populate_popup*: proc (entry: PEntry, menu: PMenu){.cdecl.}
    activate*: proc (entry: PEntry){.cdecl.}
    move_cursor*: proc (entry: PEntry, step: TMovementStep, count: gint,
                        extend_selection: gboolean){.cdecl.}
    insert_at_cursor*: proc (entry: PEntry, str: cstring){.cdecl.}
    delete_from_cursor*: proc (entry: PEntry, thetype: TDeleteType, count: gint){.
        cdecl.}
    backspace*: proc (entry: PEntry){.cdecl.}
    cut_clipboard*: proc (entry: PEntry){.cdecl.}
    copy_clipboard*: proc (entry: PEntry){.cdecl.}
    paste_clipboard*: proc (entry: PEntry){.cdecl.}
    toggle_overwrite*: proc (entry: PEntry){.cdecl.}
    get_text_area_size*: proc (entry: PEntry, x, y, width, height: Pgint){.cdecl.}
    reserved293: proc (){.cdecl.}
    reserved294: proc (){.cdecl.}

  PEntryClass* = ptr TEntryClass
