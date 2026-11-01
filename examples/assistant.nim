## A nonblocking GTK2 Assistant: validation, optional pages and apply/close.
## Build with: nim c --path:src examples/assistant.nim
import std/strutils
import gtk2

proc page(text: string): VBox =
  result = newVBox(spacing = 12)
  result.borderWidth = 16
  result.packStart(newLabel(text), packShrink)

proc main() =
  gtk2.init()
  let wizard = newAssistant("gtk2 Assistant example", 680, 440)
  defer: wizard.destroy()
  let intro = page("Welcome. Use Next and Back to move between steps.\n" &
    "This wizard does not start a nested dialog loop.")
  let settings = page("Enter a nonempty name. Erase it to disable Next.")
  let confirm = page("Review the name, then choose Apply.")
  let summary = page("Changes have been applied. Choose Close to finish.")
  # GTK2 detaches retained page roots when the Assistant is destroyed.
  # Explicitly destroy them too, releasing their controls and callback captures.
  defer:
    intro.destroy()
    settings.destroy()
    confirm.destroy()
    summary.destroy()
  let skip = newCheckButton("Use defaults and skip the settings page")
  intro.packStart(skip, packShrink)
  let name = newEntry("Ada")
  settings.packStart(name, packShrink)
  let review = newLabel("")
  confirm.packStart(review, packShrink)
  let saved = newLabel("Waiting for Apply.")
  summary.packStart(saved, packShrink)
  wizard.appendPage(intro, "Welcome", assistantIntro, complete = true)
  wizard.appendPage(settings, "Your settings", assistantContent, complete = true)
  wizard.appendPage(confirm, "Confirm", assistantConfirm, complete = true)
  wizard.appendPage(summary, "Finished", assistantSummary, complete = true)
  wizard.setPageHeaderImage(intro, newPixbuf(32, 32, 0x3875d7ff'u32))

  proc selectedName(): string =
    if skip.active: "Default user" else: name.text.strip()
  proc refresh() =
    wizard.setPageComplete(settings, name.text.strip().len > 0)
    review.text = "Name to save: " & selectedName()
  name.onChanged(proc () = refresh())
  skip.onToggled(proc () =
    wizard.setPageVisible(settings, not skip.active)
    refresh())
  refresh() # Prepare content synchronously, before navigation/display.

  let help = newButton("Help")
  wizard.addActionWidget(help)
  help.onClicked(proc () =
    let dialog = newMessageDialog(wizard,
      "Next/Back navigate pages. Empty settings are incomplete.\n" &
      "The optional settings page can be skipped from Welcome.", title = "Wizard help")
    dialog.onResponse(proc (response: ResponseId) = dialog.destroy())
    dialog.present())
  wizard.onPrepare(proc (shown: Widget) =
    # A safe deferred observer, not a synchronous pre-display hook.
    echo "Page selected: ", wizard.pageTitle(shown))
  wizard.onApply(proc () =
    saved.text = "Saved settings for " & selectedName()
    wizard.commit() # Clear Back history and prevent cancellation after applying.
    echo "Applied settings for ", selectedName())
  wizard.onCancel(proc () = wizard.destroy())
  wizard.onClose(proc () = wizard.destroy())
  wizard.run()

when isMainModule:
  main()
