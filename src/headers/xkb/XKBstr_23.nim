# Included by headers/xkb.nim; do not import directly.
proc XkbShapeDoodadColor*(g: PXkbGeometryPtr, d: PXkbShapeDoodadPtr): PXkbColorPtr
proc XkbShapeDoodadShape*(g: PXkbGeometryPtr, d: PXkbShapeDoodadPtr): PXkbShapePtr
proc XkbSetShapeDoodadColor*(g: PXkbGeometryPtr, d: PXkbShapeDoodadPtr,
                             c: PXkbColorPtr)
proc XkbSetShapeDoodadShape*(g: PXkbGeometryPtr, d: PXkbShapeDoodadPtr,
                             s: PXkbShapePtr)
proc XkbTextDoodadColor*(g: PXkbGeometryPtr, d: PXkbTextDoodadPtr): PXkbColorPtr
proc XkbSetTextDoodadColor*(g: PXkbGeometryPtr, d: PXkbTextDoodadPtr,
                            c: PXkbColorPtr)
proc XkbIndicatorDoodadShape*(g: PXkbGeometryPtr, d: PXkbIndicatorDoodadPtr): PXkbShapeDoodadPtr
proc XkbIndicatorDoodadOnColor*(g: PXkbGeometryPtr, d: PXkbIndicatorDoodadPtr): PXkbColorPtr
proc XkbIndicatorDoodadOffColor*(g: PXkbGeometryPtr, d: PXkbIndicatorDoodadPtr): PXkbColorPtr
proc XkbSetIndicatorDoodadOnColor*(g: PXkbGeometryPtr,
                                   d: PXkbIndicatorDoodadPtr, c: PXkbColorPtr)
proc XkbSetIndicatorDoodadOffColor*(g: PXkbGeometryPtr,
                                    d: PXkbIndicatorDoodadPtr, c: PXkbColorPtr)
proc XkbSetIndicatorDoodadShape*(g: PXkbGeometryPtr, d: PXkbIndicatorDoodadPtr,
                                 s: PXkbShapeDoodadPtr)
proc XkbLogoDoodadColor*(g: PXkbGeometryPtr, d: PXkbLogoDoodadPtr): PXkbColorPtr
proc XkbLogoDoodadShape*(g: PXkbGeometryPtr, d: PXkbLogoDoodadPtr): PXkbShapeDoodadPtr
proc XkbSetLogoDoodadColor*(g: PXkbGeometryPtr, d: PXkbLogoDoodadPtr,
                            c: PXkbColorPtr)
proc XkbSetLogoDoodadShape*(g: PXkbGeometryPtr, d: PXkbLogoDoodadPtr,
                            s: PXkbShapeDoodadPtr)
proc XkbKeyShape*(g: PXkbGeometryPtr, k: PXkbKeyPtr): PXkbShapeDoodadPtr
proc XkbKeyColor*(g: PXkbGeometryPtr, k: PXkbKeyPtr): PXkbColorPtr
proc XkbSetKeyShape*(g: PXkbGeometryPtr, k: PXkbKeyPtr, s: PXkbShapeDoodadPtr)
proc XkbSetKeyColor*(g: PXkbGeometryPtr, k: PXkbKeyPtr, c: PXkbColorPtr)
proc XkbGeomColorIndex*(g: PXkbGeometryPtr, c: PXkbColorPtr): int32
proc XkbAddGeomProperty*(geom: PXkbGeometryPtr, name: cstring, value: cstring): PXkbPropertyPtr{.
    libx11c, importc: "XkbAddGeomProperty".}
proc XkbAddGeomKeyAlias*(geom: PXkbGeometryPtr, alias: cstring, float: cstring): PXkbKeyAliasPtr{.
    libx11c, importc: "XkbAddGeomKeyAlias".}
proc XkbAddGeomColor*(geom: PXkbGeometryPtr, spec: cstring, pixel: int16): PXkbColorPtr{.
    libx11c, importc: "XkbAddGeomColor".}
proc XkbAddGeomOutline*(shape: PXkbShapePtr, sz_points: int16): PXkbOutlinePtr{.
    libx11c, importc: "XkbAddGeomOutline".}
proc XkbAddGeomShape*(geom: PXkbGeometryPtr, name: Atom, sz_outlines: int16): PXkbShapePtr{.
    libx11c, importc: "XkbAddGeomShape".}
