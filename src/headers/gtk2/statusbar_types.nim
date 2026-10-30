# Included by headers/gtk2.nim; do not import directly.
type
  TStatusbar* = object of THBox
    frame*: PWidget
    `label`*: PWidget
    messages*: PGSList
    keys*: PGSList
    seq_context_id*: guint
    seq_message_id*: guint
    grip_window*: gdk2.PWindow
    Statusbar_flag0*: guint16

  PStatusbar* = ptr TStatusbar
  TStatusbarClass* = object of THBoxClass
    messages_mem_chunk*: PGMemChunk
    text_pushed*: proc (statusbar: PStatusbar, context_id: guint, text: cstring){.
        cdecl.}
    text_popped*: proc (statusbar: PStatusbar, context_id: guint, text: cstring){.
        cdecl.}
    reserved641: proc (){.cdecl.}
    reserved642: proc (){.cdecl.}
    reserved643: proc (){.cdecl.}
    reserved644: proc (){.cdecl.}

  PStatusbarClass* = ptr TStatusbarClass
