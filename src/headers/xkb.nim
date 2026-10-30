#
# $Xorg: XKB.h,v 1.3 2000/08/18 04:05:45 coskrey Exp $
#************************************************************
# $Xorg: XKBstr.h,v 1.3 2000/08/18 04:05:45 coskrey Exp $
#************************************************************
# $Xorg: XKBgeom.h,v 1.3 2000/08/18 04:05:45 coskrey Exp $
#************************************************************
#
#Copyright (c) 1993 by Silicon Graphics Computer Systems, Inc.
#
#Permission to use, copy, modify, and distribute this
#software and its documentation for any purpose and without
#fee is hereby granted, provided that the above copyright
#notice appear in all copies and that both that copyright
#notice and this permission notice appear in supporting
#documentation, and that the name of Silicon Graphics not be
#used in advertising or publicity pertaining to distribution
#of the software without specific prior written permission.
#Silicon Graphics makes no representation about the suitability
#of this software for any purpose. It is provided "as is"
#without any express or implied warranty.
#
#SILICON GRAPHICS DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
#SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
#AND FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL SILICON
#GRAPHICS BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL
#DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
#DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
#OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION  WITH
#THE USE OR PERFORMANCE OF THIS SOFTWARE.
#
#********************************************************
# $XFree86: xc/include/extensions/XKB.h,v 1.5 2002/11/20 04:49:01 dawes Exp $
# $XFree86: xc/include/extensions/XKBgeom.h,v 3.9 2002/09/18 17:11:40 tsi Exp $
#
# Pascal Convertion was made by Ido Kannner - kanerido@actcom.net.il
#
#Thanks:
#         I want to thanks to oliebol for putting up with all of the problems that was found
#         while translating this code. ;)
#
#         I want to thanks #fpc channel in freenode irc, for helping me, and to put up with my
#         wierd questions ;)
#
#         Thanks for mmc in #xlib on freenode irc And so for the channel itself for the helping me to
#         understanding some of the problems I had converting this headers and pointing me to resources
#         that helped translating this headers.
#
# Ido
#
#History:
#        2004/10/15           - Fixed a bug of accessing second based records by removing "paced record" and
#                               chnaged it to "reocrd" only.
#        2004/10/04 - 06      - Convertion from the c header of XKBgeom.h.
#        2004/10/03           - Removed the XKBstr_UNIT compiler decleration. Afther the joined files,
#                                                                                     There is no need for it anymore.
#                                                                             - There is a need to define (for now) XKBgeom (compiler define) in order
#                                                                               to use the code of it. At this moment, I did not yet converted it to Pascal.
#
#        2004/09/17 - 10/04   - Convertion from the c header of XKBstr.
#
#        2004/10/03           - Joined xkbstr.pas into xkb.pas because of the circular calls problems.
#                             - Added the history of xkbstr.pas above this addition.
#
#        2004/09/17           - Fixed a wrong convertion number of XkbPerKeyBitArraySize, insted
#                               of float, it's now converted into integer (as it should have been).
#
#        2004/09/15 - 16      - Convertion from the c header of XKB.h.
#

import
  x, xlib

include "x11pragma.nim"

include "xkb/core"
include "xkb/shared_types"
include "xkb/XKBstr_types"
include "xkb/shared_types_2"
{.deprecated: [TXkbStateRec: XkbStateRec].}


include "xkb/core_2"
include "xkb/shared_types_3"
{.deprecated: [TXkbModsRec: XkbModsRec].}


include "xkb/shared_types_4"
{.deprecated: [TXkbKTMapEntryRec: XkbKTMapEntryRec].}


include "xkb/shared_types_5"
{.deprecated: [TXkbKeyTypeRec: XkbKeyTypeRec].}


include "xkb/core_3"
include "xkb/XKBstr_types_2"
{.deprecated: [TXkbBehavior: XkbBehavior].}


include "xkb/XKBstr_types_3"
{.deprecated: [TXkbModAction: XkbModAction].}


include "xkb/XKBstr"
include "xkb/XKBstr_types_4"
{.deprecated: [TXkbGroupAction: XkbGroupAction].}


include "xkb/XKBstr_2"
include "xkb/XKBstr_types_5"
{.deprecated: [TXkbISOAction: XkbISOAction].}


include "xkb/XKBstr_types_6"
{.deprecated: [TXkbPtrAction: XkbPtrAction].}


include "xkb/XKBstr_3"
include "xkb/XKBstr_types_7"
{.deprecated: [TXkbPtrBtnAction: XkbPtrBtnAction].}


