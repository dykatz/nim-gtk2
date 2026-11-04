# Optional developer check requiring pkg-config and GTK2 development headers.
# Compiles the header probe in a separate C translation unit, so GTK prototypes
# cannot conflict with Nim's header-free opaque handles. Does not need a display.
import std/unittest
import headers/gtk2 as gtk
import headers/glib2 as g
import headers/gdk2pixbuf as pb
from headers/gdk2 import TColor, TEventExpose, TEventSelection, TNativeWindow, TAtom, TEventKey, TEventButton, TEventMotion, TEventScroll, TScrollDirection, TDragAction, PDragContext, DAMAGE

when (defined(illumos) or defined(solaris)) and sizeof(pointer) == 8:
  # The default pkg-config directory selects 32-bit glibconfig.h on these OSes.
  {.passC: staticExec("PKG_CONFIG_PATH=/usr/lib/64/pkgconfig:$PKG_CONFIG_PATH pkg-config --cflags gtk+-2.0").}
else:
  {.passC: staticExec("pkg-config --cflags gtk+-2.0").}
{.compile: "new_widget_abi.c".}
type
  ActionNew = proc (name, label, tooltip, stock: cstring): gtk.PAction {.cdecl.}
  ActionGetBool = proc (action: gtk.PAction): g.gboolean {.cdecl.}
  ActionSetBool = proc (action: gtk.PAction, value: g.gboolean) {.cdecl.}
proc constructAction(fn: ActionNew): gtk.PAction {.cdecl, importc: "nim_gtk2_action_new".}
proc getActionBool(fn: ActionGetBool, action: gtk.PAction): g.gboolean {.cdecl, importc: "nim_gtk2_action_get_bool".}
proc setActionBool(fn: ActionSetBool, action: gtk.PAction, value: g.gboolean) {.cdecl, importc: "nim_gtk2_action_set_bool".}
proc targetEntrySize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_target_entry".}
proc targetInfoOffset(): csize_t {.cdecl, importc: "nim_gtk2_target_entry_info_offset".}
proc selectionDataSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_selection_data".}
proc selectionLengthOffset(): csize_t {.cdecl, importc: "nim_gtk2_selection_data_length_offset".}
proc destDefaultsSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_dest_defaults".}
proc dragActionSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_drag_action".}
proc invokeClipboardText(fn: gtk.TClipboardTextReceivedFunc, data: pointer) {.cdecl, importc: "nim_gtk2_invoke_clipboard_text".}
proc invokeClipboardContents(fn: gtk.TClipboardReceivedFunc, data: pointer) {.cdecl, importc: "nim_gtk2_invoke_clipboard_contents".}
type DropFunc = proc (widget: gtk.PWidget, context: PDragContext, x, y: g.gint, time: g.guint32, data: pointer): g.gboolean {.cdecl.}
proc invokeDrop(fn: DropFunc, data: pointer): g.gboolean {.cdecl, importc: "nim_gtk2_invoke_drop".}
proc eventKeySize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_event_key".}
proc eventKeyCodeOffset(): csize_t {.cdecl, importc: "nim_gtk2_event_key_code_offset".}
proc eventButtonSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_event_button".}
proc eventButtonStateOffset(): csize_t {.cdecl, importc: "nim_gtk2_event_button_state_offset".}
proc eventMotionSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_event_motion".}
proc eventMotionHintOffset(): csize_t {.cdecl, importc: "nim_gtk2_event_motion_hint_offset".}
proc eventScrollSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_event_scroll".}
proc eventScrollDirectionOffset(): csize_t {.cdecl, importc: "nim_gtk2_event_scroll_direction_offset".}
proc scrollDirectionSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_scroll_direction".}
proc searchVisibleFlag(): cint {.cdecl, importc: "nim_gtk2_search_visible_flag".}
proc searchTextFlag(): cint {.cdecl, importc: "nim_gtk2_search_text_flag".}
proc atomSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_atom".}
proc miscSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_misc".}
proc miscPaddingWidth(): csize_t {.cdecl, importc: "nim_gtk2_misc_padding_width".}
proc nativeWindowSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_native_window".}
proc selectionSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_event_selection".}
proc requestorOffset(): csize_t {.cdecl, importc: "nim_gtk2_requestor_offset".}
proc statusIconSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_status_icon".}
proc statusIconClassSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_status_icon_class".}
proc invisibleSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_invisible".}
proc invisibleClassSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_invisible_class".}
when defined(posix) and not defined(macosx):
  proc plugSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_plug".}
  proc plugClassSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_plug_class".}
  proc socketSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_socket".}
  proc socketClassSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_socket_class".}
