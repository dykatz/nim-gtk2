# Included by headers/xkb.nim; do not import directly.
const
  XkbWrapIntoRange* = 0x00000000
const
  XkbClampIntoRange* = 0x00000040
const
  XkbRedirectIntoRange* = 0x00000080 #
                                     #      Action flags:  Reported in the 'flags' field of most key actions.
                                     #      Interpretation depends on the type of the action; not all actions
                                     #      accept all flags.
                                     #
                                     #      Option                    Used for Actions
                                     #      ------                    ----------------
                                     #      ClearLocks                SetMods, LatchMods, SetGroup, LatchGroup
                                     #      LatchToLock               SetMods, LatchMods, SetGroup, LatchGroup
                                     #      LockNoLock                LockMods, ISOLock, LockPtrBtn, LockDeviceBtn
                                     #      LockNoUnlock              LockMods, ISOLock, LockPtrBtn, LockDeviceBtn
                                     #      UseModMapMods             SetMods, LatchMods, LockMods, ISOLock
                                     #      GroupAbsolute             SetGroup, LatchGroup, LockGroup, ISOLock
                                     #      UseDfltButton             PtrBtn, LockPtrBtn
                                     #      NoAcceleration            MovePtr
                                     #      MoveAbsoluteX             MovePtr
                                     #      MoveAbsoluteY             MovePtr
                                     #      ISODfltIsGroup            ISOLock
                                     #      ISONoAffectMods           ISOLock
                                     #      ISONoAffectGroup          ISOLock
                                     #      ISONoAffectPtr            ISOLock
                                     #      ISONoAffectCtrls          ISOLock
                                     #      MessageOnPress            ActionMessage
                                     #      MessageOnRelease          ActionMessage
                                     #      MessageGenKeyEvent        ActionMessage
                                     #      AffectDfltBtn             SetPtrDflt
                                     #      DfltBtnAbsolute           SetPtrDflt
                                     #      SwitchApplication SwitchScreen
                                     #      SwitchAbsolute            SwitchScreen
                                     #

const
  XkbSA_ClearLocks* = int(1) shl 0
const
  XkbSA_LatchToLock* = int(1) shl 1
const
  XkbSA_LockNoLock* = int(1) shl 0
const
  XkbSA_LockNoUnlock* = int(1) shl 1
const
  XkbSA_UseModMapMods* = int(1) shl 2
const
  XkbSA_GroupAbsolute* = int(1) shl 2
const
  XkbSA_UseDfltButton* = 0
const
  XkbSA_NoAcceleration* = int(1) shl 0
const
  XkbSA_MoveAbsoluteX* = int(1) shl 1
const
  XkbSA_MoveAbsoluteY* = int(1) shl 2
const
  XkbSA_ISODfltIsGroup* = int(1) shl 7
const
  XkbSA_ISONoAffectMods* = int(1) shl 6
const
  XkbSA_ISONoAffectGroup* = int(1) shl 5
const
  XkbSA_ISONoAffectPtr* = int(1) shl 4
const
  XkbSA_ISONoAffectCtrls* = int(1) shl 3
const
  XkbSA_ISOAffectMask* = 0x00000078
const
  XkbSA_MessageOnPress* = int(1) shl 0
const
  XkbSA_MessageOnRelease* = int(1) shl 1
const
  XkbSA_MessageGenKeyEvent* = int(1) shl 2
const
  XkbSA_AffectDfltBtn* = 1
const
  XkbSA_DfltBtnAbsolute* = int(1) shl 2
const
  XkbSA_SwitchApplication* = int(1) shl 0
const
  XkbSA_SwitchAbsolute* = int(1) shl 2 #
                                       #      The following values apply to the SA_DeviceValuator
                                       #      action only.  Valuator operations specify the action
                                       #      to be taken.   Values specified in the action are
                                       #      multiplied by 2^scale before they are applied.
                                       #

const
  XkbSA_IgnoreVal* = 0x00000000
const
  XkbSA_SetValMin* = 0x00000010
const
  XkbSA_SetValCenter* = 0x00000020
const
  XkbSA_SetValMax* = 0x00000030
const
  XkbSA_SetValRelative* = 0x00000040
const
  XkbSA_SetValAbsolute* = 0x00000050
const
  XkbSA_ValOpMask* = 0x00000070
const
  XkbSA_ValScaleMask* = 0x00000007

