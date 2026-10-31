# Requires a display. Menu trees remain hidden; never popup a menu or tearoff.
import std/unittest
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert typeof(newMenuBar().raw) is rawGtk.PMenuBar
  doAssert typeof(newMenu().raw) is rawGtk.PMenu
  doAssert typeof(newMenuItem().raw) is rawGtk.PMenuItem
  doAssert typeof(newCheckMenuItem().raw) is rawGtk.PCheckMenuItem
  doAssert typeof(newRadioMenuItem().raw) is rawGtk.PRadioMenuItem
  doAssert typeof(newImageMenuItem().raw) is rawGtk.PImageMenuItem
  doAssert typeof(newSeparatorMenuItem().raw) is rawGtk.PSeparatorMenuItem
  doAssert typeof(newAccelLabel().raw) is rawGtk.PAccelLabel
  doAssert typeof(newTearoffMenuItem().raw) is rawGtk.PTearoffMenuItem
  doAssert compiles(newTearoffMenuItem().onActivate(proc () = discard))
  doAssert not compiles(newMenuBar().append(newButton()))
  doAssert not compiles(newMenuItem().submenu = newMenuBar())
  doAssert not compiles(newMenu().packStart(newMenuItem()))

type CaptureObj = object
  released: ptr int
type Capture = ref CaptureObj
proc `=destroy`(value: var CaptureObj) = inc value.released[]
proc trackItem(w: gtk2.MenuItem, released: ptr int): Connection =
  let capture = Capture(released: released)
  w.onActivate(proc () = discard capture.released)
proc trackTearoff(w: gtk2.Menu, released: ptr int): Connection =
  let capture = Capture(released: released)
  w.onTearoffChanged(proc (value: bool) = discard capture.released)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]

