# Included by headers/xkb.nim; do not import directly.
type
  XkbOverlayKeyRec*{.final.} = object  #Do not add more "type"
    over*: XkbKeyNameRec
    under*: XkbKeyNameRec

  PXkbOverlayKeyPtr* = ptr XkbOverlayKeyRec
  XkbOverlayRowRec*{.final.} = object  #Do not add more "type"
    row_under*: int16
    num_keys*: int16
    sz_keys*: int16
    keys*: PXkbOverlayKeyPtr

  PXkbOverlayRowPtr* = ptr XkbOverlayRowRec
  PXkbOverlayPtr* = ptr XkbOverlayRec #forward for XkbSectionRec use.
                                       #Do not add more "type"
  PXkbSectionPtr* = ptr XkbSectionRec
  XkbSectionRec*{.final.} = object  #Do not add more "type"
    name*: Atom
    priority*: int8
    top*: int16
    left*: int16
    width*: int16
    height*: int16
    angle*: int16
    num_rows*: int16
    num_doodads*: int16
    num_overlays*: int16
    rows*: PXkbRowPtr
    doodads*: PXkbDoodadPtr
    bounds*: XkbBoundsRec
    overlays*: PXkbOverlayPtr

  XkbOverlayRec*{.final.} = object
    name*: Atom
    section_under*: PXkbSectionPtr
    num_rows*: int16
    sz_rows*: int16
    rows*: PXkbOverlayRowPtr
    bounds*: PXkbBoundsPtr

