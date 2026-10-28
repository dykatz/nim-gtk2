## Images, an InfoBar notice, and independent status-message contexts.
## Build: nim c --path:src examples/feedback.nim
import gtk2ui

proc main() =
  gtk2ui.init()
  let window = newWindow("gtk2ui feedback", 620, 280)
  defer: window.destroy()
  window.borderWidth = 12
  let layout = newVBox(spacing = 10)
  window.add(layout)

  let notice = newInfoBar()
  let image = newImageFromIcon("dialog-information", iconDialog)
  image.pixelSize = 32
  let message = newLabel("An informational notice. Choose a style below.")
  notice.packStart(image, packShrink, padding = 4)
  notice.packStart(message)
  discard notice.addButton("_Apply", customResponse(1))
  discard notice.addButton("_Dismiss", responseClose)
  layout.packStart(notice, packShrink)
  # A default action needs a containing GtkWindow (it need not be shown yet).
  notice.defaultResponse = customResponse(1)

  let status = newStatusbar(resizeGrip = false)
  let operations = status.context("operations")
  let notices = status.context("notices")
  operations.push("Ready")
  layout.packEnd(status, packShrink)
  let style = newComboBoxText(["Information", "Warning", "Question", "Error", "Other"])
  style.activeIndex = 0
  layout.packStart(style, packShrink)
  style.onChanged do ():
    case style.activeIndex
    of 0:
      notice.messageKind = messageInfo
      image.setFromIcon("dialog-information", iconDialog)
    of 1:
      notice.messageKind = messageWarning
      image.setFromIcon("dialog-warning", iconDialog)
    of 2:
      notice.messageKind = messageQuestion
      image.setFromIcon("dialog-question", iconDialog)
    of 3:
      notice.messageKind = messageError
      image.setFromIcon("dialog-error", iconDialog)
    else:
      notice.messageKind = messageOther
      image.clear()
    message.text = style.activeText & " notice"
    notice.show()

  var operation = 0
  let buttons = newHBox(spacing = 8)
  layout.packStart(buttons, packShrink)
  let pushButton = newButton("Push operation")
  let popButton = newButton("Pop operation")
  let showButton = newButton("Show notice")
  buttons.packStart(pushButton)
  buttons.packStart(popButton)
  buttons.packStart(showButton)
  pushButton.onClicked do ():
    inc operation
    operations.push("Operation " & $operation)
  popButton.onClicked(proc () = operations.pop())
  showButton.onClicked do ():
    notices.pop()
    notice.show()
  notice.onResponse do (id: ResponseId):
    if id == responseClose or id == responseCancel:
      notice.hide()
      notices.push("Notice dismissed")
    elif id == customResponse(1):
      notices.push("Applied " & style.activeText)
  window.run()

when isMainModule:
  main()