proc runTests() =
  gtk2.init()
  suite "gtk2 menu-bar trees and accelerator labels":
    test "menu insertion, copied text, mnemonic properties and owning item getters":
      let bar = newMenuBar()
      defer: bar.destroy()
      let file = newMenuItem("_File", mnemonic = true)
      let edit = newMenuItem("Edit")
      let help = newMenuItem("Help")
      bar.append(edit)
      bar.prepend(file)
      bar.insert(help, 2)
      check bar.itemCount == 3
      check bar.itemAt(0).text == "_File"
      check file.useUnderline
      file.useUnderline = false
      check not file.useUnderline
      file.text = "Fichier café"
      check bar.itemAt(0).text == "Fichier café"
      let alias = bar.itemAt(1)
      check alias.raw == edit.raw
      let uninserted = newMenuItem()
      defer: uninserted.destroy()
      expect ValueError: bar.insert(uninserted, -1)
      expect ValueError: bar.insert(uninserted, 4)
      expect ValueError: discard bar.itemAt(3)
      expect ValueError: discard bar.itemAt(-1)
      expect ValueError: bar.append(file)
      expect ValueError: file.text = "bad\0label"
      expect ValueError: file.text = "\xff"
      expect ValueError: discard newMenuItem("\xff")
      bar.remove(edit)
      check not alias.isDestroyed
      let menu = newMenu()
      defer: menu.destroy()
      menu.append(alias)
      check menu.itemAt(0).raw == edit.raw
      menu.destroy()
      check edit.isDestroyed
      check alias.isDestroyed

    test "submenus reject multiple owners and cycles through logical menu ancestors":
      let bar = newMenuBar()
      defer: bar.destroy()
      let root = newMenuItem("File")
      bar.append(root)
      let menu = newMenu()
      root.submenu = menu
      root.submenu = menu # Already attached here: no-op.
      check root.hasSubmenu
      let retained = root.submenu
      check retained.raw == menu.raw
      let nested = newMenuItem("Nested")
      let other = newMenuItem("Other")
      menu.append(nested)
      menu.append(other)
      let second = newMenu()
      nested.submenu = second
      expect ValueError: other.submenu = menu
      expect ValueError: second.append(root)
      let leaf = newMenuItem("Leaf")
      second.append(leaf)
      expect ValueError: leaf.submenu = menu
      expect ValueError: leaf.submenu = second
      let detachedRoot = newMenuItem("Detached root")
      defer: detachedRoot.destroy()
      let detachedMenu = newMenu()
      detachedRoot.submenu = detachedMenu
      expect ValueError: detachedMenu.append(detachedRoot)
      nested.clearSubmenu()
      check not nested.hasSubmenu
      check nested.submenu.isDestroyed # Explicit empty handle.
      other.submenu = second
      check other.submenu.raw == second.raw
      root.clearSubmenu()
      check not root.hasSubmenu
      check not retained.isDestroyed
      root.submenu = retained
      bar.destroy()
      check menu.isDestroyed
      check retained.isDestroyed
      check second.isDestroyed
      check leaf.isDestroyed

    test "check/radio menu state and groups use native behavior without borrowed lists":
      let menu = newMenu()
      defer: menu.destroy()
      let toggle = newCheckMenuItem("_Enabled", mnemonic = true)
      menu.append(toggle)
      var toggled = 0
      var activated = 0
      toggle.onToggled(proc () = inc toggled)
      toggle.onActivate(proc () = inc activated)
      toggle.active = true
      check toggle.active
      check toggled == 1
      check activated == 1 # GTK implements set_active via activation.
      toggle.active = true
      check toggled == 1
      toggle.activate()
      check not toggle.active
      check toggled == 2
      toggle.inconsistent = true
      toggle.drawAsRadio = true
      check toggle.inconsistent
      check toggle.drawAsRadio
      let first = newRadioMenuItem("First")
      let second = newRadioMenuItem(first, "_Second", mnemonic = true)
      let third = newRadioMenuItem("Third")
      menu.append(first)
      menu.append(second)
      menu.append(third)
      check first.active
      check not second.active
      second.active = true
      check second.active
      check not first.active
      third.joinGroup(second)
      third.joinGroup(first)
      third.joinGroup(third)
      third.active = true
      check third.active
      check not first.active
      check not second.active
      second.destroy()
      first.active = true
      check first.active

    test "image slots retain shared handles, reject reparenting, and copy label values":
      let item = newImageMenuItem("_Open", mnemonic = true)
      let other = newImageMenuItem("Other")
      defer: item.destroy()
      defer: other.destroy()
      check item.image.isDestroyed
      let pixels = newPixbuf(4, 4, 0xff0000ff'u32)
      let image = newImage(pixels)
      item.image = image
      item.image = image
      let alias = item.image
      check alias.raw == image.raw
      check alias.pixbuf.raw == pixels.raw
      item.alwaysShowImage = true
      check item.alwaysShowImage
      item.alwaysShowImage = false
      check not item.alwaysShowImage
      expect ValueError: other.image = image
      item.text = "Open file"
      check item.text == "Open file"
      item.clearImage()
      check item.image.isDestroyed
      check not alias.isDestroyed
      other.image = alias
      other.destroy()
      # GtkImageMenuItem clears its private image slot during destruction;
      # retained image handles remain live, unlike ordinary child destruction.
      check not alias.isDestroyed
      check not image.isDestroyed
      check rawGtk.get_parent(alias.raw) == nil
      alias.destroy()
      check image.isDestroyed

    test "separators are menu-only and reject text and activation even after upcasts":
      let menu = newMenu()
      let bar = newMenuBar()
      let separator = newSeparatorMenuItem()
      defer: menu.destroy()
      defer: bar.destroy()
      defer: separator.destroy()
      let item = gtk2.MenuItem(separator)
      expect ValueError: bar.append(separator)
      expect ValueError: item.text = "not a separator label"
      expect ValueError: discard item.text
      expect ValueError: item.activate()
      let label = newLabel("not separator content")
      defer: label.destroy()
      expect ValueError: gtk2.Bin(separator).add(label)
      expect ValueError: discard item.onActivate(proc () = discard)
      let submenu = newMenu()
      defer: submenu.destroy()
      expect ValueError: item.submenu = submenu
      menu.append(separator)
      check menu.itemCount == 1
      check menu.itemAt(0).raw == item.raw

    test "tearoff items are menu-only and expose checked copied title/state without detaching":
      let menu = newMenu()
      let bar = newMenuBar()
      let tearoff = newTearoffMenuItem()
      defer: menu.destroy()
      defer: bar.destroy()
      defer: tearoff.destroy()
      let item = gtk2.MenuItem(tearoff)
      expect ValueError: item.activate() # Must have a menu parent; opens nothing.
      expect ValueError: bar.append(item)
      expect ValueError: item.text = "not a label"
      expect ValueError: discard item.text
      expect ValueError: item.useUnderline = true
      let label = newLabel("not tearoff content")
      defer: label.destroy()
      expect ValueError: gtk2.Bin(tearoff).add(label)
      let submenu = newMenu()
      defer: submenu.destroy()
      expect ValueError: item.submenu = submenu
      check not menu.tornOff
      check menu.tearoffTitle == ""
      var title = "Detached café menu"
      menu.tearoffTitle = title
      title = "modified Nim source"
      check menu.tearoffTitle == "Detached café menu"
      let snapshot = menu.tearoffTitle
      menu.tearoffTitle = "Another title"
      check snapshot == "Detached café menu"
      menu.tearoffTitle = ""
      check menu.tearoffTitle == ""
      expect ValueError: menu.tearoffTitle = "bad\0title"
      expect ValueError: menu.tearoffTitle = "\xff"
      menu.tornOff = false # Never open a detached window in hidden tests.
      check not menu.tornOff
      menu.prepend(tearoff)
      check menu.itemAt(0).raw == item.raw
      var released = 0
      let connection = trackItem(item, addr released)
      let stateConnection = trackTearoff(menu, addr released)
      expect ValueError: discard menu.onTearoffChanged(nil)
      check connection.connected
      check stateConnection.connected
      menu.remove(tearoff)
      check not tearoff.isDestroyed
      expect ValueError: item.activate()
      menu.append(tearoff)
      menu.destroy()
      check tearoff.isDestroyed
      check not connection.connected
      check released == 2
      check not stateConnection.connected
      expect ValueError: discard menu.onTearoffChanged(proc (value: bool) = discard)
      expect ValueError: discard menu.tornOff
      expect ValueError: menu.tornOff = false
      expect ValueError: discard menu.tearoffTitle

    test "activation supports self-disconnection, exceptions, and closing an owner tree":
      let menu = newMenu()
      defer: menu.destroy()
      let item = newMenuItem("Once")
      menu.append(item)
      var calls = 0
      var once: Connection
      once = item.onActivate(proc () =
        inc calls
        once.disconnect()
        raise newException(ValueError, "expected menu activation error"))
      item.activate()
      item.activate()
      check calls == 1
      check not once.connected
      let window = newWindow()
      defer: window.destroy()
      let bar = newMenuBar()
      let heading = newMenuItem("File")
      let file = newMenu()
      let close = newMenuItem("Close")
      window.add(bar)
      bar.append(heading)
      heading.submenu = file
      file.append(close)
      let closing = close.onActivate(proc () = window.destroy())
      close.activate()
      check window.isDestroyed
      check bar.isDestroyed
      check heading.isDestroyed
      check file.isDestroyed
      check close.isDestroyed
      check not closing.connected
      expect ValueError: discard item.onActivate(nil)
      let nativeMenu = newMenu()
      let nativeAction = newMenuItem("Native shell activation")
      nativeMenu.append(nativeAction)
      nativeAction.onActivate(proc () = nativeMenu.destroy())
      rawGtk.activate_item(cast[rawGtk.PMenuShell](nativeMenu.raw),
        cast[rawGtk.PWidget](nativeAction.raw), g.gbool(true))
      check nativeMenu.isDestroyed
      check nativeAction.isDestroyed

    test "accelerator labels keep copied text and owning target getters without self-monitoring":
      let label = newAccelLabel("Action")
      let button = newButton("Target")
      defer: label.destroy()
      defer: button.destroy()
      check label.text == "Action"
      label.text = "Another action"
      check label.text == "Another action"
      check label.accelWidget.isDestroyed
      label.accelWidget = button
      let target = label.accelWidget
      check target.raw == cast[rawGtk.PWidget](button.raw)
      check not target.isDestroyed
      check label.accelWidth >= 0
      discard label.refetch()
      expect ValueError: label.accelWidget = label
      label.clearAccelWidget()
      check label.accelWidget.isDestroyed
      check not target.isDestroyed
      label.accelWidget = button
      button.destroy()
      expect ValueError: discard label.accelWidget # Cached tombstone, never resurrected.
      label.clearAccelWidget()
      check label.accelWidget.isDestroyed
      expect ValueError: discard newAccelLabel("bad\0label")
      expect ValueError: label.text = "\xff"
      expect ValueError: gtk2.Label(label).text = "\xff"
      expect ValueError: discard newLabel("\xff")

    test "tree destruction releases real captures and cached getter aliases":
      var released = 0
      let menu = newMenu()
      let action = newMenuItem()
      menu.append(action)
      let original = trackItem(action, addr released)
      let alias = menu.itemAt(0)
      let another = alias.onActivate(proc () = discard)
      menu.destroy()
      check released == 1
      check action.isDestroyed
      check alias.isDestroyed
      check not original.connected
      check not another.connected
      expect ValueError: discard alias.text
      expect ValueError: discard menu.itemCount
      expect ValueError: discard menu.itemAt(0)

    test "native menu objects finalize after explicit root destruction and handle release":
      var menuGone, itemGone, imageGone, tearoffGone = 0
      proc makeTree() =
        let menu = newMenu()
        let item = newImageMenuItem("Icon")
        let image = newImage()
        let tearoff = newTearoffMenuItem()
        g.weak_ref(cast[g.PGObject](tearoff.raw), finalized, addr tearoffGone)
        menu.append(tearoff)
        g.weak_ref(cast[g.PGObject](menu.raw), finalized, addr menuGone)
        g.weak_ref(cast[g.PGObject](item.raw), finalized, addr itemGone)
        g.weak_ref(cast[g.PGObject](image.raw), finalized, addr imageGone)
        menu.append(item)
        item.image = image
        discard menu.itemAt(0)
        discard item.image
        menu.destroy()
      makeTree()
      check menuGone == 1
      check itemGone == 1
      check imageGone == 1
      check tearoffGone == 1

runTests()
