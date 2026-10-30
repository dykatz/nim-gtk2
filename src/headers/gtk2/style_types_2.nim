# Included by headers/gtk2.nim; do not import directly.
type
  TStyleClass* = object of TGObjectClass
    realize*: proc (style: PStyle){.cdecl.}
    unrealize*: proc (style: PStyle){.cdecl.}
    copy*: proc (style: PStyle, src: PStyle){.cdecl.}
    clone*: proc (style: PStyle): PStyle{.cdecl.}
    init_from_rc*: proc (style: PStyle, rc_style: PRcStyle){.cdecl.}
    set_background*: proc (style: PStyle, window: gdk2.PWindow,
                           state_type: TStateType){.cdecl.}
    render_icon*: proc (style: PStyle, source: PIconSource,
                        direction: TTextDirection, state: TStateType,
                        size: TIconSize, widget: PWidget, detail: cstring): gdk2pixbuf.PPixbuf{.
        cdecl.}
    draw_hline*: proc (style: PStyle, window: gdk2.PWindow,
                       state_type: TStateType, area: gdk2.PRectangle,
                       widget: PWidget, detail: cstring, x1: gint, x2: gint,
                       y: gint){.cdecl.}
    draw_vline*: proc (style: PStyle, window: gdk2.PWindow,
                       state_type: TStateType, area: gdk2.PRectangle,
                       widget: PWidget, detail: cstring, y1: gint, y2: gint,
                       x: gint){.cdecl.}
    draw_shadow*: proc (style: PStyle, window: gdk2.PWindow,
                        state_type: TStateType, shadow_type: TShadowType,
                        area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                        x: gint, y: gint, width: gint, height: gint){.cdecl.}
    draw_polygon*: proc (style: PStyle, window: gdk2.PWindow,
                         state_type: TStateType, shadow_type: TShadowType,
                         area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                         point: gdk2.PPoint, npoints: gint, fill: gboolean){.cdecl.}
    draw_arrow*: proc (style: PStyle, window: gdk2.PWindow,
                       state_type: TStateType, shadow_type: TShadowType,
                       area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                       arrow_type: TArrowType, fill: gboolean, x: gint, y: gint,
                       width: gint, height: gint){.cdecl.}
    draw_diamond*: proc (style: PStyle, window: gdk2.PWindow,
                         state_type: TStateType, shadow_type: TShadowType,
                         area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                         x: gint, y: gint, width: gint, height: gint){.cdecl.}
    draw_string*: proc (style: PStyle, window: gdk2.PWindow,
                        state_type: TStateType, area: gdk2.PRectangle,
                        widget: PWidget, detail: cstring, x: gint, y: gint,
                        `string`: cstring){.cdecl.}
    draw_box*: proc (style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                     shadow_type: TShadowType, area: gdk2.PRectangle,
                     widget: PWidget, detail: cstring, x: gint, y: gint,
                     width: gint, height: gint){.cdecl.}
    draw_flat_box*: proc (style: PStyle, window: gdk2.PWindow,
                          state_type: TStateType, shadow_type: TShadowType,
                          area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                          x: gint, y: gint, width: gint, height: gint){.cdecl.}
    draw_check*: proc (style: PStyle, window: gdk2.PWindow,
                       state_type: TStateType, shadow_type: TShadowType,
                       area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                       x: gint, y: gint, width: gint, height: gint){.cdecl.}
    draw_option*: proc (style: PStyle, window: gdk2.PWindow,
                        state_type: TStateType, shadow_type: TShadowType,
                        area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                        x: gint, y: gint, width: gint, height: gint){.cdecl.}
    draw_tab*: proc (style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                     shadow_type: TShadowType, area: gdk2.PRectangle,
                     widget: PWidget, detail: cstring, x: gint, y: gint,
                     width: gint, height: gint){.cdecl.}
    draw_shadow_gap*: proc (style: PStyle, window: gdk2.PWindow,
                            state_type: TStateType, shadow_type: TShadowType,
                            area: gdk2.PRectangle, widget: PWidget,
                            detail: cstring, x: gint, y: gint, width: gint,
                            height: gint, gap_side: TPositionType, gap_x: gint,
                            gap_width: gint){.cdecl.}
    draw_box_gap*: proc (style: PStyle, window: gdk2.PWindow,
                         state_type: TStateType, shadow_type: TShadowType,
                         area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                         x: gint, y: gint, width: gint, height: gint,
                         gap_side: TPositionType, gap_x: gint, gap_width: gint){.
        cdecl.}
    draw_extension*: proc (style: PStyle, window: gdk2.PWindow,
                           state_type: TStateType, shadow_type: TShadowType,
                           area: gdk2.PRectangle, widget: PWidget,
                           detail: cstring, x: gint, y: gint, width: gint,
                           height: gint, gap_side: TPositionType){.cdecl.}
    draw_focus*: proc (style: PStyle, window: gdk2.PWindow,
                       state_type: TStateType, area: gdk2.PRectangle,
                       widget: PWidget, detail: cstring, x: gint, y: gint,
                       width: gint, height: gint){.cdecl.}
    draw_slider*: proc (style: PStyle, window: gdk2.PWindow,
                        state_type: TStateType, shadow_type: TShadowType,
                        area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                        x: gint, y: gint, width: gint, height: gint,
                        orientation: TOrientation){.cdecl.}
    draw_handle*: proc (style: PStyle, window: gdk2.PWindow,
                        state_type: TStateType, shadow_type: TShadowType,
                        area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                        x: gint, y: gint, width: gint, height: gint,
                        orientation: TOrientation){.cdecl.}
    draw_expander*: proc (style: PStyle, window: gdk2.PWindow,
                          state_type: TStateType, area: gdk2.PRectangle,
                          widget: PWidget, detail: cstring, x: gint, y: gint,
                          expander_style: TExpanderStyle){.cdecl.}
    draw_layout*: proc (style: PStyle, window: gdk2.PWindow,
                        state_type: TStateType, use_text: gboolean,
                        area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                        x: gint, y: gint, layout: pango.PLayout){.cdecl.}
    draw_resize_grip*: proc (style: PStyle, window: gdk2.PWindow,
                             state_type: TStateType, area: gdk2.PRectangle,
                             widget: PWidget, detail: cstring,
                             edge: gdk2.TWindowEdge, x: gint, y: gint,
                             width: gint, height: gint){.cdecl.}
    reserved381: proc (){.cdecl.}
    reserved382: proc (){.cdecl.}
    reserved383: proc (){.cdecl.}
    reserved384: proc (){.cdecl.}
    reserved385: proc (){.cdecl.}
    reserved386: proc (){.cdecl.}
    reserved387: proc (){.cdecl.}
    reserved388: proc (){.cdecl.}
    reserved389: proc (){.cdecl.}
    reserved3810: proc (){.cdecl.}
    reserved3811: proc (){.cdecl.}
    reserved3812: proc (){.cdecl.}

  PStyleClass* = ptr TStyleClass