proc XkbAddGeomKey*(row: PXkbRowPtr): PXkbKeyPtr{.libx11c,
    importc: "XkbAddGeomKey".}
proc XkbAddGeomRow*(section: PXkbSectionPtr, sz_keys: int16): PXkbRowPtr{.libx11c, importc: "XkbAddGeomRow".}
proc XkbAddGeomSection*(geom: PXkbGeometryPtr, name: Atom, sz_rows: int16,
                        sz_doodads: int16, sz_overlays: int16): PXkbSectionPtr{.
    libx11c, importc: "XkbAddGeomSection".}
proc XkbAddGeomOverlay*(section: PXkbSectionPtr, name: Atom, sz_rows: int16): PXkbOverlayPtr{.
    libx11c, importc: "XkbAddGeomOverlay".}
proc XkbAddGeomOverlayRow*(overlay: PXkbOverlayPtr, row_under: int16,
                           sz_keys: int16): PXkbOverlayRowPtr{.libx11c, importc: "XkbAddGeomOverlayRow".}
proc XkbAddGeomOverlayKey*(overlay: PXkbOverlayPtr, row: PXkbOverlayRowPtr,
                           over: cstring, under: cstring): PXkbOverlayKeyPtr{.
    libx11c, importc: "XkbAddGeomOverlayKey".}
proc XkbAddGeomDoodad*(geom: PXkbGeometryPtr, section: PXkbSectionPtr,
                       name: Atom): PXkbDoodadPtr{.libx11c,
    importc: "XkbAddGeomDoodad".}
proc XkbFreeGeomKeyAliases*(geom: PXkbGeometryPtr, first: int16, count: int16,
                            freeAll: bool){.libx11c,
    importc: "XkbFreeGeomKeyAliases".}
proc XkbFreeGeomColors*(geom: PXkbGeometryPtr, first: int16, count: int16,
                        freeAll: bool){.libx11c,
                                        importc: "XkbFreeGeomColors".}
proc XkbFreeGeomDoodads*(doodads: PXkbDoodadPtr, nDoodads: int16, freeAll: bool){.
    libx11c, importc: "XkbFreeGeomDoodads".}
proc XkbFreeGeomProperties*(geom: PXkbGeometryPtr, first: int16, count: int16,
                            freeAll: bool){.libx11c,
    importc: "XkbFreeGeomProperties".}
proc XkbFreeGeomOverlayKeys*(row: PXkbOverlayRowPtr, first: int16, count: int16,
                             freeAll: bool){.libx11c,
    importc: "XkbFreeGeomOverlayKeys".}
proc XkbFreeGeomOverlayRows*(overlay: PXkbOverlayPtr, first: int16,
                             count: int16, freeAll: bool){.libx11c, importc: "XkbFreeGeomOverlayRows".}
proc XkbFreeGeomOverlays*(section: PXkbSectionPtr, first: int16, count: int16,
                          freeAll: bool){.libx11c,
    importc: "XkbFreeGeomOverlays".}
proc XkbFreeGeomKeys*(row: PXkbRowPtr, first: int16, count: int16, freeAll: bool){.
    libx11c, importc: "XkbFreeGeomKeys".}
proc XkbFreeGeomRows*(section: PXkbSectionPtr, first: int16, count: int16,
                      freeAll: bool){.libx11c,
                                      importc: "XkbFreeGeomRows".}
proc XkbFreeGeomSections*(geom: PXkbGeometryPtr, first: int16, count: int16,
                          freeAll: bool){.libx11c,
    importc: "XkbFreeGeomSections".}
proc XkbFreeGeomPoints*(outline: PXkbOutlinePtr, first: int16, count: int16,
                        freeAll: bool){.libx11c,
                                        importc: "XkbFreeGeomPoints".}
proc XkbFreeGeomOutlines*(shape: PXkbShapePtr, first: int16, count: int16,
                          freeAll: bool){.libx11c,
    importc: "XkbFreeGeomOutlines".}
proc XkbFreeGeomShapes*(geom: PXkbGeometryPtr, first: int16, count: int16,
                        freeAll: bool){.libx11c,
                                        importc: "XkbFreeGeomShapes".}
