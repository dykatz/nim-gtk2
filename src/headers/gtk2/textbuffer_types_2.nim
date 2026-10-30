# Included by headers/gtk2.nim; do not import directly.
type
  TTextBuffer* = object of TGObject
    tag_table*: PTextTagTable
    btree*: PTextBTree
    clipboard_contents_buffers*: PGSList
    selection_clipboards*: PGSList
    log_attr_cache*: PTextLogAttrCache
    user_action_count*: guint
    TextBuffer_flag0*: guint16

  PTextBuffer* = ptr TTextBuffer
  TTextBufferClass* = object of TGObjectClass
    insert_text*: proc (buffer: PTextBuffer, pos: PTextIter, text: cstring,
                        length: gint){.cdecl.}
    insert_pixbuf*: proc (buffer: PTextBuffer, pos: PTextIter,
                          pixbuf: gdk2pixbuf.PPixbuf){.cdecl.}
    insert_child_anchor*: proc (buffer: PTextBuffer, pos: PTextIter,
                                anchor: PTextChildAnchor){.cdecl.}
    delete_range*: proc (buffer: PTextBuffer, start: PTextIter,
                         theEnd: PTextIter){.cdecl.}
    changed*: proc (buffer: PTextBuffer){.cdecl.}
    modified_changed*: proc (buffer: PTextBuffer){.cdecl.}
    mark_set*: proc (buffer: PTextBuffer, location: PTextIter, mark: PTextMark){.
        cdecl.}
    mark_deleted*: proc (buffer: PTextBuffer, mark: PTextMark){.cdecl.}
    apply_tag*: proc (buffer: PTextBuffer, tag: PTextTag, start_char: PTextIter,
                      end_char: PTextIter){.cdecl.}
    remove_tag*: proc (buffer: PTextBuffer, tag: PTextTag,
                       start_char: PTextIter, end_char: PTextIter){.cdecl.}
    begin_user_action*: proc (buffer: PTextBuffer){.cdecl.}
    end_user_action*: proc (buffer: PTextBuffer){.cdecl.}
    reserved1: proc (){.cdecl.}
    reserved2: proc (){.cdecl.}
    reserved3: proc (){.cdecl.}
    reserved4: proc (){.cdecl.}
    reserved5: proc (){.cdecl.}
    reserved6: proc (){.cdecl.}

  PTextBufferClass* = ptr TTextBufferClass