include "xkb/XKBstr_types_8"
{.deprecated: [TXkbPtrDfltAction: XkbPtrDfltAction].}


include "xkb/XKBstr_4"
include "xkb/XKBstr_types_9"
{.deprecated: [TXkbSwitchScreenAction: XkbSwitchScreenAction].}


include "xkb/XKBstr_5"
include "xkb/XKBstr_types_10"
{.deprecated: [TXkbCtrlsAction: XkbCtrlsAction].}


include "xkb/XKBstr_6"
include "xkb/XKBstr_types_11"
{.deprecated: [TXkbMessageAction: XkbMessageAction].}


include "xkb/XKBstr_types_12"
{.deprecated: [TXkbRedirectKeyAction: XkbRedirectKeyAction].}


include "xkb/XKBstr_7"
include "xkb/XKBstr_types_13"
{.deprecated: [TXkbDeviceBtnAction: XkbDeviceBtnAction].}


include "xkb/XKBstr_types_14"
{.deprecated: [TXkbDeviceValuatorAction: XkbDeviceValuatorAction].}


include "xkb/XKBstr_8"
include "xkb/XKBstr_types_15"
{.deprecated: [TXkbAnyAction: XkbAnyAction].}


include "xkb/XKBstr_9"
include "xkb/XKBstr_types_16"
{.deprecated: [TXkbAction: XkbAction].}


include "xkb/XKB"
include "xkb/XKBstr_10"
include "xkb/XKB_2"
include "xkb/XKBstr_11"
include "xkb/XKB_3"
include "xkb/XKBstr_12"
include "xkb/XKB_4"
const  ##define        XkbSA_BreakLatch \
       #        ((1<<XkbSA_NoAction)|(1<<XkbSA_PtrBtn)|(1<<XkbSA_LockPtrBtn)|\
       #        (1<<XkbSA_Terminate)|(1<<XkbSA_SwitchScreen)|(1<<XkbSA_SetControls)|\
       #        (1<<XkbSA_LockControls)|(1<<XkbSA_ActionMessage)|\
       #        (1<<XkbSA_RedirectKey)|(1<<XkbSA_DeviceBtn)|(1<<XkbSA_LockDeviceBtn))
       #
  XkbSA_BreakLatch* = (1 shl XkbSA_PtrBtn) or (1 shl XkbSA_LockPtrBtn) or
      (1 shl XkbSA_Terminate) or (1 shl XkbSA_SwitchScreen) or
      (1 shl XkbSA_SetControls) or (1 shl XkbSA_LockControls) or
      (1 shl XkbSA_ActionMessage) or (1 shl XkbSA_RedirectKey) or
      (1 shl XkbSA_DeviceBtn) or (1 shl XkbSA_LockDeviceBtn) #
                                                             #      Key Behavior Qualifier:
                                                             #         KB_Permanent indicates that the behavior describes an unalterable
                                                             #         characteristic of the keyboard, not an XKB software-simulation of
                                                             #         the listed behavior.
                                                             #      Key Behavior Types:
                                                             #         Specifies the behavior of the underlying key.
                                                             #

include "xkb/XKB_5"
include "xkb/XKBstr_13"
include "xkb/shared_types_6"
{.deprecated: [TXkbControlsRec: XkbControlsRec].}


include "xkb/XKBstr_14"
include "xkb/XKB_6"
include "xkb/XKBstr_types_17"
include "xkb/shared_types_7"
{.deprecated: [TXkbServerMapRec: XkbServerMapRec].}


include "xkb/XKBstr_15"
include "xkb/XKBstr_types_18"
include "xkb/shared_types_8"
{.deprecated: [TXkbSymMapRec: XkbSymMapRec].}


include "xkb/XKBstr_types_19"
include "xkb/shared_types_9"
{.deprecated: [TXkbClientMapRec: XkbClientMapRec].}


include "xkb/XKBstr_16"
include "xkb/XKBstr_types_20"
include "xkb/shared_types_10"
{.deprecated: [TXkbSymInterpretRec: XkbSymInterpretRec].}


include "xkb/XKBstr_types_21"
include "xkb/shared_types_11"
{.deprecated: [TXkbCompatMapRec: XkbCompatMapRec].}


include "xkb/XKBstr_types_22"
include "xkb/shared_types_12"
{.deprecated: [TXkbIndicatorMapRec: XkbIndicatorMapRec].}


