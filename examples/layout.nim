## Scrolling, notebook pages and horizontal/vertical split panes.
## Build: nim c --path:src examples/layout.nim
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 layout", 720, 480)
  defer: window.destroy()
  window.borderWidth = 8
  let split = newHPaned()
  window.add(split)
  split.position = 190

  let navigation = newScrolledWindow(horizontal = scrollNever)
  navigation.shadow = shadowIn
  let links = newVBox(spacing = 6)
  links.borderWidth = 8
  navigation.add(links) # An implicit viewport adapts the ordinary VBox.
  split.packFirst(navigation, shrink = false)

  let right = newVPaned()
  right.position = 300
  split.packSecond(right)
  let notebook = newNotebook()
  notebook.scrollable = true
  right.packFirst(notebook, resize = true, shrink = false)

  let statusScroll = newScrolledWindow(horizontal = scrollNever)
  let viewport = newViewport()
  viewport.shadow = shadowNone
  let status = newLabel("Select a page or drag a notebook tab.")
  viewport.add(status)
  statusScroll.add(viewport) # An explicit viewport is not wrapped again.
  right.packSecond(statusScroll, resize = false)

  let welcome = newLabel("Welcome! Drag either divider to resize the panes.")
  let details = newVBox(spacing = 8)
  details.borderWidth = 12
  details.packStart(newLabel("Notebook content can be any widget."), packShrink)
  details.packStart(newEntry("An editable field"), packShrink)
  notebook.appendPage(welcome, "Welcome")
  notebook.appendPage(details, "Details")
  notebook.setTabReorderable(welcome, true)
  notebook.setTabReorderable(details, true)

  proc navigationButton(text: string, page: Widget): Button =
    result = newButton(text)
    result.onClicked do ():
      notebook.currentPage = notebook.pageIndex(page)
  links.packStart(navigationButton("Welcome", welcome), packShrink)
  links.packStart(navigationButton("Details", details), packShrink)

  var added = 0
  let addPage = newButton("Add a page")
  links.packStart(addPage, packShrink)
  addPage.onClicked do ():
    inc added
    let title = "Extra " & $added
    let page = newLabel("Dynamically added page " & $added)
    let index = notebook.appendPage(page, title)
    notebook.setTabReorderable(page, true)
    notebook.currentPage = index
  notebook.onSwitchPage do (index: int):
    status.text = "Selected page " & $(index + 1) & " of " & $notebook.pageCount

  window.run()

when isMainModule:
  main()
