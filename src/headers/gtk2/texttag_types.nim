# Included by headers/gtk2.nim; do not import directly.
type
  TTextAppearance*{.final, pure.} = object
    bg_color*: gdk2.TColor
    fg_color*: gdk2.TColor
    bg_stipple*: gdk2.PBitmap
    fg_stipple*: gdk2.PBitmap
    rise*: gint
    padding1*: gpointer
    flag0*: guint16

  PTextAppearance* = ptr TTextAppearance
  TTextAttributes*{.final, pure.} = object
    refcount*: guint
    appearance*: TTextAppearance
    justification*: TJustification
    direction*: TTextDirection
    font*: pango.PFontDescription
    font_scale*: gdouble
    left_margin*: gint
    indent*: gint
    right_margin*: gint
    pixels_above_lines*: gint
    pixels_below_lines*: gint
    pixels_inside_wrap*: gint
    tabs*: pango.PTabArray
    wrap_mode*: TWrapMode
    language*: pango.PLanguage
    padding1*: gpointer
    flag0*: guint16

  PTextAttributes* = ptr TTextAttributes
