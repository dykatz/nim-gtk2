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
    cut_clipboard*: proc (entry: PEntry){.cdecl.}
    copy_clipboard*: proc (entry: PEntry){.cdecl.}
    paste_clipboard*: proc (entry: PEntry){.cdecl.}
    toggle_overwrite*: proc (entry: PEntry){.cdecl.}
    reserved291: proc (){.cdecl.}
    reserved292: proc (){.cdecl.}
    reserved293: proc (){.cdecl.}
    reserved294: proc (){.cdecl.}

  PEntryClass* = ptr TEntryClass
