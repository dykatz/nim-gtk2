# Included by headers/gtk2.nim; do not import directly.
type
  TIconSource = object
  PIconSource* = ptr TIconSource
  TStyle* = object of TGObject
    fg*: array[0..4, gdk2.TColor]
    bg*: array[0..4, gdk2.TColor]
    light*: array[0..4, gdk2.TColor]
    dark*: array[0..4, gdk2.TColor]
    mid*: array[0..4, gdk2.TColor]
    text*: array[0..4, gdk2.TColor]
    base*: array[0..4, gdk2.TColor]
    text_aa*: array[0..4, gdk2.TColor]
    black*: gdk2.TColor
    white*: gdk2.TColor
    font_desc*: pango.PFontDescription
    xthickness*: gint
    ythickness*: gint
    fg_gc*: array[0..4, gdk2.PGC]
    bg_gc*: array[0..4, gdk2.PGC]
    light_gc*: array[0..4, gdk2.PGC]
    dark_gc*: array[0..4, gdk2.PGC]
    mid_gc*: array[0..4, gdk2.PGC]
    text_gc*: array[0..4, gdk2.PGC]
    base_gc*: array[0..4, gdk2.PGC]
    text_aa_gc*: array[0..4, gdk2.PGC]
    black_gc*: gdk2.PGC
    white_gc*: gdk2.PGC
    bg_pixmap*: array[0..4, gdk2.PPixmap]
    attach_count*: guint
    depth*: gint
    colormap*: gdk2.PColormap
    private_font*: gdk2.PFont
    private_font_desc*: pango.PFontDescription
    rc_style*: PRcStyle
    styles*: PGSList
    property_cache*: PGArray
    icon_factories*: PGSList

  PStyle* = ptr TStyle
  TBorder*{.final, pure.} = object
    left*: gint
    right*: gint
    top*: gint
    bottom*: gint

  PBorder* = ptr TBorder
  PIconSet* = pointer
