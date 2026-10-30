# Included by headers/atk.nim; do not import directly.
type
  TEditableTextIface* = object of TGTypeInterface
    set_run_attributes*: proc (text: PEditableText, attrib_set: PAttributeSet,
                               start_offset: gint, end_offset: gint): gboolean{.
        cdecl.}
    set_text_contents*: proc (text: PEditableText, `string`: cstring){.cdecl.}
    insert_text*: proc (text: PEditableText, `string`: cstring, length: gint,
                        position: Pgint){.cdecl.}
    copy_text*: proc (text: PEditableText, start_pos: gint, end_pos: gint){.
        cdecl.}
    cut_text*: proc (text: PEditableText, start_pos: gint, end_pos: gint){.cdecl.}
    delete_text*: proc (text: PEditableText, start_pos: gint, end_pos: gint){.
        cdecl.}
    paste_text*: proc (text: PEditableText, position: gint){.cdecl.}
    pad1*: TFunction
    pad2*: TFunction

  PEditableTextIface* = ptr TEditableTextIface
