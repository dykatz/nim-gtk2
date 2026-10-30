# Hidden widgets only. No popup, dialog run, or visible toplevel.
import std/[os, tempfiles, unittest]
import gtk2ui
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert sizeof(gtk2ui.ResponseId) == sizeof(cint)
  doAssert sizeof(rawGtk.TImageType) == sizeof(cint)
  doAssert sizeof(rawGtk.TMessageType) == sizeof(cint)
  doAssert typeof(newImage().raw) is rawGtk.PImage
  doAssert typeof(newStatusbar().raw) is rawGtk.PStatusbar
  doAssert typeof(newInfoBar().raw) is rawGtk.PInfoBar
  doAssert not compiles(newInfoBar().add(newLabel()))
  doAssert not compiles(gtk2ui.Box(newInfoBar()))
  doAssert not compiles(newInfoBar().addActionWidget(newLabel(), gtk2ui.responseOk))
  doAssert not compiles(newImage().onResponse(proc (id: gtk2ui.ResponseId) = discard))

proc nativeStatusText(bar: gtk2ui.Statusbar): string =
  # Use documented native widget access, never old private struct fields.
  let area = rawGtk.get_message_area(bar.raw)
  let children = rawGtk.get_children(cast[rawGtk.PContainer](area))
  defer: g.free(children)
  var node = children
  while node != nil:
    if rawGtk.IS_LABEL(node.data):
      return $rawGtk.get_text(cast[rawGtk.PLabel](node.data))
    node = node.next

proc finalizedCallback(data: pointer, obj: g.PGObject) {.cdecl.} =
  cast[ptr bool](data)[] = true