include "xkb/XKBstr_17"
include "xkb/XKBstr_types_23"
include "xkb/shared_types_13"
{.deprecated: [TXkbIndicatorRec: XkbIndicatorRec].}


include "xkb/XKBstr_types_24"
include "xkb/shared_types_14"
{.deprecated: [TXkbKeyNameRec: XkbKeyNameRec].}


include "xkb/XKBstr_types_25"
include "xkb/shared_types_15"
{.deprecated: [TXkbKeyAliasRec: XkbKeyAliasRec].}


include "xkb/XKBstr_types_26"
include "xkb/shared_types_16"
{.deprecated: [TXkbNamesRec: XkbNamesRec].}


include "xkb/XKB_7"
include "xkb/XKBstr_18"
include "xkb/XKB_8"
include "xkb/shared_types_17"
{.deprecated: [TXkbPropertyRec: XkbPropertyRec].}


include "xkb/shared_types_18"
{.deprecated: [TXkbColorRec: XkbColorRec].}


include "xkb/shared_types_19"
{.deprecated: [TXkbPointRec: XkbPointRec].}


include "xkb/shared_types_20"
{.deprecated: [TXkbBoundsRec: XkbBoundsRec].}


include "xkb/XKBstr_19"
include "xkb/shared_types_21"
{.deprecated: [TXkbOutlineRec: XkbOutlineRec].}


include "xkb/shared_types_22"
{.deprecated: [TXkbShapeRec: XkbShapeRec].}


include "xkb/XKBstr_20"
include "xkb/shared_types_23"
{.deprecated: [TXkbShapeDoodadRec: XkbShapeDoodadRec].}


include "xkb/shared_types_24"
{.deprecated: [TXkbTextDoodadRec: XkbTextDoodadRec].}


include "xkb/shared_types_25"
{.deprecated: [TXkbIndicatorDoodadRec: XkbIndicatorDoodadRec].}


include "xkb/shared_types_26"
{.deprecated: [TXkbLogoDoodadRec: XkbLogoDoodadRec].}


include "xkb/shared_types_27"
{.deprecated: [TXkbAnyDoodadRec: XkbAnyDoodadRec].}


include "xkb/shared_types_28"
{.deprecated: [TXkbDoodadRec: XkbDoodadRec].}


include "xkb/XKBgeom"
include "xkb/shared_types_29"
{.deprecated: [TXkbKeyRec: XkbKeyRec].}


include "xkb/shared_types_30"
{.deprecated: [TXkbRowRec: XkbRowRec].}


include "xkb/shared_types_31"
{.deprecated: [TXkbSectionRec: XkbSectionRec].}
{.deprecated: [TXkbOverlayKeyRec: XkbOverlayKeyRec].}
{.deprecated: [TXkbOverlayRowRec: XkbOverlayRowRec].}
{.deprecated: [TXkbOverlayRec: XkbOverlayRec].}

include "xkb/shared_types_32"
{.deprecated: [TXkbGeometryRec: XkbGeometryRec].}


include "xkb/XKBgeom_2"
include "xkb/shared_types_33"
{.deprecated: [TXkbGeometrySizesRec: XkbGeometrySizesRec].}


include "xkb/shared_types_34"
{.deprecated: [TXkbDescRec: XkbDescRec].}


include "xkb/XKBstr_21"
include "xkb/shared_types_35"
{.deprecated: [TXkbMapChangesRec: XkbMapChangesRec].}


include "xkb/shared_types_36"
{.deprecated: [TXkbControlsChangesRec: XkbControlsChangesRec].}


include "xkb/shared_types_37"
{.deprecated: [TXkbIndicatorChangesRec: XkbIndicatorChangesRec].}


include "xkb/shared_types_38"
{.deprecated: [TXkbNameChangesRec: XkbNameChangesRec].}


include "xkb/shared_types_39"
{.deprecated: [TXkbCompatChangesRec: XkbCompatChangesRec].}


include "xkb/shared_types_40"
{.deprecated: [TXkbChangesRec: XkbChangesRec].}


include "xkb/shared_types_41"
{.deprecated: [TXkbComponentNamesRec: XkbComponentNamesRec].}


include "xkb/shared_types_42"
{.deprecated: [TXkbComponentNameRec: XkbComponentNameRec].}


include "xkb/shared_types_43"
{.deprecated: [TXkbComponentListRec: XkbComponentListRec].}


include "xkb/shared_types_44"
{.deprecated: [TXkbDeviceLedInfoRec: XkbDeviceLedInfoRec].}


