# Included by headers/gdk2.nim; do not import directly.
proc EXTENTS*(r: PRegionBox, idRect: PRegion)
proc MEMCHECK*(reg: PRegion, ARect, firstrect: var PRegionBox): bool
proc CHECK_PREVIOUS*(Reg: PRegion, R: PRegionBox,
                            Rx1, Ry1, Rx2, Ry2: gint): bool
proc ADDRECT*(reg: PRegion, r: PRegionBox, rx1, ry1, rx2, ry2: gint)
proc ADDRECTNOX*(reg: PRegion, r: PRegionBox, rx1, ry1, rx2, ry2: gint)
proc EMPTY_REGION*(pReg: PRegion): bool
proc REGION_NOT_EMPTY*(pReg: PRegion): bool
proc region_INBOX*(r: TRegionBox, x, y: gint): bool
