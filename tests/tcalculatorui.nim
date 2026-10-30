# Constructs hidden widgets only; requires a display but never calls run/show.
import std/[strutils, unittest]
import gtk2ui
import headers/gtk2 as rawGtk
import headers/glib2 as g
import ../examples/calculator

proc descendants(widget: rawGtk.PWidget): seq[rawGtk.PWidget] =
  result.add(widget)
  if rawGtk.IS_CONTAINER(widget):
    let children = rawGtk.get_children(cast[rawGtk.PContainer](widget))
    defer: g.free(children)
    var node = children
    while node != nil:
      result.add(descendants(cast[rawGtk.PWidget](node.data)))
      node = node.next

proc press(widgets: seq[rawGtk.PWidget], text: string) =
  for widget in widgets:
    if rawGtk.IS_BUTTON(widget):
      let button = cast[rawGtk.PButton](widget)
      if $rawGtk.get_label(button) == text:
        rawGtk.clicked(button)
        return
  raise newException(ValueError, "Button not found: " & text)

proc display(widgets: seq[rawGtk.PWidget]): rawGtk.PEntry =
  for widget in widgets:
    if rawGtk.IS_ENTRY(widget): return cast[rawGtk.PEntry](widget)
  raise newException(ValueError, "Display not found")

proc hasLabel(widgets: seq[rawGtk.PWidget], fragment: string): bool =
  for widget in widgets:
    if rawGtk.IS_LABEL(widget) and fragment in $rawGtk.get_text(cast[rawGtk.PLabel](widget)):
      return true

gtk2ui.init()
suite "calculator hidden-window integration":
  test "keypad, Enter, memory, errors, mode switches and history":
    let window = newCalculatorWindow()
    defer: window.destroy()
    let widgets = descendants(cast[rawGtk.PWidget](window.raw))
    let entry = widgets.display()
    for key in ["2", "+", "3", "×", "4", "="]: widgets.press(key)
    check $rawGtk.get_text(entry) == "14"
    widgets.press("MS")
    widgets.press("C")
    widgets.press("MR")
    widgets.press("=")
    check $rawGtk.get_text(entry) == "14"
    widgets.press("M+")
    widgets.press("C")
    widgets.press("MR")
    widgets.press("=")
    check $rawGtk.get_text(entry) == "28"
    widgets.press("MC")
    check widgets.hasLabel("Memory: empty")
    widgets.press("C")
    widgets.press("MR")
    check widgets.hasLabel("Error: Memory is empty")
    rawGtk.set_text(entry, "2+")
    # Put the cursor at the end, as ordinary keyboard input would.
    rawGtk.set_position(cast[rawGtk.PEditable](entry), -1)
    widgets.press("3")
    widgets.press("=")
    check $rawGtk.get_text(entry) == "5"
    rawGtk.set_text(entry, "sin(30)")
    g.g_signal_emit_by_name(cast[pointer](entry), "activate")
    check $rawGtk.get_text(entry) == "0.5"
    rawGtk.set_text(entry, "1/0")
    widgets.press("=")
    check widgets.hasLabel("Error: Cannot divide by zero")
    check $rawGtk.get_text(entry) == "1/0"
    widgets.press("Scientific")
    widgets.press("Basic")
    widgets.press("Degrees")
    rawGtk.set_text(entry, "cos(pi)")
    widgets.press("=")
    check $rawGtk.get_text(entry) == "-1"
    widgets.press("Previous")
    check $rawGtk.get_text(entry) == "sin(30)"
    widgets.press("Next")
    check $rawGtk.get_text(entry) == "cos(pi)"
    widgets.press("Clear History")
    widgets.press("Previous")
    check widgets.hasLabel("No previous calculations")
