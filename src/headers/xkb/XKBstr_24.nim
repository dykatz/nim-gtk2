# Included by headers/xkb.nim; do not import directly.
proc XkbLegalXILedClass(c: int): bool =
  ##define XkbLegalXILedClass(c) (((c)==KbdFeedbackClass)||((c)==LedFeedbackClass)||
  #                                ((c)==XkbDfltXIClass)||((c)==XkbAllXIClasses))
  result = (c == KbdFeedbackClass) or (c == LedFeedbackClass) or
      (c == XkbDfltXIClass) or (c == XkbAllXIClasses)

proc XkbLegalXIBellClass(c: int): bool =
  ##define XkbLegalXIBellClass(c) (((c)==KbdFeedbackClass)||((c)==BellFeedbackClass)||
  #                                 ((c)==XkbDfltXIClass)||((c)==XkbAllXIClasses))
  result = (c == KbdFeedbackClass) or (c == BellFeedbackClass) or
      (c == XkbDfltXIClass) or (c == XkbAllXIClasses)

proc XkbExplicitXIDevice(c: int): bool =
  ##define XkbExplicitXIDevice(c) (((c)&(~0xff))==0)
  result = (c and (not 0x000000FF)) == 0

proc XkbExplicitXIClass(c: int): bool =
  ##define XkbExplicitXIClass(c) (((c)&(~0xff))==0)
  result = (c and (not 0x000000FF)) == 0

proc XkbExplicitXIId(c: int): bool =
  ##define XkbExplicitXIId(c) (((c)&(~0xff))==0)
  result = (c and (not 0x000000FF)) == 0

proc XkbSingleXIClass(c: int): bool =
  ##define XkbSingleXIClass(c) ((((c)&(~0xff))==0)||((c)==XkbDfltXIClass))
  result = ((c and (not 0x000000FF)) == 0) or (c == XkbDfltXIClass)

proc XkbSingleXIId(c: int): bool =
  ##define XkbSingleXIId(c) ((((c)&(~0xff))==0)||((c)==XkbDfltXIId))
  result = ((c and (not 0x000000FF)) == 0) or (c == XkbDfltXIId)

proc XkbBuildCoreState(m, g: int): int =
  ##define XkbBuildCoreState(m,g) ((((g)&0x3)<<13)|((m)&0xff))
  result = ((g and 0x00000003) shl 13) or (m and 0x000000FF)

proc XkbGroupForCoreState(s: int): int =
  ##define XkbGroupForCoreState(s) (((s)>>13)&0x3)
  result = (s shr 13) and 0x00000003

proc XkbIsLegalGroup(g: int): bool =
  ##define XkbIsLegalGroup(g) (((g)>=0)&&((g)<XkbNumKbdGroups))
  result = (g >= 0) and (g < XkbNumKbdGroups)

proc XkbSA_ValOp(a: int): int =
  ##define XkbSA_ValOp(a) ((a)&XkbSA_ValOpMask)
  result = a and XkbSA_ValOpMask

proc XkbSA_ValScale(a: int): int =
  ##define XkbSA_ValScale(a) ((a)&XkbSA_ValScaleMask)
  result = a and XkbSA_ValScaleMask

proc XkbIsModAction(a: PXkbAnyAction): bool =
  ##define XkbIsModAction(a) (((a)->type>=Xkb_SASetMods)&&((a)->type<=XkbSA_LockMods))
  result = (a.theType) >= XkbSA_SetMods and (a.theType) <= XkbSA_LockMods

proc XkbIsGroupAction(a: PXkbAnyAction): bool =
  ##define XkbIsGroupAction(a) (((a)->type>=XkbSA_SetGroup)&&((a)->type<=XkbSA_LockGroup))
  result = (a.theType >= XkbSA_SetGroup) or (a.theType <= XkbSA_LockGroup)

proc XkbIsPtrAction(a: PXkbAnyAction): bool =
  ##define XkbIsPtrAction(a) (((a)->type>=XkbSA_MovePtr)&&((a)->type<=XkbSA_SetPtrDflt))
  result = (a.theType >= XkbSA_MovePtr) and
      (a.theType <= XkbSA_SetPtrDflt)

proc XkbIsLegalKeycode(k: int): bool =
  ##define        XkbIsLegalKeycode(k)    (((k)>=XkbMinLegalKeyCode)&&((k)<=XkbMaxLegalKeyCode))
  result = (k >= XkbMinLegalKeyCode) and (k <= XkbMaxLegalKeyCode)

