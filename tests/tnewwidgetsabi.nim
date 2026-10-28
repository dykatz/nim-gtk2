# Optional developer check requiring pkg-config and GTK2 development headers.
# Compiles the header probe in a separate C translation unit, so GTK prototypes
# cannot conflict with Nim's header-free opaque handles. Does not need a display.
import std/unittest
import gtk2 as gtk
import glib2 as g

{.passC: staticExec("pkg-config --cflags gtk+-2.0").}
{.compile: "new_widget_abi.c".}
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
  test "public struct sizes, offsets and enum widths match C":
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
    check sortTypeSize() == csize_t(sizeof(gtk.TSortType))
    check sortDescending() == cint(gtk.SORT_DESCENDING)
    check wrapModeSize() == csize_t(sizeof(gtk.TWrapMode))
    check wrapWordChar() == cint(gtk.WRAP_WORD_CHAR)
    check imageGIcon() == cint(ord(gtk.IMAGE_GICON))
    check messageOther() == cint(ord(gtk.MESSAGE_OTHER))
  test "C invokes cdecl callbacks with the expected arguments and results":
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