proc runTests() =
  gtk2ui.init()
  let directory = createTempDir("nim_gtk2_feedback_", "")
  defer: removeDir(directory)
  let imageFile = directory / "pixels.ppm"
  writeFile(imageFile, "P3\n2 1\n255\n255 0 0 0 255 0\n")

  suite "gtk2ui display and feedback":
    test "images switch sources, copy identifiers, clear and validate storage":
      let image = newImage()
      defer: image.destroy()
      check image.storageKind == gtk2ui.imageEmpty
      expect ValueError: discard image.iconName
      expect ValueError: discard image.stockId
      image.setFromIcon("dialog-information", iconDialog)
      check image.storageKind == gtk2ui.imageIconName
      check image.iconName == "dialog-information"
      let saved = image.iconName
      image.pixelSize = 24
      check image.pixelSize == 24
      image.pixelSize = -1
      check image.pixelSize == -1
      image.setFromStock("gtk-dialog-warning", iconMenu)
      check saved == "dialog-information"
      check image.storageKind == gtk2ui.imageStock
      check image.stockId == "gtk-dialog-warning"
      image.setFromFile(imageFile)
      check image.storageKind == gtk2ui.imagePixbuf
      expect ValueError: discard image.stockId
      image.clear()
      check image.storageKind == gtk2ui.imageEmpty
      image.destroy()
      expect ValueError: image.clear()

    test "image constructors and missing-file fallback retain native semantics":
      let fileImage = newImageFromFile(imageFile)
      let named = newImageFromIcon("dialog-information")
      let stock = newImageFromStock("gtk-info")
      let missing = newImageFromFile(directory / "does-not-exist.png")
      defer: fileImage.destroy()
      defer: named.destroy()
      defer: stock.destroy()
      defer: missing.destroy()
      check fileImage.storageKind == gtk2ui.imagePixbuf
      check named.iconName == "dialog-information"
      check stock.stockId == "gtk-info"
      check missing.storageKind == gtk2ui.imageStock
      check missing.stockId == "gtk-missing-image"

    test "status contexts share native stacks and messages remove independently":
      let bar = newStatusbar(resizeGrip = false)
      defer: bar.destroy()
      check not bar.resizeGrip
      bar.resizeGrip = true
      check bar.resizeGrip
      let tasks = bar.context("tasks")
      let sameTasks = bar.context("tasks")
      let other = bar.context("other")
      let first = tasks.push("First")
      let second = sameTasks.push("Second λ")
      check nativeStatusText(bar) == "Second λ"
      other.push("Other context")
      first.remove() # Removing a non-top message must not disturb the display.
      check nativeStatusText(bar) == "Other context"
      other.pop()
      check nativeStatusText(bar) == "Second λ"
      second.remove()
      second.remove() # Removing an already removed message is a native no-op.
      check nativeStatusText(bar) == ""
      tasks.push("One")
      tasks.push("Two")
      tasks.pop()
      tasks.pop()
      check nativeStatusText(bar) == ""
      tasks.pop()
      bar.destroy()
      expect ValueError: tasks.push("Destroyed")
      expect ValueError: second.remove()

    test "status signals copy text and run after GTK updates its label":
      let bar = newStatusbar()
      defer: bar.destroy()
      let context = bar.context("signals")
      var pushed, popped: seq[string]
      var once: Connection
      once = bar.onTextPushed(proc (text: string) =
        check nativeStatusText(bar) == text
        once.disconnect()
        pushed.add(text))
      let connection = bar.onTextPopped(proc (text: string) =
        check nativeStatusText(bar) == text
        popped.add(text))
      context.push("First λ")
      context.push("Second")
      context.pop()
      context.pop()
      check pushed == @["First λ"]
      check popped == @["First λ", ""]
      connection.disconnect()
      check not once.connected
      check not connection.connected

    test "status tokens keep the bar alive without introducing an owning cycle":
      var finalized = false
      var context: StatusContext
      var message: StatusMessage
      block:
        let bar = newStatusbar()
        g.weak_ref(cast[g.PGObject](bar.raw), finalizedCallback, addr finalized)
        context = bar.context("retained")
        message = context.push("Retained")
      require not finalized
      context = StatusContext()
      message.remove()
      require not finalized
      message = StatusMessage()
      check finalized

    test "InfoBar packs only its content and creates owned action buttons":
      let bar = newInfoBar()
      let label = newLabel("A notice")
      let image = newImageFromStock("gtk-info")
      let custom = newButton("Custom")
      let window = newWindow()
      defer: window.destroy()
      window.add(bar)
      bar.packStart(image, packShrink, padding = 3)
      bar.packEnd(label)
      let area = rawGtk.get_content_area(bar.raw)
      check rawGtk.get_parent(cast[rawGtk.PWidget](image.raw)) == cast[rawGtk.PWidget](area)
      check rawGtk.get_parent(cast[rawGtk.PWidget](label.raw)) == cast[rawGtk.PWidget](area)
      for kind in [gtk2ui.messageWarning, gtk2ui.messageQuestion, gtk2ui.messageError,
                   gtk2ui.messageOther, gtk2ui.messageInfo]:
        bar.messageKind = kind
        check bar.messageKind == kind
      let close = bar.addButton("_Close", gtk2ui.responseClose)
      check close.text == "_Close"
      bar.addActionWidget(custom, customResponse(1024))
      bar.defaultResponse = customResponse(1024)
      bar.defaultResponse = gtk2ui.responseClose
      bar.setResponseSensitive(gtk2ui.responseClose, false)
      check not close.sensitive
      bar.setResponseSensitive(gtk2ui.responseClose, true)
      check close.sensitive
      var responses: seq[gtk2ui.ResponseId]
      let connection = bar.onResponse(proc (id: gtk2ui.ResponseId) = responses.add(id))
      close.click()
      custom.click()
      bar.respond(gtk2ui.responseCancel)
      check responses == @[gtk2ui.responseClose, customResponse(1024), gtk2ui.responseCancel]
      bar.destroy()
      check not connection.connected
      check close.isDestroyed
      check custom.isDestroyed
      check label.isDestroyed
      check image.isDestroyed
      expect ValueError: close.click()
      expect ValueError: discard bar.messageKind

    test "response callbacks self-disconnect, contain errors and allow destruction":
      let bar = newInfoBar(gtk2ui.messageWarning)
      defer: bar.destroy()
      var calls = 0
      var once: Connection
      once = bar.onResponse(proc (id: gtk2ui.ResponseId) =
        once.disconnect()
        check id == gtk2ui.responseOk
        inc calls)
      bar.respond(gtk2ui.responseOk)
      bar.respond(gtk2ui.responseCancel)
      check calls == 1
      let raises = bar.onResponse(proc (id: gtk2ui.ResponseId) =
        raise newException(ValueError, "expected InfoBar callback error"))
      bar.onResponse(proc (id: gtk2ui.ResponseId) = inc calls)
      bar.respond(customResponse(65536))
      check calls == 2
      raises.disconnect()
      bar.onResponse(proc (id: gtk2ui.ResponseId) = bar.destroy())
      bar.respond(gtk2ui.responseClose)
      check bar.isDestroyed

    test "invalid inputs and containment are rejected before native calls":
      let image = newImage()
      let bar = newInfoBar()
      let status = newStatusbar()
      let label = newLabel()
      let window = newWindow()
      defer: image.destroy()
      defer: bar.destroy()
      defer: status.destroy()
      defer: label.destroy()
      defer: window.destroy()
      expect ValueError: discard newImageFromFile("a\0b")
      expect ValueError: image.setFromIcon("a\0b")
      expect ValueError: image.setFromStock("a\0b")
      expect ValueError: image.pixelSize = -2
      expect ValueError: discard status.context("a\0b")
      expect ValueError: status.context("good").push("a\0b")
      expect ValueError: StatusContext().pop()
      expect ValueError: StatusMessage().remove()
      expect ValueError: discard customResponse(-1)
      expect ValueError: discard bar.addButton("a\0b", gtk2ui.responseOk)
      expect ValueError: bar.defaultResponse = gtk2ui.responseOk
      expect ValueError: bar.packStart(label, padding = -1)
      expect ValueError: bar.packStart(bar)
      expect ValueError: bar.packStart(window)
      bar.packStart(label)
      expect ValueError: bar.packEnd(label)
      expect ValueError: discard bar.onResponse(nil)
      expect ValueError: discard status.onTextPushed(nil)
      let parent = newFrame()
      defer: parent.destroy()
      let button = newButton()
      parent.add(button)
      expect ValueError: bar.addActionWidget(button, gtk2ui.responseOk)
      when sizeof(int) > sizeof(cint):
        expect ValueError: discard customResponse(high(cint).int + 1)
        expect ValueError: image.pixelSize = high(cint).int + 1

    test "feedback closures release self-capture cycles on native destruction":
      var finalizedInfo, finalizedStatus: bool
      proc makeInfo(flag: pointer): rawGtk.PInfoBar =
        let bar = newInfoBar()
        result = bar.raw
        g.weak_ref(cast[g.PGObject](result), finalizedCallback, flag)
        bar.onResponse(proc (id: gtk2ui.ResponseId) = discard bar.messageKind)
        bar.respond(gtk2ui.responseOk)
      proc makeStatus(flag: pointer): rawGtk.PStatusbar =
        let bar = newStatusbar()
        result = bar.raw
        g.weak_ref(cast[g.PGObject](result), finalizedCallback, flag)
        bar.onTextPushed(proc (text: string) = discard bar.resizeGrip)
        bar.context("cycle").push("Cycle")
      let info = makeInfo(addr finalizedInfo)
      let status = makeStatus(addr finalizedStatus)
      require not finalizedInfo
      require not finalizedStatus
      rawGtk.destroy(cast[rawGtk.PWidget](info))
      rawGtk.destroy(cast[rawGtk.PWidget](status))
      check finalizedInfo
      check finalizedStatus

    test "all three unparented feedback widgets finalize":
      var finalized: array[3, bool]
      block:
        let widgets = @[gtk2ui.Widget(newImage()), gtk2ui.Widget(newStatusbar()),
          gtk2ui.Widget(newInfoBar())]
        for i, widget in widgets:
          g.weak_ref(cast[g.PGObject](widget.raw), finalizedCallback, addr finalized[i])
      for done in finalized: check done

runTests()
