# Included by headers/gdk2.nim; do not import directly.
proc EXTENTS*(r: PRegionBox, idRect: PRegion) =
  if ((r.x1) < idRect.extents.x1):
    idRect.extents.x1 = r.x1
  if (r.y1) < idRect.extents.y1:
    idRect.extents.y1 = r.y1
  if (r.x2) > idRect.extents.x2:
    idRect.extents.x2 = r.x2

proc MEMCHECK*(reg: PRegion, ARect, firstrect: var PRegionBox): bool =
  assert(false)               # to implement

proc CHECK_PREVIOUS*(Reg: PRegion, R: PRegionBox,
                            Rx1, Ry1, Rx2, Ry2: gint): bool =
  assert(false)               # to implement

proc ADDRECT*(reg: PRegion, r: PRegionBox, rx1, ry1, rx2, ry2: gint) =
  if (((rx1) < rx2) and ((ry1) < ry2) and
      CHECK_PREVIOUS(reg, r, rx1, ry1, rx2, ry2)):
    r.x1 = rx1
    r.y1 = ry1
    r.x2 = rx2
    r.y2 = ry2

proc ADDRECTNOX*(reg: PRegion, r: PRegionBox, rx1, ry1, rx2, ry2: gint) =
  if (((rx1) < rx2) and ((ry1) < ry2) and
      CHECK_PREVIOUS(reg, r, rx1, ry1, rx2, ry2)):
    r.x1 = rx1
    r.y1 = ry1
    r.x2 = rx2
    r.y2 = ry2
    inc(reg.numRects)

proc EMPTY_REGION*(pReg: PRegion): bool =
  result = pReg.numRects == 0'i32

proc REGION_NOT_EMPTY*(pReg: PRegion): bool =
  result = pReg.numRects != 0'i32

proc region_INBOX*(r: TRegionBox, x, y: gint): bool =
  result = ((((r.x2) > x) and ((r.x1) <= x)) and ((r.y2) > y)) and
      ((r.y1) <= y)

