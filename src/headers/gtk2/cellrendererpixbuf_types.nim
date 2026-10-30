# Included by headers/gtk2.nim; do not import directly.
type
  TCellRendererPixbuf* = object of TCellRenderer
    pixbuf*: gdk2pixbuf.PPixbuf
    pixbuf_expander_open*: gdk2pixbuf.PPixbuf
    pixbuf_expander_closed*: gdk2pixbuf.PPixbuf

  PCellRendererPixbuf* = ptr TCellRendererPixbuf
