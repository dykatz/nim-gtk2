# Optional developer check requiring pkg-config and GTK2 development headers.
# Compiles the header probe in a separate C translation unit, so GTK prototypes
# cannot conflict with Nim's header-free opaque handles. Does not need a display.
import std/unittest
import headers/gtk2 as gtk
import headers/glib2 as g
import headers/gdk2pixbuf as pb
import headers/gdk2 as gd except string
from headers/gdk2 import TColor, TEventExpose, TEventSelection, TNativeWindow, TAtom, TEventKey, TEventButton, TEventMotion, TEventScroll, TScrollDirection, TDragAction, PDragContext, DAMAGE

when (defined(illumos) or defined(solaris)) and sizeof(pointer) == 8:
  # The default pkg-config directory selects 32-bit glibconfig.h on these OSes.
  {.passC: staticExec("PKG_CONFIG_PATH=/usr/lib/64/pkgconfig:$PKG_CONFIG_PATH pkg-config --cflags gtk+-2.0").}
else:
  {.passC: staticExec("pkg-config --cflags gtk+-2.0").}
{.compile: "new_widget_abi.c".}
type
  EntryProgressValue = proc (entry: gtk.PEntry, value: g.gdouble): g.gdouble {.cdecl.}
  EntryProgressPulse = proc (entry: gtk.PEntry) {.cdecl.}
proc invokeEntryProgress(value: EntryProgressValue, pulse: EntryProgressPulse): g.gboolean {.cdecl, importc: "nim_gtk2_entry_progress_abi".}
type EntryMaskPolicy = proc (entry: gtk.PEntry, value: g.gunichar): g.gunichar {.cdecl.}
proc invokeEntryEditing(mask: EntryMaskPolicy): g.gboolean {.cdecl, importc: "nim_gtk2_entry_editing_abi".}
type EntryIconSignal = proc (entry: gtk.PEntry, position: gtk.TEntryIconPosition,
  event: gd.PEvent, data: pointer) {.cdecl.}
proc invokeEntryIcon(fn: EntryIconSignal): g.gboolean {.cdecl, importc: "nim_gtk2_entry_icon_abi".}
type
  EntryFloatPolicy = proc (entry: gtk.PEntry, value: g.gfloat): g.gfloat {.cdecl.}
  EntryBoolPolicy = proc (entry: gtk.PEntry, value: g.gboolean): g.gboolean {.cdecl.}
proc invokeEntryPolicy(align: EntryFloatPolicy, activate: EntryBoolPolicy): g.gboolean
  {.cdecl, importc: "nim_gtk2_entry_policy_abi".}
type EntrySelectionNotify = proc (instance: g.PGObject, spec: g.PGParamSpec, data: pointer) {.cdecl.}
proc invokeEntrySelectionNotify(fn: EntrySelectionNotify, release: g.TGClosureNotify)
  {.cdecl, importc: "nim_gtk2_entry_selection_notify_abi".}
type EditableBounds = proc (editable: gtk.PEditable, first, last: ptr g.gint): g.gboolean {.cdecl.}
proc invokeEditableBounds(fn: EditableBounds): g.gboolean {.cdecl, importc: "nim_gtk2_editable_selection_abi".}
type CompletionActionSignal = proc (completion: gtk.PEntryCompletion, index: g.gint, data: pointer) {.cdecl.}
proc invokeCompletionAction(fn: CompletionActionSignal) {.cdecl, importc: "nim_gtk2_completion_action_abi".}
proc invokeCompletionMatch(fn: gtk.TEntryCompletionMatchFunc, destroy: g.TGDestroyNotify): g.gboolean
  {.cdecl, importc: "nim_gtk2_completion_match_abi".}
type
  CompletionPrefixSignal = proc (completion: gtk.PEntryCompletion, text: cstring, data: pointer): g.gboolean {.cdecl.}
  CompletionCursorSignal = proc (completion: gtk.PEntryCompletion, model: gtk.PTreeModel,
    iter: gtk.PTreeIter, data: pointer): g.gboolean {.cdecl.}
  CompletionKey = proc (completion: gtk.PEntryCompletion): cstring {.cdecl.}
