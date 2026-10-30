# Included by headers/gtk2.nim; do not import directly.
type
  PRcContext* = pointer
  TRcFlags* = int32
  PRcFlags* = ptr TRcFlags
  TRcStyle* = object of TGObject
    name*: cstring
    bg_pixmap_name*: array[0..4, cstring]
    font_desc*: pango.PFontDescription
    color_flags*: array[0..4, TRcFlags]
    fg*: array[0..4, gdk2.TColor]
    bg*: array[0..4, gdk2.TColor]
    text*: array[0..4, gdk2.TColor]
    base*: array[0..4, gdk2.TColor]
    xthickness*: gint
    ythickness*: gint
    rc_properties*: PGArray
    rc_style_lists*: PGSList
    icon_factories*: PGSList
    RcStyle_flag0*: guint16

  PRcStyle* = ptr TRcStyle
  TRcTokenType* = enum
    RC_TOKEN_INVALID, RC_TOKEN_INCLUDE, RC_TOKEN_NORMAL, RC_TOKEN_ACTIVE,
    RC_TOKEN_PRELIGHT, RC_TOKEN_SELECTED, RC_TOKEN_INSENSITIVE, RC_TOKEN_FG,
    RC_TOKEN_BG, RC_TOKEN_TEXT, RC_TOKEN_BASE, RC_TOKEN_XTHICKNESS,
    RC_TOKEN_YTHICKNESS, RC_TOKEN_FONT, RC_TOKEN_FONTSET, RC_TOKEN_FONT_NAME,
    RC_TOKEN_BG_PIXMAP, RC_TOKEN_PIXMAP_PATH, RC_TOKEN_STYLE, RC_TOKEN_BINDING,
    RC_TOKEN_BIND, RC_TOKEN_WIDGET, RC_TOKEN_WIDGET_CLASS, RC_TOKEN_CLASS,
    RC_TOKEN_LOWEST, RC_TOKEN_GTK, RC_TOKEN_APPLICATION, RC_TOKEN_THEME,
    RC_TOKEN_RC, RC_TOKEN_HIGHEST, RC_TOKEN_ENGINE, RC_TOKEN_MODULE_PATH,
    RC_TOKEN_IM_MODULE_PATH, RC_TOKEN_IM_MODULE_FILE, RC_TOKEN_STOCK,
    RC_TOKEN_LTR, RC_TOKEN_RTL, RC_TOKEN_LAST
  PRcTokenType* = ptr TRcTokenType
  TRcProperty*{.final, pure.} = object
    type_name*: TGQuark
    property_name*: TGQuark
    origin*: cstring
    value*: TGValue

  PRcProperty* = ptr TRcProperty
