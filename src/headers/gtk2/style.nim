# Included by headers/gtk2.nim; do not import directly.
proc TYPE_STYLE*(): GType
proc STYLE*(anObject: pointer): PStyle
proc STYLE_CLASS*(klass: pointer): PStyleClass
proc IS_STYLE*(anObject: pointer): bool
proc IS_STYLE_CLASS*(klass: pointer): bool
proc STYLE_GET_CLASS*(obj: pointer): PStyleClass
proc TYPE_BORDER*(): GType
proc STYLE_ATTACHED*(style: pointer): bool
proc style_get_type*(): GType{.cdecl, dynlib: lib, importc: "gtk_style_get_type".}
proc style_new*(): PStyle{.cdecl, dynlib: lib, importc: "gtk_style_new".}
proc copy*(style: PStyle): PStyle{.cdecl, dynlib: lib,
    importc: "gtk_style_copy".}
proc attach*(style: PStyle, window: gdk2.PWindow): PStyle{.cdecl,
    dynlib: lib, importc: "gtk_style_attach".}
proc detach*(style: PStyle){.cdecl, dynlib: lib,
                                   importc: "gtk_style_detach".}
proc set_background*(style: PStyle, window: gdk2.PWindow,
                           state_type: TStateType){.cdecl, dynlib: lib,
    importc: "gtk_style_set_background".}
proc apply_default_background*(style: PStyle, window: gdk2.PWindow,
                                     set_bg: gboolean, state_type: TStateType,
                                     area: gdk2.PRectangle, x: gint, y: gint,
                                     width: gint, height: gint){.cdecl,
    dynlib: lib, importc: "gtk_style_apply_default_background".}
proc lookup_icon_set*(style: PStyle, stock_id: cstring): PIconSet{.cdecl,
    dynlib: lib, importc: "gtk_style_lookup_icon_set".}
proc render_icon*(style: PStyle, source: PIconSource,
                        direction: TTextDirection, state: TStateType,
                        size: TIconSize, widget: PWidget, detail: cstring): gdk2pixbuf.PPixbuf{.
    cdecl, dynlib: lib, importc: "gtk_style_render_icon".}
proc paint_hline*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                  area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                  x1: gint, x2: gint, y: gint){.cdecl, dynlib: lib,
    importc: "gtk_paint_hline".}
proc paint_vline*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                  area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                  y1: gint, y2: gint, x: gint){.cdecl, dynlib: lib,
    importc: "gtk_paint_vline".}
proc paint_shadow*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                   shadow_type: TShadowType, area: gdk2.PRectangle,
                   widget: PWidget, detail: cstring, x: gint, y: gint,
                   width: gint, height: gint){.cdecl, dynlib: lib,
    importc: "gtk_paint_shadow".}
proc paint_polygon*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                    shadow_type: TShadowType, area: gdk2.PRectangle,
                    widget: PWidget, detail: cstring, points: gdk2.PPoint,
                    npoints: gint, fill: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_paint_polygon".}
proc paint_arrow*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                  shadow_type: TShadowType, area: gdk2.PRectangle,
                  widget: PWidget, detail: cstring, arrow_type: TArrowType,
                  fill: gboolean, x: gint, y: gint, width: gint, height: gint){.
    cdecl, dynlib: lib, importc: "gtk_paint_arrow".}
proc paint_diamond*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                    shadow_type: TShadowType, area: gdk2.PRectangle,
                    widget: PWidget, detail: cstring, x: gint, y: gint,
                    width: gint, height: gint){.cdecl, dynlib: lib,
    importc: "gtk_paint_diamond".}
proc paint_box*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                shadow_type: TShadowType, area: gdk2.PRectangle, widget: PWidget,
                detail: cstring, x: gint, y: gint, width: gint, height: gint){.
    cdecl, dynlib: lib, importc: "gtk_paint_box".}
proc paint_flat_box*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                     shadow_type: TShadowType, area: gdk2.PRectangle,
                     widget: PWidget, detail: cstring, x: gint, y: gint,
                     width: gint, height: gint){.cdecl, dynlib: lib,
    importc: "gtk_paint_flat_box".}