include "xkb/shared_types_45"
{.deprecated: [TXkbDeviceInfoRec: XkbDeviceInfoRec].}


include "xkb/XKBstr_22"
include "xkb/shared_types_46"
{.deprecated: [TXkbDeviceChangesRec: XkbDeviceChangesRec].}


include "xkb/XKBstr_23"
when defined(XKB_IN_SERVER):
  proc SrvXkbAddGeomKeyAlias*(geom: PXkbGeometryPtr, alias: cstring,
                              float: cstring): PXkbKeyAliasPtr{.libx11c, importc: "XkbAddGeomKeyAlias".}
  proc SrvXkbAddGeomColor*(geom: PXkbGeometryPtr, spec: cstring, pixel: int16): PXkbColorPtr{.
      libx11c, importc: "XkbAddGeomColor".}
  proc SrvXkbAddGeomDoodad*(geom: PXkbGeometryPtr, section: PXkbSectionPtr,
                            name: Atom): PXkbDoodadPtr{.libx11c,
      importc: "XkbAddGeomDoodad".}
  proc SrvXkbAddGeomKey*(geom: PXkbGeometryPtr, alias: cstring, float: cstring): PXkbKeyAliasPtr{.
      libx11c, importc: "XkbAddGeomKeyAlias".}
  proc SrvXkbAddGeomOutline*(shape: PXkbShapePtr, sz_points: int16): PXkbOutlinePtr{.
      libx11c, importc: "XkbAddGeomOutline".}
  proc SrvXkbAddGeomOverlay*(overlay: PXkbOverlayPtr, row: PXkbOverlayRowPtr,
                             over: cstring, under: cstring): PXkbOverlayKeyPtr{.
      libx11c, importc: "XkbAddGeomOverlayKey".}
  proc SrvXkbAddGeomOverlayRow*(overlay: PXkbOverlayPtr, row_under: int16,
                                sz_keys: int16): PXkbOverlayRowPtr{.libx11c, importc: "XkbAddGeomOverlayRow".}
  proc SrvXkbAddGeomOverlayKey*(overlay: PXkbOverlayPtr, row: PXkbOverlayRowPtr,
                                over: cstring, under: cstring): PXkbOverlayKeyPtr{.
      libx11c, importc: "XkbAddGeomOverlayKey".}
  proc SrvXkbAddGeomProperty*(geom: PXkbGeometryPtr, name: cstring,
                              value: cstring): PXkbPropertyPtr{.libx11c, importc: "XkbAddGeomProperty".}
  proc SrvXkbAddGeomRow*(section: PXkbSectionPtr, sz_keys: int16): PXkbRowPtr{.
      libx11c, importc: "XkbAddGeomRow".}
  proc SrvXkbAddGeomSection*(geom: PXkbGeometryPtr, name: Atom, sz_rows: int16,
                             sz_doodads: int16, sz_overlays: int16): PXkbSectionPtr{.
      libx11c, importc: "XkbAddGeomSection".}
  proc SrvXkbAddGeomShape*(geom: PXkbGeometryPtr, name: Atom,
                           sz_outlines: int16): PXkbShapePtr{.libx11c, importc: "XkbAddGeomShape".}
  proc SrvXkbAllocGeomKeyAliases*(geom: PXkbGeometryPtr, nAliases: int16): Status{.
      libx11c, importc: "XkbAllocGeomKeyAliases".}
  proc SrvXkbAllocGeomColors*(geom: PXkbGeometryPtr, nColors: int16): Status{.
      libx11c, importc: "XkbAllocGeomColors".}
  proc SrvXkbAllocGeomDoodads*(geom: PXkbGeometryPtr, nDoodads: int16): Status{.
      libx11c, importc: "XkbAllocGeomDoodads".}
  proc SrvXkbAllocGeomKeys*(row: PXkbRowPtr, nKeys: int16): Status{.libx11c, importc: "XkbAllocGeomKeys".}
  proc SrvXkbAllocGeomOutlines*(shape: PXkbShapePtr, nOL: int16): Status{.
      libx11c, importc: "XkbAllocGeomOutlines".}
  proc SrvXkbAllocGeomPoints*(ol: PXkbOutlinePtr, nPts: int16): Status{.libx11c, importc: "XkbAllocGeomPoints".}
  proc SrvXkbAllocGeomProps*(geom: PXkbGeometryPtr, nProps: int16): Status{.
      libx11c, importc: "XkbAllocGeomProps".}
  proc SrvXkbAllocGeomRows*(section: PXkbSectionPtr, nRows: int16): Status{.
      libx11c, importc: "XkbAllocGeomRows".}
  proc SrvXkbAllocGeomSectionDoodads*(section: PXkbSectionPtr, nDoodads: int16): Status{.
      libx11c, importc: "XkbAllocGeomSectionDoodads".}
  proc SrvXkbAllocGeomSections*(geom: PXkbGeometryPtr, nSections: int16): Status{.
      libx11c, importc: "XkbAllocGeomSections".}
  proc SrvXkbAllocGeomOverlays*(section: PXkbSectionPtr, num_needed: int16): Status{.
      libx11c, importc: "XkbAllocGeomOverlays".}
  proc SrvXkbAllocGeomOverlayRows*(overlay: PXkbOverlayPtr, num_needed: int16): Status{.
      libx11c, importc: "XkbAllocGeomOverlayRows".}
  proc SrvXkbAllocGeomOverlayKeys*(row: PXkbOverlayRowPtr, num_needed: int16): Status{.
      libx11c, importc: "XkbAllocGeomOverlayKeys".}
  proc SrvXkbAllocGeomShapes*(geom: PXkbGeometryPtr, nShapes: int16): Status{.
      libx11c, importc: "XkbAllocGeomShapes".}
  proc SrvXkbAllocGeometry*(xkb: PXkbDescPtr, sizes: PXkbGeometrySizesPtr): Status{.
      libx11c, importc: "XkbAllocGeometry".}
  proc SrvXkbFreeGeomKeyAliases*(geom: PXkbGeometryPtr, first: int16,
                                 count: int16, freeAll: bool){.libx11c, importc: "XkbFreeGeomKeyAliases".}
  proc SrvXkbFreeGeomColors*(geom: PXkbGeometryPtr, first: int16, count: int16,
                             freeAll: bool){.libx11c,
      importc: "XkbFreeGeomColors".}
  proc SrvXkbFreeGeomDoodads*(doodads: PXkbDoodadPtr, nDoodads: int16,
                              freeAll: bool){.libx11c,
      importc: "XkbFreeGeomDoodads".}
  proc SrvXkbFreeGeomProperties*(geom: PXkbGeometryPtr, first: int16,
                                 count: int16, freeAll: bool){.libx11c, importc: "XkbFreeGeomProperties".}
  proc SrvXkbFreeGeomOverlayKeys*(row: PXkbOverlayRowPtr, first: int16,
                                  count: int16, freeAll: bool){.libx11c, importc: "XkbFreeGeomOverlayKeys".}
  proc SrvXkbFreeGeomOverlayRows*(overlay: PXkbOverlayPtr, first: int16,
                                  count: int16, freeAll: bool){.libx11c, importc: "XkbFreeGeomOverlayRows".}
  proc SrvXkbFreeGeomOverlays*(section: PXkbSectionPtr, first: int16,
                               count: int16, freeAll: bool){.libx11c, importc: "XkbFreeGeomOverlays".}
  proc SrvXkbFreeGeomKeys*(row: PXkbRowPtr, first: int16, count: int16,
                           freeAll: bool){.libx11c,
      importc: "XkbFreeGeomKeys".}
  proc SrvXkbFreeGeomRows*(section: PXkbSectionPtr, first: int16, count: int16,
                           freeAll: bool){.libx11c,
      importc: "XkbFreeGeomRows".}
  proc SrvXkbFreeGeomSections*(geom: PXkbGeometryPtr, first: int16,
                               count: int16, freeAll: bool){.libx11c, importc: "XkbFreeGeomSections".}
  proc SrvXkbFreeGeomPoints*(outline: PXkbOutlinePtr, first: int16,
                             count: int16, freeAll: bool){.libx11c, importc: "XkbFreeGeomPoints".}
  proc SrvXkbFreeGeomOutlines*(shape: PXkbShapePtr, first: int16, count: int16,
                               freeAll: bool){.libx11c,
      importc: "XkbFreeGeomOutlines".}
  proc SrvXkbFreeGeomShapes*(geom: PXkbGeometryPtr, first: int16, count: int16,
                             freeAll: bool){.libx11c,
      importc: "XkbFreeGeomShapes".}
  proc SrvXkbFreeGeometry*(geom: PXkbGeometryPtr, which: int16, freeMap: bool){.
      libx11c, importc: "XkbFreeGeometry".}
# implementation

import                        #************************************ xkb ************************************
  xi

include "xkb/XKBstr_24"