proc XkbFreeGeometry*(geom: PXkbGeometryPtr, which: int16, freeMap: bool){.
    libx11c, importc: "XkbFreeGeometry".}
proc XkbAllocGeomProps*(geom: PXkbGeometryPtr, nProps: int16): Status{.libx11c, importc: "XkbAllocGeomProps".}
proc XkbAllocGeomKeyAliases*(geom: PXkbGeometryPtr, nAliases: int16): Status{.
    libx11c, importc: "XkbAllocGeomKeyAliases".}
proc XkbAllocGeomColors*(geom: PXkbGeometryPtr, nColors: int16): Status{.libx11c, importc: "XkbAllocGeomColors".}
proc XkbAllocGeomShapes*(geom: PXkbGeometryPtr, nShapes: int16): Status{.libx11c, importc: "XkbAllocGeomShapes".}
proc XkbAllocGeomSections*(geom: PXkbGeometryPtr, nSections: int16): Status{.
    libx11c, importc: "XkbAllocGeomSections".}
proc XkbAllocGeomOverlays*(section: PXkbSectionPtr, num_needed: int16): Status{.
    libx11c, importc: "XkbAllocGeomOverlays".}
proc XkbAllocGeomOverlayRows*(overlay: PXkbOverlayPtr, num_needed: int16): Status{.
    libx11c, importc: "XkbAllocGeomOverlayRows".}
proc XkbAllocGeomOverlayKeys*(row: PXkbOverlayRowPtr, num_needed: int16): Status{.
    libx11c, importc: "XkbAllocGeomOverlayKeys".}
proc XkbAllocGeomDoodads*(geom: PXkbGeometryPtr, nDoodads: int16): Status{.
    libx11c, importc: "XkbAllocGeomDoodads".}
proc XkbAllocGeomSectionDoodads*(section: PXkbSectionPtr, nDoodads: int16): Status{.
    libx11c, importc: "XkbAllocGeomSectionDoodads".}
proc XkbAllocGeomOutlines*(shape: PXkbShapePtr, nOL: int16): Status{.libx11c, importc: "XkbAllocGeomOutlines".}
proc XkbAllocGeomRows*(section: PXkbSectionPtr, nRows: int16): Status{.libx11c, importc: "XkbAllocGeomRows".}
proc XkbAllocGeomPoints*(ol: PXkbOutlinePtr, nPts: int16): Status{.libx11c, importc: "XkbAllocGeomPoints".}
proc XkbAllocGeomKeys*(row: PXkbRowPtr, nKeys: int16): Status{.libx11c, importc: "XkbAllocGeomKeys".}
proc XkbAllocGeometry*(xkb: PXkbDescPtr, sizes: PXkbGeometrySizesPtr): Status{.
    libx11c, importc: "XkbAllocGeometry".}
proc XkbSetGeometryProc*(dpy: PDisplay, deviceSpec: int16, geom: PXkbGeometryPtr): Status{.
    libx11c, importc: "XkbSetGeometry".}
proc XkbComputeShapeTop*(shape: PXkbShapePtr, bounds: PXkbBoundsPtr): bool{.
    libx11c, importc: "XkbComputeShapeTop".}
proc XkbComputeShapeBounds*(shape: PXkbShapePtr): bool{.libx11c,
    importc: "XkbComputeShapeBounds".}
proc XkbComputeRowBounds*(geom: PXkbGeometryPtr, section: PXkbSectionPtr,
                          row: PXkbRowPtr): bool{.libx11c,
    importc: "XkbComputeRowBounds".}
proc XkbComputeSectionBounds*(geom: PXkbGeometryPtr, section: PXkbSectionPtr): bool{.
    libx11c, importc: "XkbComputeSectionBounds".}
proc XkbFindOverlayForKey*(geom: PXkbGeometryPtr, wanted: PXkbSectionPtr,
                           under: cstring): cstring{.libx11c,
    importc: "XkbFindOverlayForKey".}
proc XkbGetGeometryProc*(dpy: PDisplay, xkb: PXkbDescPtr): Status{.libx11c, importc: "XkbGetGeometry".}
proc XkbGetNamedGeometry*(dpy: PDisplay, xkb: PXkbDescPtr, name: Atom): Status{.
    libx11c, importc: "XkbGetNamedGeometry".}