proc XkbShiftLevel(n: int8): int8 =
  ##define XkbShiftLevel(n) ((n)-1)
  result = n - 1'i8

proc XkbShiftLevelMask(n: int8): int8 =
  ##define XkbShiftLevelMask(n) (1<<((n)-1))
  result = 1'i8 shl (n - 1'i8)

proc XkbcharToInt(v: int8): int16 =
  ##define XkbcharToInt(v) ((v)&0x80?(int)((v)|(~0xff)):(int)((v)&0x7f))
  if ((v and 0x80'i8) != 0'i8): result = v or (not 0xFF'i16)
  else: result = int16(v and 0x7F'i8)

proc XkbIntTo2chars(i: int16, h, L: var int8) =
  ##define XkbIntTo2chars(i,h,l) (((h)=((i>>8)&0xff)),((l)=((i)&0xff)))
  h = int8((i shr 8'i16) and 0x00FF'i16)
  L = int8(i and 0xFF'i16)

proc Xkb2charsToInt(h, L: int8): int16 =
  when defined(cpu64):
    ##define Xkb2charsToInt(h,l) ((h)&0x80?(int)(((h)<<8)|(l)|(~0xffff)): (int)(((h)<<8)|(l)&0x7fff))
    if (h and 0x80'i8) != 0'i8:
      result = int16((h shl 8) or L or not 0x0000FFFF)
    else:
      result = int16((h shl 8) or L and 0x00007FFF)
  else:
    ##define Xkb2charsToInt(h,l) ((short)(((h)<<8)|(l)))
    result = int16(h shl 8 or L)

proc XkbModLocks(s: PXkbStatePtr): int8 =
  ##define XkbModLocks(s) ((s)->locked_mods)
  result = s.locked_mods

proc XkbStateMods(s: PXkbStatePtr): int16 =
  ##define XkbStateMods(s) ((s)->base_mods|(s)->latched_mods|XkbModLocks(s))
  result = s.base_mods or s.latched_mods or XkbModLocks(s)

proc XkbGroupLock(s: PXkbStatePtr): int8 =
  ##define XkbGroupLock(s) ((s)->locked_group)
  result = s.locked_group

proc XkbStateGroup(s: PXkbStatePtr): int16 =
  ##define XkbStateGroup(s) ((s)->base_group+(s)->latched_group+XkbGroupLock(s))
  result = s.base_group + (s.latched_group) + XkbGroupLock(s)

proc XkbStateFieldFromRec(s: PXkbStatePtr): int =
  ##define XkbStateFieldFromRec(s) XkbBuildCoreState((s)->lookup_mods,(s)->group)
  result = XkbBuildCoreState(s.lookup_mods, s.group)

proc XkbGrabStateFromRec(s: PXkbStatePtr): int =
  ##define XkbGrabStateFromRec(s) XkbBuildCoreState((s)->grab_mods,(s)->group)
  result = XkbBuildCoreState(s.grab_mods, s.group)

proc XkbNumGroups(g: int16): int16 =
  ##define XkbNumGroups(g) ((g)&0x0f)
  result = g and 0x0000000F'i16

proc XkbOutOfRangeGroupInfo(g: int16): int16 =
  ##define XkbOutOfRangeGroupInfo(g) ((g)&0xf0)
  result = g and 0x000000F0'i16

proc XkbOutOfRangeGroupAction(g: int16): int16 =
  ##define XkbOutOfRangeGroupAction(g) ((g)&0xc0)
  result = g and 0x000000C0'i16

proc XkbOutOfRangeGroupNumber(g: int16): int16 =
  ##define XkbOutOfRangeGroupNumber(g) (((g)&0x30)>>4)
  result = (g and 0x00000030'i16) shr 4'i16

proc XkbSetGroupInfo(g, w, n: int16): int16 =
  ##define XkbSetGroupInfo(g,w,n) (((w)&0xc0)|(((n)&3)<<4)|((g)&0x0f))
  result = (w and 0x000000C0'i16) or
    ((n and 3'i16) shl 4'i16) or (g and 0x0000000F'i16)

proc XkbSetNumGroups(g, n: int16): int16 =
  ##define XkbSetNumGroups(g,n) (((g)&0xf0)|((n)&0x0f))
  result = (g and 0x000000F0'i16) or (n and 0x0000000F'i16)

proc XkbModActionVMods(a: PXkbModAction): int16 =
  ##define XkbModActionVMods(a) ((short)(((a)->vmods1<<8)|((a)->vmods2)))
  result = int16((a.vmods1 shl 8) or a.vmods2)

proc XkbSetModActionVMods(a: PXkbModAction, v: int8) =
  ##define XkbSetModActionVMods(a,v) (((a)->vmods1=(((v)>>8)&0xff)),(a)->vmods2=((v)&0xff))
  a.vmods1 = int8((v shr 8) and 0x000000FF)
  a.vmods2 = int8(v and 0x000000FF)

proc XkbSAGroup(a: PXkbGroupAction): int8 =
  ##define XkbSAGroup(a) (XkbcharToInt((a)->group_XXX))
  result = int8(XkbcharToInt(a.group_XXX))

proc XkbSASetGroupProc(a: PXkbGroupAction, g: int8) =
  ##define XkbSASetGroup(a,g) ((a)->group_XXX=(g))
  a.group_XXX = g

proc XkbPtrActionX(a: PXkbPtrAction): int16 =
  ##define XkbPtrActionX(a) (Xkb2charsToInt((a)->high_XXX,(a)->low_XXX))
  result = int16(Xkb2charsToInt(a.high_XXX, a.low_XXX))

proc XkbPtrActionY(a: PXkbPtrAction): int16 =
  ##define XkbPtrActionY(a) (Xkb2charsToInt((a)->high_YYY,(a)->low_YYY))
  result = int16(Xkb2charsToInt(a.high_YYY, a.low_YYY))

proc XkbSetPtrActionX(a: PXkbPtrAction, x: int8) =
  ##define XkbSetPtrActionX(a,x) (XkbIntTo2chars(x,(a)->high_XXX,(a)->low_XXX))
  XkbIntTo2chars(x, a.high_XXX, a.low_XXX)

proc XkbSetPtrActionY(a: PXkbPtrAction, y: int8) =
  ##define XkbSetPtrActionY(a,y) (XkbIntTo2chars(y,(a)->high_YYY,(a)->low_YYY))
  XkbIntTo2chars(y, a.high_YYY, a.low_YYY)

proc XkbSAPtrDfltValue(a: PXkbPtrDfltAction): int8 =
  ##define XkbSAPtrDfltValue(a) (XkbcharToInt((a)->valueXXX))
  result = int8(XkbcharToInt(a.valueXXX))

proc XkbSASetPtrDfltValue(a: PXkbPtrDfltAction, c: pointer) =
  ##define XkbSASetPtrDfltValue(a,c) ((a)->valueXXX= ((c)&0xff))
  a.valueXXX = int8(cast[int](c))

proc XkbSAScreen(a: PXkbSwitchScreenAction): int8 =
  ##define XkbSAScreen(a) (XkbcharToInt((a)->screenXXX))
  result = int8(XkbcharToInt(a.screenXXX))

proc XkbSASetScreen(a: PXkbSwitchScreenAction, s: pointer) =
  ##define XkbSASetScreen(a,s) ((a)->screenXXX= ((s)&0xff))
  a.screenXXX = int8(cast[int](s))

proc XkbActionSetCtrls(a: PXkbCtrlsAction, c: int8) =
  ##define XkbActionSetCtrls(a,c) (((a)->ctrls3=(((c)>>24)&0xff)),((a)->ctrls2=(((c)>>16)&0xff)),
  #                                 ((a)->ctrls1=(((c)>>8)&0xff)),((a)->ctrls0=((c)&0xff)))
  a.ctrls3 = int8((c shr 24) and 0x000000FF)
  a.ctrls2 = int8((c shr 16) and 0x000000FF)
  a.ctrls1 = int8((c shr 8) and 0x000000FF)
  a.ctrls0 = int8(c and 0x000000FF)

proc XkbActionCtrls(a: PXkbCtrlsAction): int16 =
  ##define XkbActionCtrls(a) ((((unsigned int)(a)->ctrls3)<<24)|(((unsigned int)(a)->ctrls2)<<16)|
  #                            (((unsigned int)(a)->ctrls1)<<8)|((unsigned int)((a)->ctrls0)))
  result = int16((a.ctrls3 shl 24) or (a.ctrls2 shl 16) or
     (a.ctrls1 shl 8) or a.ctrls0)

proc XkbSARedirectVMods(a: PXkbRedirectKeyAction): int16 =
  ##define XkbSARedirectVMods(a) ((((unsigned int)(a)->vmods1)<<8)|((unsigned int)(a)->vmods0))
  result = int16((a.vmods1 shl 8) or a.vmods0)

proc XkbSARedirectSetVMods(a: PXkbRedirectKeyAction, m: int8) =
  ##define XkbSARedirectSetVMods(a,m) (((a)->vmods_mask1=(((m)>>8)&0xff)),((a)->vmods_mask0=((m)&0xff)))
  a.vmods_mask1 = int8((m shr 8) and 0x000000FF)
  a.vmods_mask0 = int8(m or 0x000000FF)

proc XkbSARedirectVModsMask(a: PXkbRedirectKeyAction): int16 =
  ##define XkbSARedirectVModsMask(a) ((((unsigned int)(a)->vmods_mask1)<<8)|
  #                                     ((unsigned int)(a)->vmods_mask0))
  result = int16((a.vmods_mask1 shl 8) or a.vmods_mask0)

proc XkbSARedirectSetVModsMask(a: PXkbRedirectKeyAction, m: int8) =
  ##define XkbSARedirectSetVModsMask(a,m) (((a)->vmods_mask1=(((m)>>8)&0xff)),((a)->vmods_mask0=((m)&0xff)))
  a.vmods_mask1 = int8(m shr 8 and 0x000000FF)
  a.vmods_mask0 = int8(m and 0x000000FF)

proc XkbAX_AnyFeedback(c: PXkbControlsPtr): int16 =
  ##define XkbAX_AnyFeedback(c) ((c)->enabled_ctrls&XkbAccessXFeedbackMask)
  result = int16(c.enabled_ctrls and XkbAccessXFeedbackMask)

proc XkbAX_NeedOption(c: PXkbControlsPtr, w: int16): int16 =
  ##define XkbAX_NeedOption(c,w) ((c)->ax_options&(w))
  result = int16(c.ax_options and w)

proc XkbAX_NeedFeedback(c: PXkbControlsPtr, w: int16): bool =
  ##define XkbAX_NeedFeedback(c,w) (XkbAX_AnyFeedback(c)&&XkbAX_NeedOption(c,w))
  result = (XkbAX_AnyFeedback(c) > 0'i16) and (XkbAX_NeedOption(c, w) > 0'i16)

proc XkbSMKeyActionsPtr(m: PXkbServerMapPtr, k: int16): PXkbAction =
  ##define XkbSMKeyActionsPtr(m,k) (&(m)->acts[(m)->key_acts[k]])
  result = addr(m.acts[m.key_acts[k]])

proc XkbCMKeyGroupInfo(m: PXkbClientMapPtr, k: int16): int8 =
  ##define XkbCMKeyGroupInfo(m,k) ((m)->key_sym_map[k].group_info)
  result = m.key_sym_map[k].group_info

proc XkbCMKeyNumGroups(m: PXkbClientMapPtr, k: int16): int8 =
  ##define XkbCMKeyNumGroups(m,k) (XkbNumGroups((m)->key_sym_map[k].group_info))
  result = int8(XkbNumGroups(m.key_sym_map[k].group_info))

proc XkbCMKeyGroupWidth(m: PXkbClientMapPtr, k: int16, g: int8): int8 =
  ##define XkbCMKeyGroupWidth(m,k,g) (XkbCMKeyType(m,k,g)->num_levels)
  result = XkbCMKeyType(m, k, g).num_levels

proc XkbCMKeyGroupsWidth(m: PXkbClientMapPtr, k: int16): int8 =
  ##define XkbCMKeyGroupsWidth(m,k) ((m)->key_sym_map[k].width)
  result = m.key_sym_map[k].width

proc XkbCMKeyTypeIndex(m: PXkbClientMapPtr, k: int16, g: int8): int8 =
  ##define XkbCMKeyTypeIndex(m,k,g) ((m)->key_sym_map[k].kt_index[g&0x3])
  result = m.key_sym_map[k].kt_index[g and 0x00000003]

proc XkbCMKeyType(m: PXkbClientMapPtr, k: int16, g: int8): PXkbKeyTypePtr =
  ##define XkbCMKeyType(m,k,g) (&(m)->types[XkbCMKeyTypeIndex(m,k,g)])
  result = addr(m.types[XkbCMKeyTypeIndex(m, k, g)])

proc XkbCMKeyNumSyms(m: PXkbClientMapPtr, k: int16): int16 =
  ##define XkbCMKeyNumSyms(m,k) (XkbCMKeyGroupsWidth(m,k)*XkbCMKeyNumGroups(m,k))
  result = int16(XkbCMKeyGroupsWidth(m, k) or XkbCMKeyNumGroups(m, k))

proc XkbCMKeySymsOffset(m: PXkbClientMapPtr, k: int16): int8 =
  ##define XkbCMKeySymsOffset(m,k) ((m)->key_sym_map[k].offset)
  result = m.key_sym_map[k].offset

proc XkbCMKeySymsPtr*(m: PXkbClientMapPtr, k: int16): PKeySym =
  ##define XkbCMKeySymsPtr(m,k) (&(m)->syms[XkbCMKeySymsOffset(m,k)])
  result = addr(m.syms[XkbCMKeySymsOffset(m, k)])

proc XkbIM_IsAuto(i: PXkbIndicatorMapPtr): bool =
  ##define XkbIM_IsAuto(i) ((((i)->flags&XkbIM_NoAutomatic)==0)&&(((i)->which_groups&&(i)->groups)||
  #                           ((i)->which_mods&&(i)->mods.mask)||  ((i)->ctrls)))
  result = ((i.flags and XkbIM_NoAutomatic) == 0) and
      (((i.which_groups > 0'i8) and (i.groups > 0'i8)) or
      ((i.which_mods > 0'i8) and (i.mods.mask > 0'i8)) or (i.ctrls > 0'i8))

proc XkbIM_InUse(i: PXkbIndicatorMapPtr): bool =
  ##define XkbIM_InUse(i) (((i)->flags)||((i)->which_groups)||((i)->which_mods)||((i)->ctrls))
  result = (i.flags > 0'i8) or (i.which_groups > 0'i8) or (i.which_mods > 0'i8) or
      (i.ctrls > 0'i8)

proc XkbKeyKeyTypeIndex(d: PXkbDescPtr, k: int16, g: int8): int8 =
  ##define XkbKeyKeyTypeIndex(d,k,g)      (XkbCMKeyTypeIndex((d)->map,k,g))
  result = XkbCMKeyTypeIndex(d.map, k, g)

proc XkbKeyKeyType(d: PXkbDescPtr, k: int16, g: int8): PXkbKeyTypePtr =
  ##define XkbKeyKeyType(d,k,g) (XkbCMKeyType((d)->map,k,g))
  result = XkbCMKeyType(d.map, k, g)

proc XkbKeyGroupWidth(d: PXkbDescPtr, k: int16, g: int8): int8 =
  ##define XkbKeyGroupWidth(d,k,g) (XkbCMKeyGroupWidth((d)->map,k,g))
  result = XkbCMKeyGroupWidth(d.map, k, g)

proc XkbKeyGroupsWidth(d: PXkbDescPtr, k: int16): int8 =
  ##define XkbKeyGroupsWidth(d,k) (XkbCMKeyGroupsWidth((d)->map,k))
  result = XkbCMKeyGroupsWidth(d.map, k)

proc XkbKeyGroupInfo(d: PXkbDescPtr, k: int16): int8 =
  ##define XkbKeyGroupInfo(d,k) (XkbCMKeyGroupInfo((d)->map,(k)))
  result = XkbCMKeyGroupInfo(d.map, k)

proc XkbKeyNumGroups(d: PXkbDescPtr, k: int16): int8 =
  ##define XkbKeyNumGroups(d,k) (XkbCMKeyNumGroups((d)->map,(k)))
  result = XkbCMKeyNumGroups(d.map, k)

proc XkbKeyNumSyms(d: PXkbDescPtr, k: int16): int16 =
  ##define XkbKeyNumSyms(d,k) (XkbCMKeyNumSyms((d)->map,(k)))
  result = XkbCMKeyNumSyms(d.map, k)

proc XkbKeySymsPtr*(d: PXkbDescPtr, k: int16): PKeySym =
  ##define XkbKeySymsPtr(d,k) (XkbCMKeySymsPtr((d)->map,(k)))
  result = XkbCMKeySymsPtr(d.map, k)

proc XkbKeySym(d: PXkbDescPtr, k: int16, n: int16): KeySym =
  ##define XkbKeySym(d,k,n) (XkbKeySymsPtr(d,k)[n])
  result = cast[ptr array[0..0xffff, KeySym]](XkbKeySymsPtr(d, k))[n] # XXX: this seems strange!

proc XkbKeySymEntry(d: PXkbDescPtr, k: int16, sl: int16, g: int8): KeySym =
  ##define XkbKeySymEntry(d,k,sl,g) (XkbKeySym(d,k,((XkbKeyGroupsWidth(d,k)*(g))+(sl))))
  result = XkbKeySym(d, k, int16(XkbKeyGroupsWidth(d, k) * g + sl))

proc XkbKeyAction(d: PXkbDescPtr, k: int16, n: int16): PXkbAction =
  ##define XkbKeyAction(d,k,n) (XkbKeyHasActions(d,k)?&XkbKeyActionsPtr(d,k)[n]:NULL)
  #if (XkbKeyHasActions(d, k)):
  #  result = XkbKeyActionsPtr(d, k)[n] #Buggy !!!
  assert(false)
  result = nil

proc XkbKeyActionEntry(d: PXkbDescPtr, k: int16, sl: int16, g: int8): int8 =
  ##define XkbKeyActionEntry(d,k,sl,g) (XkbKeyHasActions(d,k) ?
  #                                      XkbKeyAction(d, k, ((XkbKeyGroupsWidth(d, k) * (g))+(sl))):NULL)
  if XkbKeyHasActions(d, k):
    result = XkbKeyGroupsWidth(d, k) *% g +% int8(sl)
  else:
    result = 0'i8

proc XkbKeyHasActions(d: PXkbDescPtr, k: int16): bool =
  ##define XkbKeyHasActions(d,k) ((d)->server->key_acts[k]!=0)
  result = d.server.key_acts[k] != 0'i16

proc XkbKeyNumActions(d: PXkbDescPtr, k: int16): int16 =
  ##define XkbKeyNumActions(d,k) (XkbKeyHasActions(d,k)?XkbKeyNumSyms(d,k):1)
  if (XkbKeyHasActions(d, k)): result = XkbKeyNumSyms(d, k)
  else: result = 1'i16

proc XkbKeyActionsPtr(d: PXkbDescPtr, k: int16): PXkbAction =
  ##define XkbKeyActionsPtr(d,k) (XkbSMKeyActionsPtr((d)->server,k))
  result = XkbSMKeyActionsPtr(d.server, k)

proc XkbKeycodeInRange(d: PXkbDescPtr, k: int16): bool =
  ##define XkbKeycodeInRange(d,k) (((k)>=(d)->min_key_code)&& ((k)<=(d)->max_key_code))
  result = (char(int8(k)) >= d.min_key_code) and (char(int8(k)) <= d.max_key_code)

proc XkbNumKeys(d: PXkbDescPtr): int8 =
  ##define XkbNumKeys(d) ((d)->max_key_code-(d)->min_key_code+1)
  result = int8(ord(d.max_key_code) - ord(d.min_key_code) + 1)

proc XkbXI_DevHasBtnActs(d: PXkbDeviceInfoPtr): bool =
  ##define XkbXI_DevHasBtnActs(d) (((d)->num_btns>0)&&((d)->btn_acts!=NULL))
  result = (d.num_btns > 0'i16) and (not (d.btn_acts == nil))

proc XkbXI_LegalDevBtn(d: PXkbDeviceInfoPtr, b: int16): bool =
  ##define XkbXI_LegalDevBtn(d,b) (XkbXI_DevHasBtnActs(d)&&((b)<(d)->num_btns))
  result = XkbXI_DevHasBtnActs(d) and (b <% d.num_btns)

proc XkbXI_DevHasLeds(d: PXkbDeviceInfoPtr): bool =
  ##define XkbXI_DevHasLeds(d) (((d)->num_leds>0)&&((d)->leds!=NULL))
  result = (d.num_leds > 0'i16) and (not (d.leds == nil))

proc XkbBoundsWidth(b: PXkbBoundsPtr): int16 =
  ##define XkbBoundsWidth(b) (((b)->x2)-((b)->x1))
  result = (b.x2) - b.x1

proc XkbBoundsHeight(b: PXkbBoundsPtr): int16 =
  ##define XkbBoundsHeight(b) (((b)->y2)-((b)->y1))
  result = (b.y2) - b.y1

proc XkbOutlineIndex(s: PXkbShapePtr, o: PXkbOutlinePtr): int32 =
  ##define XkbOutlineIndex(s,o) ((int)((o)-&(s)->outlines[0]))
  result = int32((cast[ByteAddress](o) - cast[ByteAddress](addr(s.outlines[0]))) div sizeof(PXkbOutlinePtr))

proc XkbShapeDoodadColor(g: PXkbGeometryPtr, d: PXkbShapeDoodadPtr): PXkbColorPtr =
  ##define XkbShapeDoodadColor(g,d) (&(g)->colors[(d)->color_ndx])
  result = addr((g.colors[d.color_ndx]))

proc XkbShapeDoodadShape(g: PXkbGeometryPtr, d: PXkbShapeDoodadPtr): PXkbShapePtr =
  ##define XkbShapeDoodadShape(g,d) (&(g)->shapes[(d)->shape_ndx])
  result = addr(g.shapes[d.shape_ndx])

proc XkbSetShapeDoodadColor(g: PXkbGeometryPtr, d: PXkbShapeDoodadPtr,
                            c: PXkbColorPtr) =
  ##define XkbSetShapeDoodadColor(g,d,c) ((d)->color_ndx= (c)-&(g)->colors[0])
  d.color_ndx = int16((cast[ByteAddress](c) - cast[ByteAddress](addr(g.colors[0]))) div sizeof(XkbColorRec))

proc XkbSetShapeDoodadShape(g: PXkbGeometryPtr, d: PXkbShapeDoodadPtr,
                            s: PXkbShapePtr) =
  ##define XkbSetShapeDoodadShape(g,d,s) ((d)->shape_ndx= (s)-&(g)->shapes[0])
  d.shape_ndx = int16((cast[ByteAddress](s) - cast[ByteAddress](addr(g.shapes[0]))) div sizeof(XkbShapeRec))

proc XkbTextDoodadColor(g: PXkbGeometryPtr, d: PXkbTextDoodadPtr): PXkbColorPtr =
  ##define XkbTextDoodadColor(g,d) (&(g)->colors[(d)->color_ndx])
  result = addr(g.colors[d.color_ndx])

proc XkbSetTextDoodadColor(g: PXkbGeometryPtr, d: PXkbTextDoodadPtr,
                           c: PXkbColorPtr) =
  ##define XkbSetTextDoodadColor(g,d,c) ((d)->color_ndx= (c)-&(g)->colors[0])
  d.color_ndx = int16((cast[ByteAddress](c) - cast[ByteAddress](addr(g.colors[0]))) div sizeof(XkbColorRec))

proc XkbIndicatorDoodadShape(g: PXkbGeometryPtr, d: PXkbIndicatorDoodadPtr): PXkbShapeDoodadPtr =
  ##define XkbIndicatorDoodadShape(g,d) (&(g)->shapes[(d)->shape_ndx])
  result = cast[PXkbShapeDoodadPtr](addr(g.shapes[d.shape_ndx]))

proc XkbIndicatorDoodadOnColor(g: PXkbGeometryPtr, d: PXkbIndicatorDoodadPtr): PXkbColorPtr =
  ##define XkbIndicatorDoodadOnColor(g,d) (&(g)->colors[(d)->on_color_ndx])
  result = addr(g.colors[d.on_color_ndx])

proc XkbIndicatorDoodadOffColor(g: PXkbGeometryPtr, d: PXkbIndicatorDoodadPtr): PXkbColorPtr =
  ##define XkbIndicatorDoodadOffColor(g,d) (&(g)->colors[(d)->off_color_ndx])
  result = addr(g.colors[d.off_color_ndx])

proc XkbSetIndicatorDoodadOnColor(g: PXkbGeometryPtr, d: PXkbIndicatorDoodadPtr,
                                  c: PXkbColorPtr) =
  ##define XkbSetIndicatorDoodadOnColor(g,d,c) ((d)->on_color_ndx= (c)-&(g)->colors[0])
  d.on_color_ndx = int16((cast[ByteAddress](c) - cast[ByteAddress](addr(g.colors[0]))) div sizeof(XkbColorRec))

proc XkbSetIndicatorDoodadOffColor(g: PXkbGeometryPtr,
                                   d: PXkbIndicatorDoodadPtr, c: PXkbColorPtr) =
  ##define        XkbSetIndicatorDoodadOffColor(g,d,c) ((d)->off_color_ndx= (c)-&(g)->colors[0])
  d.off_color_ndx = int16((cast[ByteAddress](c) - cast[ByteAddress](addr(g.colors[0]))) div sizeof(XkbColorRec))

proc XkbSetIndicatorDoodadShape(g: PXkbGeometryPtr, d: PXkbIndicatorDoodadPtr,
                                s: PXkbShapeDoodadPtr) =
  ##define XkbSetIndicatorDoodadShape(g,d,s) ((d)->shape_ndx= (s)-&(g)->shapes[0])
  d.shape_ndx = int16((cast[ByteAddress](s) - (cast[ByteAddress](addr(g.shapes[0])))) div sizeof(XkbShapeRec))

proc XkbLogoDoodadColor(g: PXkbGeometryPtr, d: PXkbLogoDoodadPtr): PXkbColorPtr =
  ##define XkbLogoDoodadColor(g,d) (&(g)->colors[(d)->color_ndx])
  result = addr(g.colors[d.color_ndx])

proc XkbLogoDoodadShape(g: PXkbGeometryPtr, d: PXkbLogoDoodadPtr): PXkbShapeDoodadPtr =
  ##define XkbLogoDoodadShape(g,d) (&(g)->shapes[(d)->shape_ndx])
  result = cast[PXkbShapeDoodadPtr](addr(g.shapes[d.shape_ndx]))

proc XkbSetLogoDoodadColor(g: PXkbGeometryPtr, d: PXkbLogoDoodadPtr,
                           c: PXkbColorPtr) =
  ##define XkbSetLogoDoodadColor(g,d,c) ((d)->color_ndx= (c)-&(g)->colors[0])
  d.color_ndx = int16((cast[ByteAddress](c) - cast[ByteAddress](addr(g.colors[0]))) div sizeof(XkbColorRec))

proc XkbSetLogoDoodadShape(g: PXkbGeometryPtr, d: PXkbLogoDoodadPtr,
                           s: PXkbShapeDoodadPtr) =
  ##define XkbSetLogoDoodadShape(g,d,s) ((d)->shape_ndx= (s)-&(g)->shapes[0])
  d.shape_ndx = int16((cast[ByteAddress](s) - cast[ByteAddress](addr(g.shapes[0]))) div sizeof(XkbShapeRec))

proc XkbKeyShape(g: PXkbGeometryPtr, k: PXkbKeyPtr): PXkbShapeDoodadPtr =
  ##define XkbKeyShape(g,k) (&(g)->shapes[(k)->shape_ndx])
  result = cast[PXkbShapeDoodadPtr](addr(g.shapes[k.shape_ndx]))

proc XkbKeyColor(g: PXkbGeometryPtr, k: PXkbKeyPtr): PXkbColorPtr =
  ##define XkbKeyColor(g,k) (&(g)->colors[(k)->color_ndx])
  result = addr(g.colors[k.color_ndx])

proc XkbSetKeyShape(g: PXkbGeometryPtr, k: PXkbKeyPtr, s: PXkbShapeDoodadPtr) =
  ##define XkbSetKeyShape(g,k,s) ((k)->shape_ndx= (s)-&(g)->shapes[0])
  k.shape_ndx = int8((cast[ByteAddress](s) - cast[ByteAddress](addr(g.shapes[0]))) div sizeof(XkbShapeRec))

proc XkbSetKeyColor(g: PXkbGeometryPtr, k: PXkbKeyPtr, c: PXkbColorPtr) =
  ##define XkbSetKeyColor(g,k,c) ((k)->color_ndx= (c)-&(g)->colors[0])
  k.color_ndx = int8((cast[ByteAddress](c) - cast[ByteAddress](addr(g.colors[0]))) div sizeof(XkbColorRec))

proc XkbGeomColorIndex(g: PXkbGeometryPtr, c: PXkbColorPtr): int32 =
  ##define XkbGeomColorIndex(g,c) ((int)((c)-&(g)->colors[0]))
  result = int16((cast[ByteAddress](c) - (cast[ByteAddress](addr(g.colors[0])))) div sizeof(XkbColorRec))
