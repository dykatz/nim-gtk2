# Hidden toplevels only. Never call present(), run(), or a nested GTK loop.
import std/unittest
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert sizeof(rawGtk.TButtonsType) == sizeof(cint)
  doAssert typeof(newDialog().raw) is rawGtk.PDialog
  doAssert typeof(newMessageDialog("Test").raw) is rawGtk.PMessageDialog
  doAssert typeof(newAboutDialog().raw) is ptr rawGtk.AboutDialog
  doAssert compiles(newAboutDialog().onResponse(proc (id: gtk2.ResponseId) = discard))
  doAssert not compiles(newLabel().modal = true)

proc finalizedCallback(data: pointer, obj: g.PGObject) {.cdecl.} =
  cast[ptr bool](data)[] = true

proc runTests() =
  gtk2.init()
  suite "gtk2 nonblocking dialogs":
    test "dialog content, actions, response IDs, defaults and modal state":
      let parent = newWindow("Parent")
      defer: parent.destroy()
      let dialog = newDialog(parent, "Question", modal = true)
      defer: dialog.destroy()
      check dialog.title == "Question"
      check dialog.modal
      check dialog.destroyWithParent
      check rawGtk.get_transient_for(cast[rawGtk.PWindow](dialog.raw)) == parent.raw
      dialog.modal = false
      check not dialog.modal
      let entry = newEntry("Content")
      let label = newLabel("Below")
      dialog.packStart(entry, packShrink, padding = 3)
      dialog.packEnd(label)
      let area = rawGtk.get_content_area(dialog.raw)
      check rawGtk.get_parent(cast[rawGtk.PWidget](entry.raw)) == area
      let close = dialog.addButton("_Close", gtk2.responseClose)
      let custom = newButton("Custom")
      dialog.addActionWidget(custom, customResponse(1024))
      dialog.defaultResponse = customResponse(1024)
      dialog.setResponseSensitive(gtk2.responseClose, false)
      check not close.sensitive
      dialog.setResponseSensitive(gtk2.responseClose, true)
      check close.sensitive
      var responses: seq[gtk2.ResponseId]
      let connection = dialog.onResponse(proc (id: gtk2.ResponseId) = responses.add(id))
      close.click()
      custom.click()
      dialog.respond(gtk2.responseCancel)
      check responses == @[gtk2.responseClose, customResponse(1024), gtk2.responseCancel]
      check not dialog.isDestroyed # Respond does not auto-close a nonblocking dialog.
      dialog.destroy()
      check not connection.connected
      check entry.isDestroyed
      check close.isDestroyed
      check label.isDestroyed
      check custom.isDestroyed

    test "window parenting rejects cycles and supports clearing a transient parent":
      let first = newWindow()
      let second = newWindow()
      let third = newWindow()
      defer: first.destroy()
      defer: second.destroy()
      defer: third.destroy()
      second.transientFor = first
      third.transientFor = second
      expect ValueError: first.transientFor = third
      expect ValueError: first.transientFor = first
      third.clearTransientFor()
      check rawGtk.get_transient_for(third.raw) == nil
      third.destroyWithParent = true
      check third.destroyWithParent

    test "destroy-with-parent invalidates child dialogs, including derived handles":
      let parent = newWindow()
      let plain = newDialog(parent)
      let message = newMessageDialog(parent, "Message")
      let about = newAboutDialog(parent, "SDK", "1")
      let retained = newDialog(parent, destroyWithParent = false)
      defer: retained.destroy()
      var destroyed = 0
      about.onDestroy(proc () = inc destroyed)
      parent.destroy()
      check plain.isDestroyed
      check message.isDestroyed
      check about.isDestroyed
      check destroyed == 1
      check not retained.isDestroyed
      expect ValueError: discard about.version

    test "message formats are literal, setters remain plain and secondary text clears":
      let literal = "%n %s %d 100% <b>plain</b> & λ"
      let dialog = newMessageDialog(literal, gtk2.messageWarning, buttonsOkCancel,
                                    title = "Literal message")
      defer: dialog.destroy()
      check dialog.text == literal
      check dialog.title == "Literal message"
      check dialog.messageKind == gtk2.messageWarning
      dialog.secondaryText = literal
      check dialog.secondaryText == literal
      let saved = dialog.secondaryText
      dialog.secondaryText = "Changed %n"
      check saved == literal
      # Even after raw interop enables markup, the Nim text setter is plain.
      rawGtk.set_markup(dialog.raw, "<b>Old markup</b>")
      dialog.text = "<b>unclosed & %n"
      check dialog.text == "<b>unclosed & %n"
      dialog.secondaryText = ""
      check dialog.secondaryText == ""
      for kind in [gtk2.messageInfo, gtk2.messageWarning, gtk2.messageQuestion,
                   gtk2.messageError, gtk2.messageOther]:
        dialog.messageKind = kind
        check dialog.messageKind == kind
      for buttons in [buttonsNone, buttonsOk, buttonsClose, buttonsCancel, buttonsYesNo, buttonsOkCancel]:
        let item = newMessageDialog("Buttons", buttons = buttons)
        item.destroy()

    test "about properties copy strings and null-terminated credit vectors":
      let about = newAboutDialog("Nim SDK", "2.0")
      defer: about.destroy()
      check about.programName == "Nim SDK"
      check about.version == "2.0"
      about.programName = "Changed"
      about.comments = "Comments λ %n"
      about.copyright = "Copyright SDK authors"
      about.license = "Example license text"
      about.wrapLicense = true
      about.website = "https://example.invalid/"
      about.websiteLabel = "Project"
      about.translatorCredits = "Translators"
      about.logoIconName = "dialog-information"
      check about.programName == "Changed"
      check about.comments == "Comments λ %n"
      check about.copyright == "Copyright SDK authors"
      check about.license == "Example license text"
      check about.wrapLicense
      check about.website == "https://example.invalid/"
      check about.websiteLabel == "Project"
      check about.translatorCredits == "Translators"
      check about.logoIconName == "dialog-information"
      about.authors = @["First λ", "Second"]
      about.artists = @["Artist"]
      about.documenters = @["Writer"]
      check about.authors == @["First λ", "Second"]
      check about.artists == @["Artist"]
      check about.documenters == @["Writer"]
      let saved = about.authors
      about.authors = @["Replacement"]
      check saved == @["First λ", "Second"]
      expect ValueError: about.authors = @["Good", "a\0b"]
      check about.authors == @["Replacement"]
      about.authors = []
      about.artists = []
      about.documenters = []
      check about.authors.len == 0
      check about.artists.len == 0
      check about.documenters.len == 0

    test "response callbacks self-disconnect, contain exceptions, and destroy dialogs":
      let dialog = newDialog()
      defer: dialog.destroy()
      var calls = 0
      var once: Connection
      once = dialog.onResponse(proc (id: gtk2.ResponseId) =
        once.disconnect()
        check id == customResponse(65536)
        inc calls)
      dialog.respond(customResponse(65536))
      dialog.respond(gtk2.responseCancel)
      check calls == 1
      let throws = dialog.onResponse(proc (id: gtk2.ResponseId) =
        raise newException(ValueError, "expected dialog callback error"))
      dialog.onResponse(proc (id: gtk2.ResponseId) = inc calls)
      dialog.respond(gtk2.responseOk)
      check calls == 2
      throws.disconnect()
      dialog.onResponse(proc (id: gtk2.ResponseId) = dialog.destroy())
      dialog.respond(gtk2.responseClose)
      check dialog.isDestroyed

    test "invalid strings, parent handles and child containment fail early":
      let dialog = newDialog()
      let message = newMessageDialog("Kept")
      let about = newAboutDialog()
      let child = newLabel()
      defer: dialog.destroy()
      defer: message.destroy()
      defer: about.destroy()
      expect ValueError: discard newDialog("a\0b")
      expect ValueError: discard newMessageDialog("a\0b")
      expect ValueError: discard newMessageDialog("OK", title = "a\0b")
      expect ValueError: discard newAboutDialog("Good", "a\0b")
      expect ValueError: message.text = "a\0b"
      expect ValueError: message.secondaryText = "a\0b"
      check message.text == "Kept"
      expect ValueError: about.website = "a\0b"
      expect ValueError: discard dialog.addButton("a\0b", gtk2.responseOk)
      expect ValueError: dialog.add(child) # GtkDialog already owns its internal VBox.
      expect ValueError: dialog.packStart(dialog)
      dialog.packStart(child)
      expect ValueError: dialog.packEnd(child)
      expect ValueError: discard dialog.onResponse(nil)
      let parent = newWindow()
      parent.destroy()
      expect ValueError: discard newDialog(parent)
      expect ValueError: discard newMessageDialog(parent, "Bad parent")
      expect ValueError: discard newAboutDialog(parent)
      expect ValueError: dialog.transientFor = parent

    test "native destruction releases self-capturing dialog callbacks":
      var finalized = false
      proc makeCycle(flag: pointer): rawGtk.PDialog =
        let dialog = newDialog()
        result = dialog.raw
        g.weak_ref(cast[g.PGObject](result), finalizedCallback, flag)
        dialog.onResponse(proc (id: gtk2.ResponseId) = discard dialog.title)
        dialog.respond(gtk2.responseOk)
      let native = makeCycle(addr finalized)
      require not finalized
      rawGtk.destroy(cast[rawGtk.PWidget](native))
      check finalized

    test "explicit toplevel destruction followed by handle release finalizes all three":
      var finalized: array[3, bool]
      block:
        let widgets = @[gtk2.Widget(newDialog()), gtk2.Widget(newMessageDialog("Test")),
          gtk2.Widget(newAboutDialog())]
        for i, widget in widgets:
          g.weak_ref(cast[g.PGObject](widget.raw), finalizedCallback, addr finalized[i])
          widget.destroy()
      for done in finalized: check done

runTests()