type StatusPopupFunc = proc (icon: gtk.PStatusIcon, button: g.guint, time: g.guint32, data: pointer) {.cdecl.}
proc invokeStatusPopup(fn: StatusPopupFunc, data: pointer) {.cdecl, importc: "nim_gtk2_invoke_status_popup".}
proc printUnitSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_print_unit".}
proc pageOrientationSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_page_orientation".}
proc printPagesSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_print_pages".}
proc pageSetSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_page_set".}
proc printDuplexSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_print_duplex".}
proc printQualitySize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_print_quality".}
proc unitMillimeters(): cint {.cdecl, importc: "nim_gtk2_unit_mm".}
proc printSelectionValue(): cint {.cdecl, importc: "nim_gtk2_print_selection".}
proc invokePrintSettings(fn: gtk.PrintSettingsFunc, data: pointer) {.cdecl, importc: "nim_gtk2_invoke_print_settings".}
proc requisitionSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_requisition".}
proc requisitionHeight(): csize_t {.cdecl, importc: "nim_gtk2_requisition_height_offset".}
proc exposeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_event_expose".}
proc exposeArea(): csize_t {.cdecl, importc: "nim_gtk2_event_expose_area_offset".}
proc damageValue(): cint {.cdecl, importc: "nim_gtk2_damage_value".}
type HsvConvert = proc (h, s, v: g.gdouble, r, green, b: ptr g.gdouble) {.cdecl.}
proc invokeHSV(fn: HsvConvert): cint {.cdecl, importc: "nim_gtk2_invoke_hsv_convert".}
proc fileActionSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_file_chooser_action".}
proc fileErrorSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_file_chooser_error".}
proc fileFlagsSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_file_filter_flags".}
proc fileInfoSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_file_filter_info".}
proc fileMimeOffset(): csize_t {.cdecl, importc: "nim_gtk2_file_filter_mime_offset".}
proc fileButtonSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_file_chooser_button".}
proc fileButtonClassSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_file_chooser_button_class".}
proc invokeFileFilter(fn: gtk.TFileFilterFunc, data: pointer): g.gboolean {.cdecl, importc: "nim_gtk2_invoke_file_filter".}
proc glibSizeWidth(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_gsize".}
proc glibTypeWidth(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_gtype".}
proc objectClassSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_gobject_class".}
proc assistantPageTypeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_assistant_page_type".}
proc assistantProgress(): cint {.cdecl, importc: "nim_gtk2_assistant_progress".}
proc colorSelectionSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_color_selection".}
proc colorSelectionClassSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_color_selection_class".}
proc colorSelectionDialogSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_color_selection_dialog".}
proc colorSelectionDialogClassSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_color_selection_dialog_class".}
proc fontSelectionSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_font_selection".}
proc fontSelectionClassSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_font_selection_class".}
proc fontSelectionDialogSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_font_selection_dialog".}
proc fontSelectionDialogClassSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_font_selection_dialog_class".}
proc layoutSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_layout".}
proc layoutClassSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_layout_class".}
proc handleboxSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_handlebox".}
proc handleboxClassSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_handlebox_class".}
proc layoutExtentWidth(): csize_t {.cdecl, importc: "nim_gtk2_layout_extent_width".}
proc automaticSnapEdge(): cint {.cdecl, importc: "nim_gtk2_automatic_snap_edge".}
type HandleChildFunc = proc (box: gtk.PHandleBox, child: gtk.PWidget, data: pointer) {.cdecl.}
proc invokeHandleChild(fn: HandleChildFunc, data: pointer) {.cdecl, importc: "nim_gtk2_invoke_handle_child".}
proc orientationSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_orientation".}
proc toolbarStyleSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_toolbar_style".}
proc reliefStyleSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_relief_style".}
proc ellipsizeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_ellipsize".}
proc toolbarBothHoriz(): cint {.cdecl, importc: "nim_gtk2_toolbar_both_horiz".}
proc attachOptionsSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_attach_options".}
proc buttonBoxStyleSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_button_box_style".}
proc buttonBoxCenter(): cint {.cdecl, importc: "nim_gtk2_button_box_center".}
proc boxSpacingWidth(): csize_t {.cdecl, importc: "nim_gtk2_box_spacing_width".}
proc tableDimensionWidth(): csize_t {.cdecl, importc: "nim_gtk2_table_dimension_width".}
proc tableSpacingWidth(): csize_t {.cdecl, importc: "nim_gtk2_table_spacing_width".}
proc tablePaddingWidth(): csize_t {.cdecl, importc: "nim_gtk2_table_padding_width".}
proc arrowTypeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_arrow_type".}
proc shadowTypeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_shadow_type".}
proc positionTypeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_position_type".}
proc arrowNone(): cint {.cdecl, importc: "nim_gtk2_arrow_none".}
proc positionBottom(): cint {.cdecl, importc: "nim_gtk2_position_bottom".}
proc colorSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_gdk_color".}
proc colorRedOffset(): csize_t {.cdecl, importc: "nim_gtk2_offset_gdk_color_red".}
proc colorBlueOffset(): csize_t {.cdecl, importc: "nim_gtk2_offset_gdk_color_blue".}
proc calendarOptionsSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_calendar_options".}
proc calendarOptions(): cint {.cdecl, importc: "nim_gtk2_calendar_options".}
proc errorSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_error".}
proc recentDataSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_recent_data".}
proc filterInfoSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_recent_filter_info".}
proc pageRangeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_page_range".}
proc privateOffset(): csize_t {.cdecl, importc: "nim_gtk2_offset_recent_data_private".}
proc ageOffset(): csize_t {.cdecl, importc: "nim_gtk2_offset_recent_filter_age".}
proc messageOffset(): csize_t {.cdecl, importc: "nim_gtk2_offset_error_message".}
proc pageTypeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_page_type".}
proc filterFlagsSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_filter_flags".}
proc imageTypeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_image_type".}
proc messageTypeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_message_type".}
proc buttonsTypeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_buttons_type".}
proc treeIterSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_tree_iter".}
proc treeIterTail(): csize_t {.cdecl, importc: "nim_gtk2_offset_tree_iter_tail".}
proc valueSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_gvalue".}
proc valueDataOffset(): csize_t {.cdecl, importc: "nim_gtk2_offset_gvalue_data".}
proc textIterSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_text_iter".}
proc textIterTail(): csize_t {.cdecl, importc: "nim_gtk2_offset_text_iter_tail".}
proc colorspaceSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_colorspace".}
proc interpolationSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_interpolation".}
proc pixbufErrorSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_pixbuf_error".}
proc alphaModeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_alpha_mode".}
proc incompleteAnimation(): cint {.cdecl, importc: "nim_gtk2_incomplete_animation".}
proc sortTypeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_sort_type".}
proc sortDescending(): cint {.cdecl, importc: "nim_gtk2_sort_descending".}
proc wrapModeSize(): csize_t {.cdecl, importc: "nim_gtk2_sizeof_wrap_mode".}
proc wrapWordChar(): cint {.cdecl, importc: "nim_gtk2_wrap_word_char".}
proc imageGIcon(): cint {.cdecl, importc: "nim_gtk2_image_gicon".}
proc messageOther(): cint {.cdecl, importc: "nim_gtk2_message_other".}
proc invokeAssistant(fn: gtk.AssistantPageFunc, data: pointer): g.gint
  {.cdecl, importc: "nim_gtk2_invoke_assistant".}
proc invokeFilter(fn: gtk.RecentFilterFunc, data: pointer): g.gboolean
  {.cdecl, importc: "nim_gtk2_invoke_filter".}

suite "new raw binding native header ABI":
  test "opaque action constructors and gboolean getter/setter ABI through native C prototypes":
    let action = constructAction(gtk.action_new)
    require action != nil
    defer: g.g_object_unref(action)
    check $gtk.action_get_name(action) == "abi-command"
    check $gtk.action_get_label(action) == "ABI label"
    check g.toBool(getActionBool(gtk.action_get_sensitive, action))
    setActionBool(gtk.action_set_sensitive, action, g.gbool(false))
    check not g.toBool(getActionBool(gtk.action_get_sensitive, action))

  test "clipboard and drag/drop pointer, struct, flag and callback ABI":
    check targetEntrySize().int == sizeof(gtk.TTargetEntry)
    check targetInfoOffset().int == offsetOf(gtk.TTargetEntry, info)
    check selectionDataSize().int == sizeof(gtk.TSelectionData)
    check selectionLengthOffset().int == offsetOf(gtk.TSelectionData, length)
    check destDefaultsSize().int == sizeof(gtk.TDestDefaults)
    check dragActionSize().int == sizeof(TDragAction)
    var called = false
    proc textCallback(c: gtk.PClipboard, text: cstring, data: pointer) {.cdecl.} =
      cast[ptr bool](data)[] = cast[uint](c) == 0x123 and $text == "copied text"
    invokeClipboardText(textCallback, addr called)
    check called
    proc contentsCallback(c: gtk.PClipboard, data: gtk.PSelectionData, user: pointer) {.cdecl.} =
      cast[ptr bool](user)[] = cast[uint](c) == 0x123 and cast[uint](data) == 0x234
    called = false
    invokeClipboardContents(contentsCallback, addr called)
    check called
    proc dropCallback(w: gtk.PWidget, context: PDragContext, x, y: g.gint, time: g.guint32, data: pointer): g.gboolean {.cdecl.} =
      cast[ptr bool](data)[] = x == -12 and y == 34 and time == 0xfedcba98'u32
      g.gbool(true)
    called = false
    check g.toBool(invokeDrop(dropCallback, addr called)) and called

  test "copied input event layout, C-width scroll enum and text-search flag bits":
    check eventKeySize().int == sizeof(TEventKey)
    check eventKeyCodeOffset().int == offsetOf(TEventKey, hardware_keycode)
    check eventButtonSize().int == sizeof(TEventButton)
    check eventButtonStateOffset().int == offsetOf(TEventButton, state)
    check eventMotionSize().int == sizeof(TEventMotion)
    check eventMotionHintOffset().int == offsetOf(TEventMotion, is_hint)
    check eventScrollSize().int == sizeof(TEventScroll)
    check eventScrollDirectionOffset().int == offsetOf(TEventScroll, direction)
    check scrollDirectionSize().int == sizeof(TScrollDirection)
    check searchVisibleFlag() == gtk.TEXT_SEARCH_VISIBLE_ONLY
    check searchTextFlag() == gtk.TEXT_SEARCH_TEXT_ONLY

  test "desktop native IDs, public instance/class layout and unsigned popup payloads":
    check atomSize().int == sizeof(TAtom)
    check miscSize().int == sizeof(gtk.TMisc)
    check miscPaddingWidth() == 2
    check nativeWindowSize().int == sizeof(TNativeWindow)
    check selectionSize().int == sizeof(TEventSelection)
    check requestorOffset().int == offsetOf(TEventSelection, requestor)
    check statusIconSize().int == sizeof(gtk.TStatusIcon)
    check statusIconClassSize().int == sizeof(gtk.TStatusIconClass)
    check invisibleSize().int == sizeof(gtk.TInvisible)
    check invisibleClassSize().int == sizeof(gtk.TInvisibleClass)
    when defined(posix) and not defined(macosx):
      check plugSize().int == sizeof(gtk.TPlug)
      check plugClassSize().int == sizeof(gtk.TPlugClass)
      check socketSize().int == sizeof(gtk.TSocket)
      check socketClassSize().int == sizeof(gtk.TSocketClass)
    var called = false
    proc callback(icon: gtk.PStatusIcon, button: g.guint, time: g.guint32, data: pointer) {.cdecl.} =
      cast[ptr bool](data)[] = cast[uint](icon) == 0x123 and button == 7 and time == 0xfedcba98'u32
    invokeStatusPopup(callback, addr called)
    check called

  test "print configuration enum widths, values and foreach callback ABI":
    check printUnitSize().int == sizeof(gtk.Unit)
    check pageOrientationSize().int == sizeof(gtk.PageOrientation)
    check printPagesSize().int == sizeof(gtk.PrintPages)
    check pageSetSize().int == sizeof(gtk.PageSet)
    check printDuplexSize().int == sizeof(gtk.PrintDuplex)
    check printQualitySize().int == sizeof(gtk.PrintQuality)
    check unitMillimeters() == gtk.UNIT_MM.cint
    check printSelectionValue() == gtk.PRINT_PAGES_SELECTION.cint
    var called = false
    proc callback(key, value: cstring, data: pointer) {.cdecl, gcsafe.} =
      cast[ptr bool](data)[] = $key == "cups-abi-option" and $value == "copied value"
    invokePrintSettings(callback, addr called)
    check called

  test "display requisitions, damage events and HSV double/out-parameter ABI":
    check requisitionSize().int == sizeof(gtk.TRequisition)
    check requisitionHeight().int == offsetOf(gtk.TRequisition, height)
    check exposeSize().int == sizeof(TEventExpose)
    check exposeArea().int == offsetOf(TEventExpose, area)
    check damageValue() == DAMAGE
    check invokeHSV(gtk.hsv_to_rgb) == 1

  test "public struct sizes, offsets and enum widths match C":
    check glibSizeWidth() == csize_t(sizeof(g.gsize))
    check glibTypeWidth() == csize_t(sizeof(g.GType))
    check objectClassSize() == csize_t(sizeof(g.TGObjectClass))
    check fileActionSize() == csize_t(sizeof(gtk.TFileChooserAction))
    check fileErrorSize() == csize_t(sizeof(gtk.TFileChooserError))
    check fileFlagsSize() == csize_t(sizeof(gtk.TFileFilterFlags))
    check fileInfoSize() == csize_t(sizeof(gtk.TFileFilterInfo))
    check fileMimeOffset() == csize_t(offsetOf(gtk.TFileFilterInfo, mime_type))
    check fileButtonSize() == csize_t(sizeof(typeof(cast[gtk.PFileChooserButton](nil)[])))
    check fileButtonClassSize() == csize_t(sizeof(typeof(cast[gtk.PFileChooserButtonClass](nil)[])))
    check assistantPageTypeSize() == csize_t(sizeof(gtk.AssistantPageType))
    check assistantProgress() == cint(gtk.ASSISTANT_PAGE_PROGRESS)
    check colorSelectionSize() == csize_t(sizeof(gtk.TColorSelection))
    check colorSelectionClassSize() == csize_t(sizeof(gtk.TColorSelectionClass))
    check colorSelectionDialogSize() == csize_t(sizeof(gtk.TColorSelectionDialog))
    check colorSelectionDialogClassSize() == csize_t(sizeof(gtk.TColorSelectionDialogClass))
    check fontSelectionSize() == csize_t(sizeof(gtk.TFontSelection))
    check fontSelectionClassSize() == csize_t(sizeof(gtk.TFontSelectionClass))
    check fontSelectionDialogSize() == csize_t(sizeof(gtk.TFontSelectionDialog))
    check fontSelectionDialogClassSize() == csize_t(sizeof(gtk.TFontSelectionDialogClass))
    check layoutSize() == csize_t(sizeof(gtk.TLayout))
    check layoutClassSize() == csize_t(sizeof(gtk.TLayoutClass))
    check handleboxSize() == csize_t(sizeof(gtk.THandleBox))
    check handleboxClassSize() == csize_t(sizeof(gtk.THandleBoxClass))
    check layoutExtentWidth() == csize_t(sizeof(g.guint))
    check automaticSnapEdge() == -1
    check orientationSize() == csize_t(sizeof(gtk.TOrientation))
    check toolbarStyleSize() == csize_t(sizeof(gtk.TToolbarStyle))
    check reliefStyleSize() == csize_t(sizeof(gtk.TReliefStyle))
    check ellipsizeSize() == csize_t(sizeof(gtk.EllipsizeMode))
    check toolbarBothHoriz() == cint(gtk.TOOLBAR_BOTH_HORIZ)
    check attachOptionsSize() == csize_t(sizeof(gtk.TAttachOptions))
    check buttonBoxStyleSize() == csize_t(sizeof(gtk.TButtonBoxStyle))
    check buttonBoxCenter() == cint(gtk.BUTTONBOX_CENTER)
    check boxSpacingWidth() == csize_t(sizeof(default(gtk.TBox).spacing))
    check tableDimensionWidth() == csize_t(sizeof(default(gtk.TTable).ncols))
    check tableSpacingWidth() == csize_t(sizeof(default(gtk.TTableRowCol).spacing))
    check tablePaddingWidth() == csize_t(sizeof(default(gtk.TTableChild).xpadding))
    check arrowTypeSize() == csize_t(sizeof(gtk.TArrowType))
    check shadowTypeSize() == csize_t(sizeof(gtk.TShadowType))
    check positionTypeSize() == csize_t(sizeof(gtk.TPositionType))
    check arrowNone() == cint(gtk.ARROW_NONE)
    check positionBottom() == cint(gtk.POS_BOTTOM)
    check colorSize() == csize_t(sizeof(TColor))
    check colorRedOffset() == csize_t(offsetOf(TColor, red))
    check colorBlueOffset() == csize_t(offsetOf(TColor, blue))
    check calendarOptionsSize() == csize_t(sizeof(gtk.TCalendarDisplayOptions))
    check calendarOptions() == cint(gtk.CALENDAR_SHOW_HEADING or gtk.CALENDAR_SHOW_DAY_NAMES or
      gtk.CALENDAR_NO_MONTH_CHANGE or gtk.CALENDAR_SHOW_WEEK_NUMBERS or gtk.CALENDAR_SHOW_DETAILS)
    check errorSize() == csize_t(sizeof(g.GError))
    check recentDataSize() == csize_t(sizeof(gtk.RecentData))
    check filterInfoSize() == csize_t(sizeof(gtk.RecentFilterInfo))
    check pageRangeSize() == csize_t(sizeof(gtk.PageRange))
    check privateOffset() == csize_t(offsetOf(gtk.RecentData, is_private))
    check ageOffset() == csize_t(offsetOf(gtk.RecentFilterInfo, age))
    check messageOffset() == csize_t(offsetOf(g.GError, message))
    check pageTypeSize() == csize_t(sizeof(gtk.AssistantPageType))
    check filterFlagsSize() == csize_t(sizeof(gtk.RecentFilterFlags))
    check imageTypeSize() == csize_t(sizeof(gtk.TImageType))
    check messageTypeSize() == csize_t(sizeof(gtk.TMessageType))
    check buttonsTypeSize() == csize_t(sizeof(gtk.TButtonsType))
    check treeIterSize() == csize_t(sizeof(gtk.TTreeIter))
    check treeIterTail() == csize_t(offsetOf(gtk.TTreeIter, user_data3))
    check valueSize() == csize_t(sizeof(g.TGValue))
    check valueDataOffset() == csize_t(offsetOf(g.TGValue, data))
    check textIterSize() == csize_t(sizeof(gtk.TTextIter))
    check textIterTail() == csize_t(offsetOf(gtk.TTextIter, dummy14))
    check colorspaceSize() == csize_t(sizeof(pb.TColorspace))
    check interpolationSize() == csize_t(sizeof(pb.TInterpType))
    check pixbufErrorSize() == csize_t(sizeof(pb.TPixbufError))
    check alphaModeSize() == csize_t(sizeof(pb.TPixbufAlphaMode))
    check incompleteAnimation() == cint(pb.PIXBUF_ERROR_INCOMPLETE_ANIMATION)
    check sortTypeSize() == csize_t(sizeof(gtk.TSortType))
    check sortDescending() == cint(gtk.SORT_DESCENDING)
    check wrapModeSize() == csize_t(sizeof(gtk.TWrapMode))
    check wrapWordChar() == cint(gtk.WRAP_WORD_CHAR)
    check imageGIcon() == cint(ord(gtk.IMAGE_GICON))
    check messageOther() == cint(ord(gtk.MESSAGE_OTHER))
  test "C invokes cdecl callbacks with the expected arguments and results":
    var childCalls = 0
    proc childSignal(box: gtk.PHandleBox, child: gtk.PWidget, data: pointer) {.cdecl.} =
      doAssert cast[uint](box) == 0x123'u
      doAssert cast[uint](child) == 0x456'u
      inc cast[ptr int](data)[]
    invokeHandleChild(childSignal, addr childCalls)
    check childCalls == 1
    var calls = 0
    proc forward(page: g.gint, data: pointer): g.gint {.cdecl, gcsafe.} =
      inc cast[ptr int](data)[]
      page + 2
    check invokeAssistant(forward, addr calls) == 7
    check calls == 1
    proc match(info: ptr gtk.RecentFilterInfo, data: pointer): g.gboolean {.cdecl, gcsafe.} =
      inc cast[ptr int](data)[]
      g.gbool(info.contains == gtk.RECENT_FILTER_URI and
        $info.uri == "file:///abi.txt" and info.age == -1)
    check g.toBool(invokeFilter(match, addr calls))
    check calls == 2
    proc fileMatch(info: gtk.PFileFilterInfo, data: pointer): g.gboolean {.cdecl.} =
      inc cast[ptr int](data)[]
      g.gbool(cint(info.contains) == 15 and $info.filename == "/abi.txt" and
        $info.uri == "file:///abi.txt" and $info.display_name == "abi.txt" and $info.mime_type == "text/plain")
    check g.toBool(invokeFileFilter(fileMatch, addr calls))
    check calls == 3
