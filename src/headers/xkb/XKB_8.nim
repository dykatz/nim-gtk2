# Included by headers/xkb.nim; do not import directly.
const
  XkbName* = "XKEYBOARD"
const
  XkbMajorVersion* = 1
const
  XkbMinorVersion* = 0 #
                       #      Explicit map components:
                       #       - Used in the 'explicit' field of an XkbServerMap.  Specifies
                       #         the keyboard components that should _not_ be updated automatically
                       #         in response to core protocol keyboard mapping requests.
                       #

const
  XkbExplicitKeyTypesMask* = 0x0000000F
const
  XkbExplicitKeyType1Mask* = 1 shl 0
const
  XkbExplicitKeyType2Mask* = 1 shl 1
const
  XkbExplicitKeyType3Mask* = 1 shl 2
const
  XkbExplicitKeyType4Mask* = 1 shl 3
const
  XkbExplicitInterpretMask* = 1 shl 4
const
  XkbExplicitAutoRepeatMask* = 1 shl 5
const
  XkbExplicitBehaviorMask* = 1 shl 6
const
  XkbExplicitVModMapMask* = 1 shl 7
const
  XkbAllExplicitMask* = 0x000000FF #
                                   #      Symbol interpretations flags:
                                   #       - Used in the flags field of a symbol interpretation
                                   #

const
  XkbSI_AutoRepeat* = 1 shl 0
const
  XkbSI_LockingKey* = 1 shl 1 #
                              #      Symbol interpretations match specification:
                              #       - Used in the match field of a symbol interpretation to specify
                              #         the conditions under which an interpretation is used.
                              #

const
  XkbSI_LevelOneOnly* = 0x00000080
const
  XkbSI_OpMask* = 0x0000007F
const
  XkbSI_NoneOf* = 0
const
  XkbSI_AnyOfOrNone* = 1
const
  XkbSI_AnyOf* = 2
const
  XkbSI_AllOf* = 3
const
  XkbSI_Exactly* = 4 #
                     #      Indicator map flags:
                     #       - Used in the flags field of an indicator map to indicate the
                     #         conditions under which and indicator can be changed and the
                     #         effects of changing the indicator.
                     #

const
  XkbIM_NoExplicit* = int(1) shl 7
const
  XkbIM_NoAutomatic* = int(1) shl 6
const
  XkbIM_LEDDrivesKB* = int(1) shl 5 #
                                    #      Indicator map component specifications:
                                    #       - Used by the 'which_groups' and 'which_mods' fields of an indicator
                                    #         map to specify which keyboard components should be used to drive
                                    #         the indicator.
                                    #

const
  XkbIM_UseBase* = int(1) shl 0
const
  XkbIM_UseLatched* = int(1) shl 1
const
  XkbIM_UseLocked* = int(1) shl 2
const
  XkbIM_UseEffective* = int(1) shl 3
const
  XkbIM_UseCompat* = int(1) shl 4
const
  XkbIM_UseNone* = 0
const
  XkbIM_UseAnyGroup* = XkbIM_UseBase or XkbIM_UseLatched or XkbIM_UseLocked or
      XkbIM_UseEffective
const
  XkbIM_UseAnyMods* = XkbIM_UseAnyGroup or XkbIM_UseCompat #
                                                           #      GetByName components:
                                                           #       - Specifies desired or necessary components to GetKbdByName request.
                                                           #       - Reports the components that were found in a GetKbdByNameReply
                                                           #

const
  XkbGBN_TypesMask* = int(1) shl 0
const
  XkbGBN_CompatMapMask* = int(1) shl 1
const
  XkbGBN_ClientSymbolsMask* = int(1) shl 2
const
  XkbGBN_ServerSymbolsMask* = int(1) shl 3
const
  XkbGBN_SymbolsMask* = XkbGBN_ClientSymbolsMask or XkbGBN_ServerSymbolsMask
const
  XkbGBN_IndicatorMapMask* = int(1) shl 4
const
  XkbGBN_KeyNamesMask* = int(1) shl 5
const
  XkbGBN_GeometryMask* = int(1) shl 6
const
  XkbGBN_OtherNamesMask* = int(1) shl 7
const
  XkbGBN_AllComponentsMask* = 0x000000FF #
                                         #       ListComponents flags
                                         #

const
  XkbLC_Hidden* = int(1) shl 0
const
  XkbLC_Default* = int(1) shl 1
const
  XkbLC_Partial* = int(1) shl 2
const
  XkbLC_AlphanumericKeys* = int(1) shl 8
const
  XkbLC_ModifierKeys* = int(1) shl 9
const
  XkbLC_KeypadKeys* = int(1) shl 10
const
  XkbLC_FunctionKeys* = int(1) shl 11
const
  XkbLC_AlternateGroup* = int(1) shl 12 #
                                        #      X Input Extension Interactions
                                        #      - Specifies the possible interactions between XKB and the X input
                                        #        extension
                                        #      - Used to request (XkbGetDeviceInfo) or change (XKbSetDeviceInfo)
                                        #        XKB information about an extension device.
                                        #      - Reports the list of supported optional features in the reply to
                                        #        XkbGetDeviceInfo or in an XkbExtensionDeviceNotify event.
                                        #      XkbXI_UnsupportedFeature is reported in XkbExtensionDeviceNotify
                                        #      events to indicate an attempt to use an unsupported feature.
                                        #

const
  XkbXI_KeyboardsMask* = int(1) shl 0
const
  XkbXI_ButtonActionsMask* = int(1) shl 1
const
  XkbXI_IndicatorNamesMask* = int(1) shl 2
const
  XkbXI_IndicatorMapsMask* = int(1) shl 3
const
  XkbXI_IndicatorStateMask* = int(1) shl 4
const
  XkbXI_UnsupportedFeatureMask* = int(1) shl 15
const
  XkbXI_AllFeaturesMask* = 0x0000001F
const
  XkbXI_AllDeviceFeaturesMask* = 0x0000001E
const
  XkbXI_IndicatorsMask* = 0x0000001C
const
  XkbAllExtensionDeviceEventsMask* = 0x0000801F #
                                                #      Per-Client Flags:
                                                #       - Specifies flags to be changed by the PerClientFlags request.
                                                #

const
  XkbPCF_DetectableAutoRepeatMask* = int(1) shl 0
const
  XkbPCF_GrabsUseXKBStateMask* = int(1) shl 1
const
  XkbPCF_AutoResetControlsMask* = int(1) shl 2
const
  XkbPCF_LookupStateWhenGrabbed* = int(1) shl 3
const
  XkbPCF_SendEventUsesXKBState* = int(1) shl 4
const
  XkbPCF_AllFlagsMask* = 0x0000001F #
                                    #      Debugging flags and controls
                                    #

const
  XkbDF_DisableLocks* = 1 shl 0

