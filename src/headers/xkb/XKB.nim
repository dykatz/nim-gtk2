# Included by headers/xkb.nim; do not import directly.
const
  X_kbUseExtension* = 0
const
  X_kbSelectEvents* = 1
const
  X_kbBell* = 3
const
  X_kbGetState* = 4
const
  X_kbLatchLockState* = 5
const
  X_kbGetControls* = 6
const
  X_kbSetControls* = 7
const
  X_kbGetMap* = 8
const
  X_kbSetMap* = 9
const
  X_kbGetCompatMap* = 10
const
  X_kbSetCompatMap* = 11
const
  X_kbGetIndicatorState* = 12
const
  X_kbGetIndicatorMap* = 13
const
  X_kbSetIndicatorMap* = 14
const
  X_kbGetNamedIndicator* = 15
const
  X_kbSetNamedIndicator* = 16
const
  X_kbGetNames* = 17
const
  X_kbSetNames* = 18
const
  X_kbGetGeometry* = 19
const
  X_kbSetGeometry* = 20
const
  X_kbPerClientFlags* = 21
const
  X_kbListComponents* = 22
const
  X_kbGetKbdByName* = 23
const
  X_kbGetDeviceInfo* = 24
const
  X_kbSetDeviceInfo* = 25
const
  X_kbSetDebuggingFlags* = 101 #
                               #      In the X sense, XKB reports only one event.
                               #      The type field of all XKB events is XkbEventCode
                               #

const
  XkbEventCode* = 0
const
  XkbNumberEvents* = XkbEventCode + 1 #
                                      #      XKB has a minor event code so it can use one X event code for
                                      #      multiple purposes.
                                      #       - reported in the xkbType field of all XKB events.
                                      #       - XkbSelectEventDetails: Indicates the event for which event details
                                      #         are being changed
                                      #

const
  XkbNewKeyboardNotify* = 0
const
  XkbMapNotify* = 1
const
  XkbStateNotify* = 2
const
  XkbControlsNotify* = 3
const
  XkbIndicatorStateNotify* = 4
const
  XkbIndicatorMapNotify* = 5
const
  XkbNamesNotify* = 6
const
  XkbCompatMapNotify* = 7
const
  XkbBellNotify* = 8
const
  XkbActionMessage* = 9
const
  XkbAccessXNotify* = 10
const
  XkbExtensionDeviceNotify* = 11 #
                                 #      Event Mask:
                                 #       - XkbSelectEvents:  Specifies event interest.
                                 #

const
  XkbNewKeyboardNotifyMask* = int(1) shl 0
const
  XkbMapNotifyMask* = int(1) shl 1
const
  XkbStateNotifyMask* = int(1) shl 2
const
  XkbControlsNotifyMask* = int(1) shl 3
const
  XkbIndicatorStateNotifyMask* = int(1) shl 4
const
  XkbIndicatorMapNotifyMask* = int(1) shl 5
const
  XkbNamesNotifyMask* = int(1) shl 6
const
  XkbCompatMapNotifyMask* = int(1) shl 7
const
  XkbBellNotifyMask* = int(1) shl 8
const
  XkbActionMessageMask* = int(1) shl 9
const
  XkbAccessXNotifyMask* = int(1) shl 10
const
  XkbExtensionDeviceNotifyMask* = int(1) shl 11
const
  XkbAllEventsMask* = 0x00000FFF #
                                 #      NewKeyboardNotify event details:
                                 #

const
  XkbNKN_KeycodesMask* = int(1) shl 0
const
  XkbNKN_GeometryMask* = int(1) shl 1
const
  XkbNKN_DeviceIDMask* = int(1) shl 2
const
  XkbAllNewKeyboardEventsMask* = 0x00000007 #
                                            #      AccessXNotify event types:
                                            #       - The 'what' field of AccessXNotify events reports the
                                            #         reason that the event was generated.
                                            #

const
  XkbAXN_SKPress* = 0
const
  XkbAXN_SKAccept* = 1
const
  XkbAXN_SKReject* = 2
const
  XkbAXN_SKRelease* = 3
const
  XkbAXN_BKAccept* = 4
const
  XkbAXN_BKReject* = 5
const
  XkbAXN_AXKWarning* = 6 #
                         #      AccessXNotify details:
                         #      - Used as an event detail mask to limit the conditions under which
                         #        AccessXNotify events are reported
                         #

const
  XkbAXN_SKPressMask* = int(1) shl 0
const
  XkbAXN_SKAcceptMask* = int(1) shl 1
