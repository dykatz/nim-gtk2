# Included by headers/gtk2.nim; do not import directly.
type
  TNotebookClass* = object of TContainerClass
    switch_page*: proc (notebook: PNotebook, page: PNotebookPage,
                        page_num: guint){.cdecl.}
    select_page*: proc (notebook: PNotebook, move_focus: gboolean): gboolean{.
        cdecl.}
    focus_tab*: proc (notebook: PNotebook, thetype: TNotebookTab): gboolean{.
        cdecl.}
    change_current_page*: proc (notebook: PNotebook, offset: gint){.cdecl.}
    move_focus_out*: proc (notebook: PNotebook, direction: TDirectionType){.
        cdecl.}
    reserved531: proc (){.cdecl.}
    reserved532: proc (){.cdecl.}
    reserved533: proc (){.cdecl.}
    reserved534: proc (){.cdecl.}

  PNotebookClass* = ptr TNotebookClass
