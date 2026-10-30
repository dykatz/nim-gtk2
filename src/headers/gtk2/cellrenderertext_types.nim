# Included by headers/gtk2.nim; do not import directly.
type
  TCellRendererText* = object of TCellRenderer
    text*: cstring
    font*: pango.PFontDescription
    font_scale*: gdouble
    foreground*: pango.TColor
    background*: pango.TColor
    extra_attrs*: pango.PAttrList
    underline_style*: pango.TUnderline
    rise*: gint
    fixed_height_rows*: gint
    CellRendererText_flag0*: guint16

  PCellRendererText* = ptr TCellRendererText