const
  XkbAXN_SKRejectMask* = int(1) shl 2
const
  XkbAXN_SKReleaseMask* = int(1) shl 3
const
  XkbAXN_BKAcceptMask* = int(1) shl 4
const
  XkbAXN_BKRejectMask* = int(1) shl 5
const
  XkbAXN_AXKWarningMask* = int(1) shl 6
const
  XkbAllAccessXEventsMask* = 0x0000000F #
                                        #      State detail mask:
                                        #       - The 'changed' field of StateNotify events reports which of
                                        #         the keyboard state components have changed.
                                        #       - Used as an event detail mask to limit the conditions under
                                        #         which StateNotify events are reported.
                                        #

const
  XkbModifierStateMask* = int(1) shl 0
const
  XkbModifierBaseMask* = int(1) shl 1
const
  XkbModifierLatchMask* = int(1) shl 2
const
  XkbModifierLockMask* = int(1) shl 3
const
  XkbGroupStateMask* = int(1) shl 4
const
  XkbGroupBaseMask* = int(1) shl 5
const
  XkbGroupLatchMask* = int(1) shl 6
const
  XkbGroupLockMask* = int(1) shl 7
const
  XkbCompatStateMask* = int(1) shl 8
const
  XkbGrabModsMask* = int(1) shl 9
const
  XkbCompatGrabModsMask* = int(1) shl 10
const
  XkbLookupModsMask* = int(1) shl 11
const
  XkbCompatLookupModsMask* = int(1) shl 12
const
  XkbPointerButtonMask* = int(1) shl 13
const
  XkbAllStateComponentsMask* = 0x00003FFF #
                                          #      Controls detail masks:
                                          #       The controls specified in XkbAllControlsMask:
                                          #       - The 'changed' field of ControlsNotify events reports which of
                                          #         the keyboard controls have changed.
                                          #       - The 'changeControls' field of the SetControls request specifies
                                          #         the controls for which values are to be changed.
                                          #       - Used as an event detail mask to limit the conditions under
                                          #         which ControlsNotify events are reported.
                                          #
                                          #       The controls specified in the XkbAllBooleanCtrlsMask:
                                          #       - The 'enabledControls' field of ControlsNotify events reports the
                                          #         current status of the boolean controls.
                                          #       - The 'enabledControlsChanges' field of ControlsNotify events reports
                                          #         any boolean controls that have been turned on or off.
                                          #       - The 'affectEnabledControls' and 'enabledControls' fields of the
                                          #         kbSetControls request change the set of enabled controls.
                                          #       - The 'accessXTimeoutMask' and 'accessXTimeoutValues' fields of
                                          #         an XkbControlsRec specify the controls to be changed if the keyboard
                                          #         times out and the values to which they should be changed.
                                          #       - The 'autoCtrls' and 'autoCtrlsValues' fields of the PerClientFlags
                                          #         request specifies the specify the controls to be reset when the
                                          #         client exits and the values to which they should be reset.
                                          #       - The 'ctrls' field of an indicator map specifies the controls
                                          #         that drive the indicator.
                                          #       - Specifies the boolean controls affected by the SetControls and
                                          #         LockControls key actions.
                                          #

const
  XkbRepeatKeysMask* = int(1) shl 0
const
  XkbSlowKeysMask* = int(1) shl 1
const
  XkbBounceKeysMask* = int(1) shl 2
const
  XkbStickyKeysMask* = int(1) shl 3
const
  XkbMouseKeysMask* = int(1) shl 4
const
  XkbMouseKeysAccelMask* = int(1) shl 5
const
  XkbAccessXKeysMask* = int(1) shl 6
const
  XkbAccessXTimeoutMask* = int(1) shl 7
const
  XkbAccessXFeedbackMask* = int(1) shl 8
const
  XkbAudibleBellMask* = int(1) shl 9
const
  XkbOverlay1Mask* = int(1) shl 10
const
  XkbOverlay2Mask* = int(1) shl 11
const
  XkbIgnoreGroupLockMask* = int(1) shl 12
const
  XkbGroupsWrapMask* = int(1) shl 27
const
  XkbInternalModsMask* = int(1) shl 28
const
  XkbIgnoreLockModsMask* = int(1) shl 29
const
  XkbPerKeyRepeatMask* = int(1) shl 30
const
  XkbControlsEnabledMask* = int(1) shl 31
const
  XkbAccessXOptionsMask* = XkbStickyKeysMask or XkbAccessXFeedbackMask
