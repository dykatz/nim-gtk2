# Included by headers/gtk2.nim; do not import directly.
type
  TTextLineDisplay*{.final, pure.} = object
    layout*: pango.PLayout
    cursors*: PGSList
    shaped_objects*: PGSList
    direction*: TTextDirection
    width*: gint
    total_width*: gint
    height*: gint
    x_offset*: gint
    left_margin*: gint
    right_margin*: gint
    top_margin*: gint
    bottom_margin*: gint
    insert_index*: gint
    size_only*: gboolean
    line*: PTextLine

  PTextLineDisplay* = ptr TTextLineDisplay
  TTextLayout* = object of TGObject
    screen_width*: gint
    width*: gint
    height*: gint
    buffer*: PTextBuffer
    default_style*: PTextAttributes
    ltr_context*: pango.PContext
    rtl_context*: pango.PContext
    one_style_cache*: PTextAttributes
    one_display_cache*: PTextLineDisplay
    wrap_loop_count*: gint
    TextLayout_flag0*: guint16
    preedit_string*: cstring
    preedit_attrs*: pango.PAttrList
    preedit_len*: gint
    preedit_cursor*: gint

  PTextLayout* = ptr TTextLayout
  TTextLayoutClass* = object of TGObjectClass
    invalidated*: proc (layout: PTextLayout){.cdecl.}
    changed*: proc (layout: PTextLayout, y: gint, old_height: gint,
                    new_height: gint){.cdecl.}
    wrap*: proc (layout: PTextLayout, line: PTextLine, line_data: PTextLineData): PTextLineData{.
        cdecl.}
    get_log_attrs*: proc (layout: PTextLayout, line: PTextLine,
                          attrs: var pango.PLogAttr, n_attrs: Pgint){.cdecl.}
    invalidate*: proc (layout: PTextLayout, start: PTextIter, theEnd: PTextIter){.
        cdecl.}
    free_line_data*: proc (layout: PTextLayout, line: PTextLine,
                           line_data: PTextLineData){.cdecl.}
    allocate_child*: proc (layout: PTextLayout, child: PWidget, x: gint, y: gint){.
        cdecl.}
    reserved1: proc (){.cdecl.}
    reserved2: proc (){.cdecl.}
    reserved3: proc (){.cdecl.}
    reserved4: proc (){.cdecl.}

  PTextLayoutClass* = ptr TTextLayoutClass
