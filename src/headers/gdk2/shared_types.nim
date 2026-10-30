# Included by headers/gdk2.nim; do not import directly.
type
  TWChar* = guint32
  PWChar* = ptr TWChar
  TAtom* = gulong
  PAtom* = ptr TAtom
  TRegionBox* = TSegment
  PRegionBox* = ptr TRegionBox
  PPOINTBLOCK* = ptr TPOINTBLOCK
  TPOINTBLOCK*{.final, pure.} = object
    pts*: array[0..(NUMPTSTOBUFFER) - 1, TPoint]
    next*: PPOINTBLOCK

  TXEvent* = proc () {.cdecl.}
  PXEvent* = ptr TXEvent
  TNativeWindow* = pointer
  TmatDUMMY*{.final, pure.} = object
    b*: array[0..19, char]

  PmatDUMMY* = ptr TmatDUMMY
  TAttrStipple*{.final, pure.} = object
    attr*: TAttribute
    stipple*: PBitmap

  PAttrStipple* = ptr TAttrStipple
  TAttrEmbossed*{.final, pure.} = object
    attr*: TAttribute
    embossed*: gboolean

  PAttrEmbossed* = ptr TAttrEmbossed
  TSpanFunc* = proc (span: PSpan, data: gpointer){.cdecl.}
  TInputFunction* = proc (data: gpointer, source: gint,
                          condition: TInputCondition){.cdecl.}
  TDestroyNotify* = proc (data: gpointer){.cdecl.}
  window_invalidate_maybe_recurse_child_func* = proc (para1: PWindow,
      para2: gpointer): gboolean {.cdecl.}