const
  XkbAllBooleanCtrlsMask* = 0x00001FFF
const
  XkbAllControlsMask* = 0xF8001FFF #
                                   #      Compatibility Map Compontents:
                                   #       - Specifies the components to be allocated in XkbAllocCompatMap.
                                   #

const
  XkbSymInterpMask* = 1 shl 0
const
  XkbGroupCompatMask* = 1 shl 1
const
  XkbAllCompatMask* = 0x00000003 #
                                 #      Assorted constants and limits.
                                 #

const
  XkbAllIndicatorsMask* = 0xFFFFFFFF #
                                     #      Map components masks:
                                     #      Those in AllMapComponentsMask:
                                     #       - Specifies the individual fields to be loaded or changed for the
                                     #         GetMap and SetMap requests.
                                     #      Those in ClientInfoMask:
                                     #       - Specifies the components to be allocated by XkbAllocClientMap.
                                     #      Those in ServerInfoMask:
                                     #       - Specifies the components to be allocated by XkbAllocServerMap.
                                     #

const
  XkbKeyTypesMask* = 1 shl 0
const
  XkbKeySymsMask* = 1 shl 1
const
  XkbModifierMapMask* = 1 shl 2
const
  XkbExplicitComponentsMask* = 1 shl 3
const
  XkbKeyActionsMask* = 1 shl 4
const
  XkbKeyBehaviorsMask* = 1 shl 5
const
  XkbVirtualModsMask* = 1 shl 6
const
  XkbVirtualModMapMask* = 1 shl 7
const
  XkbAllClientInfoMask* = XkbKeyTypesMask or XkbKeySymsMask or
      XkbModifierMapMask
const
  XkbAllServerInfoMask* = XkbExplicitComponentsMask or XkbKeyActionsMask or
      XkbKeyBehaviorsMask or XkbVirtualModsMask or XkbVirtualModMapMask
const
  XkbAllMapComponentsMask* = XkbAllClientInfoMask or XkbAllServerInfoMask #
                                                                          #      Names component mask:
                                                                          #       - Specifies the names to be loaded or changed for the GetNames and
                                                                          #         SetNames requests.
                                                                          #       - Specifies the names that have changed in a NamesNotify event.
                                                                          #       - Specifies the names components to be allocated by XkbAllocNames.
                                                                          #

const
  XkbKeycodesNameMask* = 1 shl 0
const
  XkbGeometryNameMask* = 1 shl 1
const
  XkbSymbolsNameMask* = 1 shl 2
const
  XkbPhysSymbolsNameMask* = 1 shl 3
const
  XkbTypesNameMask* = 1 shl 4
const
  XkbCompatNameMask* = 1 shl 5
const
  XkbKeyTypeNamesMask* = 1 shl 6
const
  XkbKTLevelNamesMask* = 1 shl 7
const
  XkbIndicatorNamesMask* = 1 shl 8
const
  XkbKeyNamesMask* = 1 shl 9
const
  XkbKeyAliasesMask* = 1 shl 10
const
  XkbVirtualModNamesMask* = 1 shl 11
const
  XkbGroupNamesMask* = 1 shl 12
const
  XkbRGNamesMask* = 1 shl 13
const
  XkbComponentNamesMask* = 0x0000003F
const
  XkbAllNamesMask* = 0x00003FFF #
                                #      Miscellaneous event details:
                                #      - event detail masks for assorted events that don't reall
                                #        have any details.
                                #

const
  XkbAllStateEventsMask* = XkbAllStateComponentsMask
const
  XkbAllMapEventsMask* = XkbAllMapComponentsMask
const
  XkbAllControlEventsMask* = XkbAllControlsMask
const
  XkbAllIndicatorEventsMask* = XkbAllIndicatorsMask
const
  XkbAllNameEventsMask* = XkbAllNamesMask
const
  XkbAllCompatMapEventsMask* = XkbAllCompatMask
const
  XkbAllBellEventsMask* = int(1) shl 0
const
  XkbAllActionMessagesMask* = int(1) shl 0 #
                                           #      XKB reports one error:  BadKeyboard
                                           #      A further reason for the error is encoded into to most significant
                                           #      byte of the resourceID for the error:
                                           #         XkbErr_BadDevice - the device in question was not found
                                           #         XkbErr_BadClass  - the device was found but it doesn't belong to
                                           #                            the appropriate class.
                                           #         XkbErr_BadId     - the device was found and belongs to the right
                                           #                            class, but not feedback with a matching id was
                                           #                            found.
                                           #      The low byte of the resourceID for this error contains the device
                                           #      id, class specifier or feedback id that failed.
                                           #

