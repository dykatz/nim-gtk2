# Included by headers/gdk2.nim; do not import directly.
const
  KEY_VoidSymbol* = 0x00FFFFFF
const
  KEY_BackSpace* = 0x0000FF08
const
  KEY_Tab* = 0x0000FF09
const
  KEY_Linefeed* = 0x0000FF0A
const
  KEY_Clear* = 0x0000FF0B
const
  KEY_Return* = 0x0000FF0D
const
  KEY_Pause* = 0x0000FF13
const
  KEY_Scroll_Lock* = 0x0000FF14
const
  KEY_Sys_Req* = 0x0000FF15
const
  KEY_Escape* = 0x0000FF1B
const
  KEY_Delete* = 0x0000FFFF
const
  KEY_Multi_key* = 0x0000FF20
const
  KEY_Codeinput* = 0x0000FF37
const
  KEY_SingleCandidate* = 0x0000FF3C
const
  KEY_MultipleCandidate* = 0x0000FF3D
const
  KEY_PreviousCandidate* = 0x0000FF3E
const
  KEY_Kanji* = 0x0000FF21
const
  KEY_Muhenkan* = 0x0000FF22
const
  KEY_Henkan_Mode* = 0x0000FF23
const
  KEY_Henkan* = 0x0000FF23
const
  KEY_Romaji* = 0x0000FF24
const
  KEY_Hiragana* = 0x0000FF25
const
  KEY_Katakana* = 0x0000FF26
const
  KEY_Hiragana_Katakana* = 0x0000FF27
const
  KEY_Zenkaku* = 0x0000FF28
const
  KEY_Hankaku* = 0x0000FF29
const
  KEY_Zenkaku_Hankaku* = 0x0000FF2A
const
  KEY_Touroku* = 0x0000FF2B
const
  KEY_Massyo* = 0x0000FF2C
const
  KEY_Kana_Lock* = 0x0000FF2D
const
  KEY_Kana_Shift* = 0x0000FF2E
const
  KEY_Eisu_Shift* = 0x0000FF2F
const
  KEY_Eisu_toggle* = 0x0000FF30
const
  KEY_Kanji_Bangou* = 0x0000FF37
const
  KEY_Zen_Koho* = 0x0000FF3D
const
  KEY_Mae_Koho* = 0x0000FF3E
const
  KEY_Home* = 0x0000FF50
const
  KEY_Left* = 0x0000FF51
const
  KEY_Up* = 0x0000FF52
const
  KEY_Right* = 0x0000FF53
const
  KEY_Down* = 0x0000FF54
const
  KEY_Prior* = 0x0000FF55
const
  KEY_Page_Up* = 0x0000FF55
const
  KEY_Next* = 0x0000FF56
const
  KEY_Page_Down* = 0x0000FF56
const
  KEY_End* = 0x0000FF57
const
  KEY_Begin* = 0x0000FF58
const
  KEY_Select* = 0x0000FF60
const
  KEY_Print* = 0x0000FF61
const
  KEY_Execute* = 0x0000FF62
const
  KEY_Insert* = 0x0000FF63
const
  KEY_Undo* = 0x0000FF65
const
  KEY_Redo* = 0x0000FF66
const
  KEY_Menu* = 0x0000FF67
const
  KEY_Find* = 0x0000FF68
const
  KEY_Cancel* = 0x0000FF69
const
  KEY_Help* = 0x0000FF6A
const
  KEY_Break* = 0x0000FF6B
const
  KEY_Mode_switch* = 0x0000FF7E
const
  KEY_script_switch* = 0x0000FF7E
const
  KEY_Num_Lock* = 0x0000FF7F
const
  KEY_KP_Space* = 0x0000FF80
const
  KEY_KP_Tab* = 0x0000FF89
const
  KEY_KP_Enter* = 0x0000FF8D
const
  KEY_KP_F1* = 0x0000FF91
const
  KEY_KP_F2* = 0x0000FF92
const
  KEY_KP_F3* = 0x0000FF93
const
  KEY_KP_F4* = 0x0000FF94
const
  KEY_KP_Home* = 0x0000FF95
