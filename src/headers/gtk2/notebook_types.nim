# Included by headers/gtk2.nim; do not import directly.
type
  PNotebookPage* = pointer
  TNotebookTab* = enum
    NOTEBOOK_TAB_FIRST, NOTEBOOK_TAB_LAST
  PNotebookTab* = ptr TNotebookTab
  TNotebook* = object of TContainer
    cur_page*: PNotebookPage
    children*: PGList
    first_tab*: PGList
    focus_tab*: PGList
    menu*: PWidget
    event_window*: gdk2.PWindow
    timer*: guint32
    tab_hborder*: guint16
    tab_vborder*: guint16
    Notebook_flag0*: guint16

  PNotebook* = ptr TNotebook
