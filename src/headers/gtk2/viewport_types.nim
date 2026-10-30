# Included by headers/gtk2.nim; do not import directly.
type
  TViewport* = object of TBin
    shadow_type*: TShadowType
    view_window*: gdk2.PWindow
    bin_window*: gdk2.PWindow
    hadjustment*: PAdjustment
    vadjustment*: PAdjustment

  PViewport* = ptr TViewport
  TViewportClass* = object of TBinClass
    set_scroll_adjustments*: proc (viewport: PViewport,
                                   hadjustment: PAdjustment,
                                   vadjustment: PAdjustment){.cdecl.}

  PViewportClass* = ptr TViewportClass