const
  KEY_KP_Left* = 0x0000FF96
const
  KEY_KP_Up* = 0x0000FF97
const
  KEY_KP_Right* = 0x0000FF98
const
  KEY_KP_Down* = 0x0000FF99
const
  KEY_KP_Prior* = 0x0000FF9A
const
  KEY_KP_Page_Up* = 0x0000FF9A
const
  KEY_KP_Next* = 0x0000FF9B
const
  KEY_KP_Page_Down* = 0x0000FF9B
const
  KEY_KP_End* = 0x0000FF9C
const
  KEY_KP_Begin* = 0x0000FF9D
const
  KEY_KP_Insert* = 0x0000FF9E
const
  KEY_KP_Delete* = 0x0000FF9F
const
  KEY_KP_Equal* = 0x0000FFBD
const
  KEY_KP_Multiply* = 0x0000FFAA
const
  KEY_KP_Add* = 0x0000FFAB
const
  KEY_KP_Separator* = 0x0000FFAC
const
  KEY_KP_Subtract* = 0x0000FFAD
const
  KEY_KP_Decimal* = 0x0000FFAE
const
  KEY_KP_Divide* = 0x0000FFAF
const
  KEY_KP_0* = 0x0000FFB0
const
  KEY_KP_1* = 0x0000FFB1
const
  KEY_KP_2* = 0x0000FFB2
const
  KEY_KP_3* = 0x0000FFB3
const
  KEY_KP_4* = 0x0000FFB4
const
  KEY_KP_5* = 0x0000FFB5
const
  KEY_KP_6* = 0x0000FFB6
const
  KEY_KP_7* = 0x0000FFB7
const
  KEY_KP_8* = 0x0000FFB8
const
  KEY_KP_9* = 0x0000FFB9
const
  KEY_F1* = 0x0000FFBE
const
  KEY_F2* = 0x0000FFBF
const
  KEY_F3* = 0x0000FFC0
const
  KEY_F4* = 0x0000FFC1
const
  KEY_F5* = 0x0000FFC2
const
  KEY_F6* = 0x0000FFC3
const
  KEY_F7* = 0x0000FFC4
const
  KEY_F8* = 0x0000FFC5
const
  KEY_F9* = 0x0000FFC6
const
  KEY_F10* = 0x0000FFC7
const
  KEY_F11* = 0x0000FFC8
const
  KEY_L1* = 0x0000FFC8
const
  KEY_F12* = 0x0000FFC9
const
  KEY_L2* = 0x0000FFC9
const
  KEY_F13* = 0x0000FFCA
const
  KEY_L3* = 0x0000FFCA
const
  KEY_F14* = 0x0000FFCB
const
  KEY_L4* = 0x0000FFCB
const
  KEY_F15* = 0x0000FFCC
const
  KEY_L5* = 0x0000FFCC
const
  KEY_F16* = 0x0000FFCD
const
  KEY_L6* = 0x0000FFCD
const
  KEY_F17* = 0x0000FFCE
const
  KEY_L7* = 0x0000FFCE
const
  KEY_F18* = 0x0000FFCF
const
  KEY_L8* = 0x0000FFCF
const
  KEY_F19* = 0x0000FFD0
const
  KEY_L9* = 0x0000FFD0
const
  KEY_F20* = 0x0000FFD1
const
  KEY_L10* = 0x0000FFD1
const
  KEY_F21* = 0x0000FFD2
const
  KEY_R1* = 0x0000FFD2
const
  KEY_F22* = 0x0000FFD3
const
  KEY_R2* = 0x0000FFD3
const
  KEY_F23* = 0x0000FFD4
const
  KEY_R3* = 0x0000FFD4
const
  KEY_F24* = 0x0000FFD5
const
  KEY_R4* = 0x0000FFD5
const
  KEY_F25* = 0x0000FFD6
const
  KEY_R5* = 0x0000FFD6
const
  KEY_F26* = 0x0000FFD7
const
  KEY_R6* = 0x0000FFD7
const
  KEY_F27* = 0x0000FFD8
const
  KEY_R7* = 0x0000FFD8
const
  KEY_F28* = 0x0000FFD9
