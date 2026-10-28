## Nonblocking Dialog, MessageDialog and AboutDialog examples.
## Build: nim c --path:src examples/dialogs.nim
import gtk2ui

proc main() =
  gtk2ui.init()
  let window = newWindow("gtk2ui dialogs", 440, 240)
  defer: window.destroy()
  window.borderWidth = 12
  let layout = newVBox(spacing = 8)
  window.add(layout)
  let status = newLabel("Dialogs use response callbacks, not nested loops.")
  let editButton = newButton("Edit a value")
  let questionButton = newButton("Ask a question")
  let aboutButton = newButton("About this example")
  layout.packStart(status)
  layout.packStart(editButton, packShrink)
  layout.packStart(questionButton, packShrink)
  layout.packStart(aboutButton, packShrink)

  editButton.onClicked do ():
    let dialog = newDialog(window, "Edit a value", modal = true)
    dialog.borderWidth = 12
    let entry = newEntry("Nim")
    dialog.packStart(newLabel("Enter a value:"), packShrink)
    dialog.packStart(entry, packShrink, padding = 8)
    discard dialog.addButton("_Cancel", responseCancel)
    discard dialog.addButton("_Save", responseOk)
    dialog.defaultResponse = responseOk
    entry.onActivate(proc () = dialog.respond(responseOk))
    dialog.onResponse do (id: ResponseId):
      if id == responseOk: status.text = "Saved: " & entry.text
      dialog.destroy()
    dialog.present()

  questionButton.onClicked do ():
    let dialog = newMessageDialog(window, "Continue with this operation?",
      kind = messageQuestion, buttons = buttonsYesNo, title = "Confirmation", modal = true)
    dialog.secondaryText = "Plain text is safe here: 100% complete, even %n is literal."
    dialog.onResponse do (id: ResponseId):
      status.text = if id == responseYes: "Confirmed" else: "Not confirmed"
      dialog.destroy()
    dialog.present()

  aboutButton.onClicked do ():
    let dialog = newAboutDialog(window, "gtk2ui dialog sampler", "1.0")
    dialog.comments = "Owned Nim handles and nonblocking GTK2 dialog responses."
    dialog.authors = @["Nim GTK2 SDK contributors"]
    dialog.license = "Example application from the MIT-licensed SDK."
    dialog.wrapLicense = true
    dialog.website = "https://github.com/dykatz/nim-gtk2"
    dialog.websiteLabel = "SDK source"
    dialog.onResponse(proc (id: ResponseId) = dialog.destroy())
    dialog.present()

  window.run()

when isMainModule:
  main()
