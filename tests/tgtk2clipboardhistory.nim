# Pure history values: deliberately no GTK initialization or clipboard access.
import std/unittest
import gtk2

suite "explicit application clipboard history":
  test "admission, absent vs empty, NUL and UTF-8 validation":
    var history = newClipboardHistory(maxEntries = 3, maxBytes = 4)
    check history.remember("secret", retain = false) == historyDenied
    check history.remember(ClipboardText(), retain = true) == historyUnavailable
    check history.len == 0
    check history.remember(ClipboardText(available: true), retain = true) == historyRecorded
    check history.text(0) == "" and history.byteCount == 0
    check history.remember("λ🙂", retain = true) == historyTooLarge
    expect ValueError: discard history.remember("\0", retain = true)
    expect ValueError: discard history.remember("\xff", retain = true)
    check history.len == 1 and history.text(0) == ""
  test "byte and entry limits, dedup promotion, no alias through getters or copies":
    var history = newClipboardHistory(maxEntries = 3, maxBytes = 6)
    var first = "aa"
    check history.remember(first, retain = true) == historyRecorded
    first[0] = 'x'
    check history.remember("λ", retain = true) == historyRecorded
    check history.remember("bb", retain = true) == historyRecorded
    check history.byteCount == 6
    check history.remember("aa", retain = true) == historyRefreshed
    check history.text(0) == "aa" and history.text(1) == "bb" and history.text(2) == "λ"
    check history.remember("aa", retain = true) == historyRefreshed
    check history.remember("c", retain = true) == historyRecorded
    check history.len == 3 and history.text(2) == "bb" and history.byteCount == 5
    check history.remember("1111", retain = true) == historyRecorded
    check history.len == 2 and history.text(1) == "c" and history.byteCount == 5
    var copied = history
    var value = copied.text(0)
    value[0] = '9'
    copied.forget(0)
    check copied.byteCount == 1 and copied.text(0) == "c"
    check history.len == 2 and history.text(0) == "1111" and history.byteCount == 5
    history.clear()
    check history.len == 0 and history.byteCount == 0 and copied.len == 1
  test "zero byte capacity and invalid values":
    var history = newClipboardHistory(maxEntries = 1, maxBytes = 0)
    check history.remember("", true) == historyRecorded
    check history.remember("x", true) == historyTooLarge
    check history.remember("", true) == historyRefreshed
    expect ValueError: history.forget(-1)
    expect ValueError: discard history.text(1)
    expect ValueError: discard history.restoreText(1, default(Clipboard))
    history.forget(0)
    check history.len == 0
    var uninitialized: ClipboardHistory
    expect ValueError: discard uninitialized.remember("", true)
    expect ValueError: discard newClipboardHistory(maxEntries = 0)
    expect ValueError: discard newClipboardHistory(maxBytes = -1)
    expect ValueError: discard newClipboardHistory(maxBytes = high(int))