const
  KEY_R8* = 0x0000FFD9
const
  KEY_F29* = 0x0000FFDA
const
  KEY_R9* = 0x0000FFDA
const
  KEY_F30* = 0x0000FFDB
const
  KEY_R10* = 0x0000FFDB
const
  KEY_F31* = 0x0000FFDC
const
  KEY_R11* = 0x0000FFDC
const
  KEY_F32* = 0x0000FFDD
const
  KEY_R12* = 0x0000FFDD
const
  KEY_F33* = 0x0000FFDE
const
  KEY_R13* = 0x0000FFDE
const
  KEY_F34* = 0x0000FFDF
const
  KEY_R14* = 0x0000FFDF
const
  KEY_F35* = 0x0000FFE0
const
  KEY_R15* = 0x0000FFE0
const
  KEY_Shift_L* = 0x0000FFE1
const
  KEY_Shift_R* = 0x0000FFE2
const
  KEY_Control_L* = 0x0000FFE3
const
  KEY_Control_R* = 0x0000FFE4
const
  KEY_Caps_Lock* = 0x0000FFE5
const
  KEY_Shift_Lock* = 0x0000FFE6
const
  KEY_Meta_L* = 0x0000FFE7
const
  KEY_Meta_R* = 0x0000FFE8
const
  KEY_Alt_L* = 0x0000FFE9
const
  KEY_Alt_R* = 0x0000FFEA
const
  KEY_Super_L* = 0x0000FFEB
const
  KEY_Super_R* = 0x0000FFEC
const
  KEY_Hyper_L* = 0x0000FFED
const
  KEY_Hyper_R* = 0x0000FFEE
const
  KEY_ISO_Lock* = 0x0000FE01
const
  KEY_ISO_Level2_Latch* = 0x0000FE02
const
  KEY_ISO_Level3_Shift* = 0x0000FE03
const
  KEY_ISO_Level3_Latch* = 0x0000FE04
const
  KEY_ISO_Level3_Lock* = 0x0000FE05
const
  KEY_ISO_Group_Shift* = 0x0000FF7E
const
  KEY_ISO_Group_Latch* = 0x0000FE06
const
  KEY_ISO_Group_Lock* = 0x0000FE07
const
  KEY_ISO_Next_Group* = 0x0000FE08
const
  KEY_ISO_Next_Group_Lock* = 0x0000FE09
const
  KEY_ISO_Prev_Group* = 0x0000FE0A
const
  KEY_ISO_Prev_Group_Lock* = 0x0000FE0B
const
  KEY_ISO_First_Group* = 0x0000FE0C
const
  KEY_ISO_First_Group_Lock* = 0x0000FE0D
const
  KEY_ISO_Last_Group* = 0x0000FE0E
const
  KEY_ISO_Last_Group_Lock* = 0x0000FE0F
const
  KEY_ISO_Left_Tab* = 0x0000FE20
const
  KEY_ISO_Move_Line_Up* = 0x0000FE21
const
  KEY_ISO_Move_Line_Down* = 0x0000FE22
const
  KEY_ISO_Partial_Line_Up* = 0x0000FE23
const
  KEY_ISO_Partial_Line_Down* = 0x0000FE24
const
  KEY_ISO_Partial_Space_Left* = 0x0000FE25
const
  KEY_ISO_Partial_Space_Right* = 0x0000FE26
const
  KEY_ISO_Set_Margin_Left* = 0x0000FE27
const
  KEY_ISO_Set_Margin_Right* = 0x0000FE28
const
  KEY_ISO_Release_Margin_Left* = 0x0000FE29
const
  KEY_ISO_Release_Margin_Right* = 0x0000FE2A
const
  KEY_ISO_Release_Both_Margins* = 0x0000FE2B
const
  KEY_ISO_Fast_Cursor_Left* = 0x0000FE2C
const
  KEY_ISO_Fast_Cursor_Right* = 0x0000FE2D
const
  KEY_ISO_Fast_Cursor_Up* = 0x0000FE2E
const
  KEY_ISO_Fast_Cursor_Down* = 0x0000FE2F