proc invokeInlineCompletion(prefix: CompletionPrefixSignal, cursor: CompletionCursorSignal,
    key: CompletionKey): g.gboolean {.cdecl, importc: "nim_gtk2_inline_completion_abi".}
type SelectionTarget = proc (data: gtk.PSelectionData): TAtom {.cdecl.}
proc invokeRichClipboard(get: gtk.TClipboardGetFunc, clear: gtk.TClipboardClearFunc,
    target: SelectionTarget): g.gboolean {.cdecl, importc: "nim_gtk2_rich_clipboard_abi".}
type RawTextDeserialize = proc (registration, content: gtk.PTextBuffer, format: TAtom,
  iter: gtk.PTextIter, bytes: ptr g.guint8, length: g.gsize, error: ptr ptr g.GError): g.gboolean {.cdecl.}
proc invokeTextSerialization(serialize: gtk.TTextBufferSerializeFunc, deserialize: RawTextDeserialize): g.gboolean
  {.cdecl, importc: "nim_gtk2_text_serialization_abi".}
type
  AnchorInsert = proc (buffer: gtk.PTextBuffer, iter: gtk.PTextIter, anchor: gtk.PTextChildAnchor) {.cdecl.}
  AnchorDeleted = proc (anchor: gtk.PTextChildAnchor): g.gboolean {.cdecl.}
proc invokeAnchor(insert: AnchorInsert, deleted: AnchorDeleted): g.gboolean {.cdecl, importc: "nim_gtk2_text_anchor_abi".}
type IconCursor = proc (view: ptr gtk.IconView, path: ptr gtk.PTreePath,
  cell: ptr gtk.PCellRenderer): g.gboolean {.cdecl.}
proc invokeIconCursor(fn: IconCursor): g.gboolean {.cdecl, importc: "nim_gtk2_icon_cursor".}
proc invokeCompare(fn: gtk.TTreeIterCompareFunc, data: pointer): g.gint {.cdecl, importc: "nim_gtk2_model_compare".}
proc invokeVisible(fn: gtk.TTreeModelFilterVisibleFunc, data: pointer): g.gboolean {.cdecl, importc: "nim_gtk2_model_visible".}
proc invokeCell(fn: gtk.TTreeCellDataFunc, data: pointer) {.cdecl, importc: "nim_gtk2_cell_data".}
type CompletionSelected = proc (completion: gtk.PEntryCompletion, model: gtk.PTreeModel,
  iter: gtk.PTreeIter, data: pointer): g.gboolean {.cdecl.}
proc invokeCompletion(fn: CompletionSelected, data: pointer): g.gboolean {.cdecl, importc: "nim_gtk2_completion_selected".}
type
  RadioNew = proc (name, label, tooltip, stock: cstring, value: g.gint): gtk.PRadioAction {.cdecl.}
  RadioChanged = proc (action, current: gtk.PRadioAction, data: pointer) {.cdecl.}
  UILoad = proc (ui: gtk.PUIManager, text: cstring, length: g.gssize, error: ptr ptr g.GError): g.guint {.cdecl.}
proc constructRadio(fn: RadioNew): gtk.PRadioAction {.cdecl, importc: "nim_gtk2_radio_new".}
proc invokeRadioChanged(fn: RadioChanged, data: pointer) {.cdecl, importc: "nim_gtk2_radio_changed".}
proc uiItemSize(): csize_t {.cdecl, importc: "nim_gtk2_ui_item_size".}
proc loadUI(fn: UILoad, ui: gtk.PUIManager): g.guint {.cdecl, importc: "nim_gtk2_ui_load".}
type
  BuilderNew = proc (): gtk.PBuilder {.cdecl.}
  BuilderLoad = proc (builder: gtk.PBuilder, text: cstring, length: g.gsize, error: ptr ptr g.GError): g.guint {.cdecl.}
