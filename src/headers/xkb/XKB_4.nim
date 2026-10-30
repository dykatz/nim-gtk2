# Included by headers/xkb.nim; do not import directly.
const
  XkbSA_NoAction* = 0x00000000
const
  XkbSA_SetMods* = 0x00000001
const
  XkbSA_LatchMods* = 0x00000002
const
  XkbSA_LockMods* = 0x00000003
const
  XkbSA_SetGroup* = 0x00000004
const
  XkbSA_LatchGroup* = 0x00000005
const
  XkbSA_LockGroup* = 0x00000006
const
  XkbSA_MovePtr* = 0x00000007
const
  XkbSA_PtrBtn* = 0x00000008
const
  XkbSA_LockPtrBtn* = 0x00000009
const
  XkbSA_SetPtrDflt* = 0x0000000A
const
  XkbSA_ISOLock* = 0x0000000B
const
  XkbSA_Terminate* = 0x0000000C
const
  XkbSA_SwitchScreen* = 0x0000000D
const
  XkbSA_SetControls* = 0x0000000E
const
  XkbSA_LockControls* = 0x0000000F
const
  XkbSA_ActionMessage* = 0x00000010
const
  XkbSA_RedirectKey* = 0x00000011
const
  XkbSA_DeviceBtn* = 0x00000012
const
  XkbSA_LockDeviceBtn* = 0x00000013
const
  XkbSA_DeviceValuator* = 0x00000014
const
  XkbSA_LastAction* = XkbSA_DeviceValuator
const
  XkbSA_NumActions* = XkbSA_LastAction + 1

const
  XkbSA_XFree86Private* = 0x00000086
#
#      Specifies the key actions that clear latched groups or modifiers.
#

