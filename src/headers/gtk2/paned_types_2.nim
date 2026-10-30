# Included by headers/gtk2.nim; do not import directly.
type
  TPanedClass* = object of TContainerClass
    cycle_child_focus*: proc (paned: PPaned, reverse: gboolean): gboolean{.cdecl.}
    toggle_handle_focus*: proc (paned: PPaned): gboolean{.cdecl.}
    move_handle*: proc (paned: PPaned, scroll: TScrollType): gboolean{.cdecl.}
    cycle_handle_focus*: proc (paned: PPaned, reverse: gboolean): gboolean{.
        cdecl.}
    accept_position*: proc (paned: PPaned): gboolean{.cdecl.}
    cancel_position*: proc (paned: PPaned): gboolean{.cdecl.}
    reserved351: proc (){.cdecl.}
    reserved352: proc (){.cdecl.}
    reserved353: proc (){.cdecl.}
    reserved354: proc (){.cdecl.}

  PPanedClass* = ptr TPanedClass