proc constructBuilder(fn: BuilderNew): gtk.PBuilder {.cdecl, importc: "nim_gtk2_builder_new".}
proc loadBuilder(fn: BuilderLoad, builder: gtk.PBuilder): g.guint {.cdecl, importc: "nim_gtk2_builder_load".}
proc invokeBuilderConnect(fn: gtk.TBuilderConnectFunc, data: pointer) {.cdecl, importc: "nim_gtk2_builder_connect".}
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
  test "Entry progress native prototypes, pointer and gdouble/pulse callback ABI":
    var pulses {.global.} = 0
    proc value(entry: gtk.PEntry, input: g.gdouble): g.gdouble {.cdecl.} =
      doAssert cast[uint](entry) == 0xe1 and input == 0.1234567890123
      0.9876543210123
    proc pulse(entry: gtk.PEntry) {.cdecl.} =
      doAssert cast[uint](entry) == 0xe2
      inc pulses
    check g.toBool(invokeEntryProgress(value, pulse)) and pulses == 1

  test "Entry overwrite/frame/visibility/mask prototypes and 32-bit Unicode scalar ABI":
    proc mask(entry: gtk.PEntry, value: g.gunichar): g.gunichar {.cdecl.} =
      doAssert cast[uint](entry) == 0xb1 and value == 0x1f512
      g.gunichar(0x10ffff)
    check sizeof(g.gunichar) == 4
    check g.toBool(invokeEntryEditing(mask))

  test "Entry icon enum, native prototypes and borrowed GdkEvent pointer ABI":
    proc icon(entry: gtk.PEntry, position: gtk.TEntryIconPosition,
        event: gd.PEvent, data: pointer) {.cdecl.} =
      doAssert cast[uint](entry) == 0xa1 and cast[uint](data) == 0xa2
      doAssert position == gtk.ENTRY_ICON_SECONDARY
      let button = cast[gd.PEventButton](event)
      doAssert button.type == gd.THREE_BUTTON_PRESS
      doAssert button.button == high(g.guint) and button.time == high(g.guint32)
      doAssert button.x == 1.25 and button.y == -2.5 and button.x_root == 123.5
      doAssert button.state == gd.TModifierType(1 shl 2)
    check sizeof(gtk.TEntryIconPosition) == sizeof(g.gint)
    check g.toBool(invokeEntryIcon(icon))

  test "Entry limit/width/alignment/default prototypes, native gfloat and gboolean":
    proc align(entry: gtk.PEntry, value: g.gfloat): g.gfloat {.cdecl.} =
      doAssert cast[uint](entry) == 0x91 and value == 0.25
      g.gfloat(0.75)
    proc activate(entry: gtk.PEntry, value: g.gboolean): g.gboolean {.cdecl.} =
      doAssert cast[uint](entry) == 0x92 and g.gint(value) == -123
      g.gboolean(17)
    check g.toBool(invokeEntryPolicy(align, activate))

  test "Entry selection notify GObject/ParamSpec/data and closure-notify ABI":
    proc notify(instance: g.PGObject, spec: g.PGParamSpec, data: pointer) {.cdecl.} =
      doAssert cast[uint](instance) == 0x81 and cast[uint](spec) == 0x82
      doAssert cast[uint](data) == 0x83
    proc release(data: pointer, closure: g.PGClosure) {.cdecl.} =
      doAssert cast[uint](data) == 0x83 and cast[uint](closure) == 0x84
    invokeEntrySelectionNotify(notify, release)

  test "GtkEditable selection gint outputs/gboolean and cursor/chars prototypes":
    proc bounds(editable: gtk.PEditable, first, last: ptr g.gint): g.gboolean {.cdecl.} =
      doAssert cast[uint](editable) == 0x71
      first[] = -123
      last[] = high(int32)
      g.gboolean(17)
    check g.toBool(invokeEditableBounds(bounds))

  test "completion action signed index, data and native insert/delete prototypes":
    proc action(completion: gtk.PEntryCompletion, index: g.gint, data: pointer) {.cdecl.} =
      doAssert cast[uint](completion) == 0x61 and cast[uint](data) == 0x62
      doAssert index == low(int32)
    invokeCompletionAction(action)

  test "completion predicate key/iter/data, destroy notifier and gboolean ABI":
    proc match(completion: gtk.PEntryCompletion, key: cstring, iter: gtk.PTreeIter,
        data: pointer): g.gboolean {.cdecl.} =
      doAssert cast[uint](completion) == 0x51 and $key == "native-key"
      doAssert cast[uint](iter) == 0x52 and cast[uint](data) == 0x53
      g.gboolean(17)
    proc destroy(data: pointer) {.cdecl.} = doAssert cast[uint](data) == 0x53
    check g.toBool(invokeCompletionMatch(match, destroy))

  test "inline completion prefix/cursor signals and borrowed prefix ABI":
    proc prefix(completion: gtk.PEntryCompletion, text: cstring, data: pointer): g.gboolean {.cdecl.} =
      doAssert cast[uint](completion) == 0x41 and cast[uint](data) == 0x42 and $text == "lambda"
      g.gboolean(17)
    proc cursor(completion: gtk.PEntryCompletion, model: gtk.PTreeModel,
        iter: gtk.PTreeIter, data: pointer): g.gboolean {.cdecl.} =
      doAssert cast[uint](completion) == 0x41 and cast[uint](model) == 0x43
      doAssert cast[uint](iter) == 0x44 and cast[uint](data) == 0x42
      g.gboolean(19)
    proc key(completion: gtk.PEntryCompletion): cstring {.cdecl.} =
      doAssert cast[uint](completion) == 0x41
      "key"
    check g.toBool(invokeInlineCompletion(prefix, cursor, key))

  test "rich clipboard get/clear callbacks and pointer-width target atom ABI":
    proc get(c: gtk.PClipboard, selection: gtk.PSelectionData, info: g.guint, data: pointer) {.cdecl.} =
      doAssert cast[uint](c) == 0x61 and cast[uint](selection) == 0x62
      doAssert info == high(g.guint) and cast[uint](data) == 0x64
    proc clear(c: gtk.PClipboard, data: pointer) {.cdecl.} =
      doAssert cast[uint](c) == 0x61 and cast[uint](data) == 0x64
    proc target(selection: gtk.PSelectionData): TAtom {.cdecl.} =
      doAssert cast[uint](selection) == 0x62
      when sizeof(pointer) == 8: TAtom(0x100000063'u64)
      else: TAtom(0x63)
    check g.toBool(invokeRichClipboard(get, clear, target))

  test "rich text native callback, atom/gsize/gboolean and GError double-pointer ABI":
    proc serialize(registration, content: gtk.PTextBuffer, first, last: gtk.PTextIter,
        length: ptr g.gsize, data: pointer): ptr g.guint8 {.cdecl.} =
      doAssert cast[uint](registration) == 0x51 and cast[uint](content) == 0x52
      doAssert cast[uint](first) == 0x53 and cast[uint](last) == 0x54 and cast[uint](data) == 0x55
      length[] = when sizeof(pointer) == 8: g.gsize(0x100000033'u64) else: g.gsize(0x33)
      cast[ptr g.guint8](0x61)
    proc deserialize(registration, content: gtk.PTextBuffer, format: TAtom,
        iter: gtk.PTextIter, bytes: ptr g.guint8, length: g.gsize, error: ptr ptr g.GError): g.gboolean {.cdecl.} =
      doAssert cast[uint](registration) == 0x51 and cast[uint](content) == 0x52
      doAssert cast[uint](iter) == 0x53 and cast[uint](bytes) == 0x61
      doAssert format == TAtom(length)
      error[] = cast[ptr g.GError](0x71)
      g.gboolean(17)
    check g.toBool(invokeTextSerialization(serialize, deserialize))

  test "text child anchor insert/deleted pointer and gboolean ABI":
    proc insert(buffer: gtk.PTextBuffer, iter: gtk.PTextIter, anchor: gtk.PTextChildAnchor) {.cdecl.} =
      doAssert cast[uint](buffer) == 0x51 and cast[uint](iter) == 0x52 and cast[uint](anchor) == 0x53
    proc deleted(anchor: gtk.PTextChildAnchor): g.gboolean {.cdecl.} =
      g.gbool(cast[uint](anchor) == 0x53)
    check g.toBool(invokeAnchor(insert, deleted))

  test "icon cursor gboolean and pointer-to-pointer ABI":
    proc cursor(view: ptr gtk.IconView, path: ptr gtk.PTreePath, cell: ptr gtk.PCellRenderer): g.gboolean {.cdecl.} =
      path[] = cast[gtk.PTreePath](0x22)
      cell[] = cast[gtk.PCellRenderer](0x23)
      g.gbool(cast[uint](view) == 0x21)
    check g.toBool(invokeIconCursor(cursor))

  test "model comparison, visibility and cell-data native callback ABIs":
    var calls = 0
    proc compare(model: gtk.PTreeModel, a, b: gtk.PTreeIter, data: pointer): g.gint {.cdecl.} =
      if cast[uint](model) == 0x42 and a.stamp == 11 and b.stamp == 22:
        inc cast[ptr int](data)[]
      -123
    proc visible(model: gtk.PTreeModel, iter: gtk.PTreeIter, data: pointer): g.gboolean {.cdecl.} =
      if cast[uint](model) == 0x42 and iter.stamp == 11: inc cast[ptr int](data)[]
      g.gbool(true)
    proc present(column: gtk.PTreeViewColumn, cell: gtk.PCellRenderer,
                 model: gtk.PTreeModel, iter: gtk.PTreeIter, data: pointer) {.cdecl.} =
      if cast[uint](column) == 0x43 and cast[uint](cell) == 0x44 and
          cast[uint](model) == 0x42 and iter.stamp == 11: inc cast[ptr int](data)[]
    check invokeCompare(compare, addr calls) == -123
    check g.toBool(invokeVisible(visible, addr calls))
    invokeCell(present, addr calls)
    check calls == 3

  test "completion match-selected pointer/calling convention and gboolean ABI":
    var called = false
    proc selected(c: gtk.PEntryCompletion, model: gtk.PTreeModel, iter: gtk.PTreeIter, data: pointer): g.gboolean {.cdecl.} =
      cast[ptr bool](data)[] = cast[uint](c) == 0x12 and cast[uint](model) == 0x34 and iter.stamp == 0x123
      g.gbool(true)
    check g.toBool(invokeCompletion(selected, addr called)) and called

  test "radio signed values/changed callback and UIManager C-width flags/gssize":
    let radio = constructRadio(gtk.radio_action_new)
    require radio != nil
    defer: g.g_object_unref(radio)
    check gtk.radio_action_get_current_value(radio) == -123
    var called = false
    proc changed(action, current: gtk.PRadioAction, data: pointer) {.cdecl.} =
      cast[ptr bool](data)[] = cast[uint](action) == 0x12 and cast[uint](current) == 0x34
    invokeRadioChanged(changed, addr called)
    check called and uiItemSize().int == sizeof(gtk.TUIManagerItemType)
    let ui = gtk.ui_manager_new()
    require ui != nil
    defer: g.g_object_unref(ui)
    check loadUI(gtk.ui_manager_add_ui_from_string, ui) != 0

  test "builder opaque constructor, gsize loader and signal connector ABI":
    let builder = constructBuilder(gtk.builder_new)
    require builder != nil
    defer: g.g_object_unref(builder)
    check loadBuilder(gtk.builder_add_from_string, builder) != 0
    var called = false
    proc connector(b: gtk.PBuilder, obj: g.PGObject, signal, handler: cstring,
        connectObject: g.PGObject, flags: g.TGConnectFlags, data: pointer) {.cdecl.} =
      cast[ptr bool](data)[] = cast[uint](b) == 0x12 and cast[uint](obj) == 0x23 and
        $signal == "clicked" and $handler == "handler" and cast[uint](connectObject) == 0x34 and
        flags == (g.G_CONNECT_AFTER or g.G_CONNECT_SWAPPED)
    invokeBuilderConnect(connector, addr called)
    check called

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