const
  KEY_ISO_Continuous_Underline* = 0x0000FE30
const
  KEY_ISO_Discontinuous_Underline* = 0x0000FE31
const
  KEY_ISO_Emphasize* = 0x0000FE32
const
  KEY_ISO_Center_Object* = 0x0000FE33
const
  KEY_ISO_Enter* = 0x0000FE34
const
  KEY_dead_grave* = 0x0000FE50
const
  KEY_dead_acute* = 0x0000FE51
const
  KEY_dead_circumflex* = 0x0000FE52
const
  KEY_dead_tilde* = 0x0000FE53
const
  KEY_dead_macron* = 0x0000FE54
const
  KEY_dead_breve* = 0x0000FE55
const
  KEY_dead_abovedot* = 0x0000FE56
const
  KEY_dead_diaeresis* = 0x0000FE57
const
  KEY_dead_abovering* = 0x0000FE58
const
  KEY_dead_doubleacute* = 0x0000FE59
const
  KEY_dead_caron* = 0x0000FE5A
const
  KEY_dead_cedilla* = 0x0000FE5B
const
  KEY_dead_ogonek* = 0x0000FE5C
const
  KEY_dead_iota* = 0x0000FE5D
const
  KEY_dead_voiced_sound* = 0x0000FE5E
const
  KEY_dead_semivoiced_sound* = 0x0000FE5F
const
  KEY_dead_belowdot* = 0x0000FE60
const
  KEY_First_Virtual_Screen* = 0x0000FED0
const
  KEY_Prev_Virtual_Screen* = 0x0000FED1
const
  KEY_Next_Virtual_Screen* = 0x0000FED2
const
  KEY_Last_Virtual_Screen* = 0x0000FED4
const
  KEY_Terminate_Server* = 0x0000FED5
const
  KEY_AccessX_Enable* = 0x0000FE70
const
  KEY_AccessX_Feedback_Enable* = 0x0000FE71
const
  KEY_RepeatKeys_Enable* = 0x0000FE72
const
  KEY_SlowKeys_Enable* = 0x0000FE73
const
  KEY_BounceKeys_Enable* = 0x0000FE74
const
  KEY_StickyKeys_Enable* = 0x0000FE75
const
  KEY_MouseKeys_Enable* = 0x0000FE76
const
  KEY_MouseKeys_Accel_Enable* = 0x0000FE77
const
  KEY_Overlay1_Enable* = 0x0000FE78
const
  KEY_Overlay2_Enable* = 0x0000FE79
const
  KEY_AudibleBell_Enable* = 0x0000FE7A
const
  KEY_Pointer_Left* = 0x0000FEE0
const
  KEY_Pointer_Right* = 0x0000FEE1
const
  KEY_Pointer_Up* = 0x0000FEE2
const
  KEY_Pointer_Down* = 0x0000FEE3
const
  KEY_Pointer_UpLeft* = 0x0000FEE4
const
  KEY_Pointer_UpRight* = 0x0000FEE5
const
  KEY_Pointer_DownLeft* = 0x0000FEE6
const
  KEY_Pointer_DownRight* = 0x0000FEE7
const
  KEY_Pointer_Button_Dflt* = 0x0000FEE8
const
  KEY_Pointer_Button1* = 0x0000FEE9
const
  KEY_Pointer_Button2* = 0x0000FEEA
const
  KEY_Pointer_Button3* = 0x0000FEEB
const
  KEY_Pointer_Button4* = 0x0000FEEC
const
  KEY_Pointer_Button5* = 0x0000FEED
const
  KEY_Pointer_DblClick_Dflt* = 0x0000FEEE
const
  KEY_Pointer_DblClick1* = 0x0000FEEF
const
  KEY_Pointer_DblClick2* = 0x0000FEF0
const
  KEY_Pointer_DblClick3* = 0x0000FEF1
const
  KEY_Pointer_DblClick4* = 0x0000FEF2
const
  KEY_Pointer_DblClick5* = 0x0000FEF3
const
  KEY_Pointer_Drag_Dflt* = 0x0000FEF4
const
  KEY_Pointer_Drag1* = 0x0000FEF5