const
  XkbKeyboard* = 0
const
  XkbNumberErrors* = 1
const
  XkbErr_BadDevice* = 0x000000FF
const
  XkbErr_BadClass* = 0x000000FE
const
  XkbErr_BadId* = 0x000000FD #
                             #      Keyboard Components Mask:
                             #      - Specifies the components that follow a GetKeyboardByNameReply
                             #

const
  XkbClientMapMask* = int(1) shl 0
const
  XkbServerMapMask* = int(1) shl 1
const
  XkbCompatMapMask* = int(1) shl 2
const
  XkbIndicatorMapMask* = int(1) shl 3
const
  XkbNamesMask* = int(1) shl 4
const
  XkbGeometryMask* = int(1) shl 5
const
  XkbControlsMask* = int(1) shl 6
const
  XkbAllComponentsMask* = 0x0000007F #
                                     #      AccessX Options Mask
                                     #       - The 'accessXOptions' field of an XkbControlsRec specifies the
                                     #         AccessX options that are currently in effect.
                                     #       - The 'accessXTimeoutOptionsMask' and 'accessXTimeoutOptionsValues'
                                     #         fields of an XkbControlsRec specify the Access X options to be
                                     #         changed if the keyboard times out and the values to which they
                                     #         should be changed.
                                     #

const
  XkbAX_SKPressFBMask* = int(1) shl 0
const
  XkbAX_SKAcceptFBMask* = int(1) shl 1
const
  XkbAX_FeatureFBMask* = int(1) shl 2
const
  XkbAX_SlowWarnFBMask* = int(1) shl 3
const
  XkbAX_IndicatorFBMask* = int(1) shl 4
const
  XkbAX_StickyKeysFBMask* = int(1) shl 5
const
  XkbAX_TwoKeysMask* = int(1) shl 6
const
  XkbAX_LatchToLockMask* = int(1) shl 7
const
  XkbAX_SKReleaseFBMask* = int(1) shl 8
const
  XkbAX_SKRejectFBMask* = int(1) shl 9
const
  XkbAX_BKRejectFBMask* = int(1) shl 10
const
  XkbAX_DumbBellFBMask* = int(1) shl 11
const
  XkbAX_FBOptionsMask* = 0x00000F3F
const
  XkbAX_SKOptionsMask* = 0x000000C0
const
  XkbAX_AllOptionsMask* = 0x00000FFF #
                                     #      XkbUseCoreKbd is used to specify the core keyboard without having
                                     #                        to look up its X input extension identifier.
                                     #      XkbUseCorePtr is used to specify the core pointer without having
                                     #                        to look up its X input extension identifier.
                                     #      XkbDfltXIClass is used to specify "don't care" any place that the
                                     #                        XKB protocol is looking for an X Input Extension
                                     #                        device class.
                                     #      XkbDfltXIId is used to specify "don't care" any place that the
                                     #                        XKB protocol is looking for an X Input Extension
                                     #                        feedback identifier.
                                     #      XkbAllXIClasses is used to get information about all device indicators,
                                     #                        whether they're part of the indicator feedback class
                                     #                        or the keyboard feedback class.
                                     #      XkbAllXIIds is used to get information about all device indicator
                                     #                        feedbacks without having to list them.
                                     #      XkbXINone is used to indicate that no class or id has been specified.
                                     #      XkbLegalXILedClass(c)  True if 'c' specifies a legal class with LEDs
                                     #      XkbLegalXIBellClass(c) True if 'c' specifies a legal class with bells
                                     #      XkbExplicitXIDevice(d) True if 'd' explicitly specifies a device
                                     #      XkbExplicitXIClass(c)  True if 'c' explicitly specifies a device class
                                     #      XkbExplicitXIId(c)     True if 'i' explicitly specifies a device id
                                     #      XkbSingleXIClass(c)    True if 'c' specifies exactly one device class,
                                     #                             including the default.
                                     #      XkbSingleXIId(i)       True if 'i' specifies exactly one device
                                     #                              identifier, including the default.
                                     #

const
  XkbUseCoreKbd* = 0x00000100
const
  XkbUseCorePtr* = 0x00000200
const
  XkbDfltXIClass* = 0x00000300
const
  XkbDfltXIId* = 0x00000400
const
  XkbAllXIClasses* = 0x00000500
const
  XkbAllXIIds* = 0x00000600
const
  XkbXINone* = 0x0000FF00