proc paint_check*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                  shadow_type: TShadowType, area: gdk2.PRectangle,
                  widget: PWidget, detail: cstring, x: gint, y: gint,
                  width: gint, height: gint){.cdecl, dynlib: lib,
    importc: "gtk_paint_check".}
proc paint_option*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                   shadow_type: TShadowType, area: gdk2.PRectangle,
                   widget: PWidget, detail: cstring, x: gint, y: gint,
                   width: gint, height: gint){.cdecl, dynlib: lib,
    importc: "gtk_paint_option".}
proc paint_tab*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                shadow_type: TShadowType, area: gdk2.PRectangle, widget: PWidget,
                detail: cstring, x: gint, y: gint, width: gint, height: gint){.
    cdecl, dynlib: lib, importc: "gtk_paint_tab".}
proc paint_shadow_gap*(style: PStyle, window: gdk2.PWindow,
                       state_type: TStateType, shadow_type: TShadowType,
                       area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                       x: gint, y: gint, width: gint, height: gint,
                       gap_side: TPositionType, gap_x: gint, gap_width: gint){.
    cdecl, dynlib: lib, importc: "gtk_paint_shadow_gap".}
proc paint_box_gap*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                    shadow_type: TShadowType, area: gdk2.PRectangle,
                    widget: PWidget, detail: cstring, x: gint, y: gint,
                    width: gint, height: gint, gap_side: TPositionType,
                    gap_x: gint, gap_width: gint){.cdecl, dynlib: lib,
    importc: "gtk_paint_box_gap".}
proc paint_extension*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                      shadow_type: TShadowType, area: gdk2.PRectangle,
                      widget: PWidget, detail: cstring, x: gint, y: gint,
                      width: gint, height: gint, gap_side: TPositionType){.
    cdecl, dynlib: lib, importc: "gtk_paint_extension".}
proc paint_focus*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                  area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                  x: gint, y: gint, width: gint, height: gint){.cdecl,
    dynlib: lib, importc: "gtk_paint_focus".}
proc paint_slider*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                   shadow_type: TShadowType, area: gdk2.PRectangle,
                   widget: PWidget, detail: cstring, x: gint, y: gint,
                   width: gint, height: gint, orientation: TOrientation){.cdecl,
    dynlib: lib, importc: "gtk_paint_slider".}
proc paint_handle*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                   shadow_type: TShadowType, area: gdk2.PRectangle,
                   widget: PWidget, detail: cstring, x: gint, y: gint,
                   width: gint, height: gint, orientation: TOrientation){.cdecl,
    dynlib: lib, importc: "gtk_paint_handle".}
proc paint_expander*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                     area: gdk2.PRectangle, widget: PWidget, detail: cstring,
                     x: gint, y: gint, expander_style: TExpanderStyle){.cdecl,
    dynlib: lib, importc: "gtk_paint_expander".}
proc paint_layout*(style: PStyle, window: gdk2.PWindow, state_type: TStateType,
                   use_text: gboolean, area: gdk2.PRectangle, widget: PWidget,
                   detail: cstring, x: gint, y: gint, layout: pango.PLayout){.
    cdecl, dynlib: lib, importc: "gtk_paint_layout".}
proc paint_resize_grip*(style: PStyle, window: gdk2.PWindow,
                        state_type: TStateType, area: gdk2.PRectangle,
                        widget: PWidget, detail: cstring, edge: gdk2.TWindowEdge,
                        x: gint, y: gint, width: gint, height: gint){.cdecl,
    dynlib: lib, importc: "gtk_paint_resize_grip".}
proc border_get_type*(): GType{.cdecl, dynlib: lib,
                                importc: "gtk_border_get_type".}
proc copy*(border: PBorder): PBorder{.cdecl, dynlib: lib,
    importc: "gtk_border_copy".}
proc free*(border: PBorder){.cdecl, dynlib: lib,
                                    importc: "gtk_border_free".}
proc peek_property_value*(style: PStyle, widget_type: GType,
                                pspec: PGParamSpec, parser: TRcPropertyParser): PGValue{.
    cdecl, dynlib: lib, importc: "_gtk_style_peek_property_value".}