const
  KEY_Pointer_Drag2* = 0x0000FEF6
const
  KEY_Pointer_Drag3* = 0x0000FEF7
const
  KEY_Pointer_Drag4* = 0x0000FEF8
const
  KEY_Pointer_Drag5* = 0x0000FEFD
const
  KEY_Pointer_EnableKeys* = 0x0000FEF9
const
  KEY_Pointer_Accelerate* = 0x0000FEFA
const
  KEY_Pointer_DfltBtnNext* = 0x0000FEFB
const
  KEY_Pointer_DfltBtnPrev* = 0x0000FEFC
const
  KEY_3270_Duplicate* = 0x0000FD01
const
  KEY_3270_FieldMark* = 0x0000FD02
const
  KEY_3270_Right2* = 0x0000FD03
const
  KEY_3270_Left2* = 0x0000FD04
const
  KEY_3270_BackTab* = 0x0000FD05
const
  KEY_3270_EraseEOF* = 0x0000FD06
const
  KEY_3270_EraseInput* = 0x0000FD07
const
  KEY_3270_Reset* = 0x0000FD08
const
  KEY_3270_Quit* = 0x0000FD09
const
  KEY_3270_PA1* = 0x0000FD0A
const
  KEY_3270_PA2* = 0x0000FD0B
const
  KEY_3270_PA3* = 0x0000FD0C
const
  KEY_3270_Test* = 0x0000FD0D
const
  KEY_3270_Attn* = 0x0000FD0E
const
  KEY_3270_CursorBlink* = 0x0000FD0F
const
  KEY_3270_AltCursor* = 0x0000FD10
const
  KEY_3270_KeyClick* = 0x0000FD11
const
  KEY_3270_Jump* = 0x0000FD12
const
  KEY_3270_Ident* = 0x0000FD13
const
  KEY_3270_Rule* = 0x0000FD14
const
  KEY_3270_Copy* = 0x0000FD15
const
  KEY_3270_Play* = 0x0000FD16
const
  KEY_3270_Setup* = 0x0000FD17
const
  KEY_3270_Record* = 0x0000FD18
const
  KEY_3270_ChangeScreen* = 0x0000FD19
const
  KEY_3270_DeleteWord* = 0x0000FD1A
const
  KEY_3270_ExSelect* = 0x0000FD1B
const
  KEY_3270_CursorSelect* = 0x0000FD1C
const
  KEY_3270_PrintScreen* = 0x0000FD1D
const
  KEY_3270_Enter* = 0x0000FD1E
const
  KEY_space* = 0x00000020
const
  KEY_exclam* = 0x00000021
const
  KEY_quotedbl* = 0x00000022
const
  KEY_numbersign* = 0x00000023
const
  KEY_dollar* = 0x00000024
const
  KEY_percent* = 0x00000025
const
  KEY_ampersand* = 0x00000026
const
  KEY_apostrophe* = 0x00000027
const
  KEY_quoteright* = 0x00000027
const
  KEY_parenleft* = 0x00000028
const
  KEY_parenright* = 0x00000029
const
  KEY_asterisk* = 0x0000002A
const
  KEY_plus* = 0x0000002B
const
  KEY_comma* = 0x0000002C
const
  KEY_minus* = 0x0000002D
const
  KEY_period* = 0x0000002E
const
  KEY_slash* = 0x0000002F
const
  KEY_0* = 0x00000030
const
  KEY_1* = 0x00000031
const
  KEY_2* = 0x00000032
const
  KEY_3* = 0x00000033
const
  KEY_4* = 0x00000034
const
  KEY_5* = 0x00000035
const
  KEY_6* = 0x00000036
const
  KEY_7* = 0x00000037
const
  KEY_8* = 0x00000038
const
  KEY_9* = 0x00000039
const
  KEY_colon* = 0x0000003A
const
  KEY_semicolon* = 0x0000003B
const
  KEY_less* = 0x0000003C
const
  KEY_equal* = 0x0000003D
const
  KEY_greater* = 0x0000003E
const
  KEY_question* = 0x0000003F
const
  KEY_at* = 0x00000040
