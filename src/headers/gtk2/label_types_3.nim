# Included by headers/gtk2.nim; do not import directly.
type
  TLabelClass* = object of TMiscClass
    move_cursor*: proc (`label`: PLabel, step: TMovementStep, count: gint,
                        extend_selection: gboolean){.cdecl.}
    copy_clipboard*: proc (`label`: PLabel){.cdecl.}
    populate_popup*: proc (`label`: PLabel, menu: PMenu){.cdecl.}
    reserved50: proc (){.cdecl.}
    reserved51: proc (){.cdecl.}
    reserved52: proc (){.cdecl.}
    reserved53: proc (){.cdecl.}

  PLabelClass* = ptr TLabelClass
