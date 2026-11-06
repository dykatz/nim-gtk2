## In-memory icons, owned pixel values, filtering/sorting and image previews.
## Build: nim c --path:src examples/icons.nim
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 icon palette", 720, 440)
  defer: window.destroy()
  window.borderWidth = 10
  let layout = newVBox(spacing = 8)
  window.add(layout)
  let source = newListStore([cellString, cellPixbuf, cellBool])
  let names = ["Ruby", "Amber", "Azure", "Mint", "Violet", "Slate"]
  let colors = [0xd94141ff'u32, 0xe8ad35ff'u32, 0x3388ddff'u32, 0x44bb88ff'u32, 0x9955ccff'u32, 0x667788ff'u32]
  for i, name in names:
    discard source.appendRow([cell(name), cell(newPixbuf(48, 48, colors[i])), cell(true)])
  let filtered = newTreeModelFilter(source, 2)
  let sorted = newTreeModelSort(filtered, 0)
  let icons = newIconView(sorted, pixbufColumn = 1, textColumn = 0)
  icons.selectionMode = selectionMultiple
  icons.itemWidth = 90
  icons.spacing = 8
  icons.margin = 10
  let scroll = newScrolledWindow()
  scroll.add(icons)
  let content = newHBox(spacing = 16)
  content.packStart(scroll)
  let previewBox = newVBox(spacing = 8)
  let preview = newImage()
  let caption = newLabel("Choose an icon")
  previewBox.packStart(preview, packShrink)
  previewBox.packStart(caption, packShrink)
  content.packStart(previewBox, packShrink)
  layout.packStart(content)
  let actions = newHBox(spacing = 12)
  let warmOnly = newCheckButton("Warm colors only")
  let reverse = newCheckButton("Reverse name order")
  actions.packStart(warmOnly, packShrink)
  actions.packStart(reverse, packShrink)
  let multiple = newCheckButton("Multiple selection")
  multiple.active = true
  let all = newButton("Select all")
  let clear = newButton("Clear")
  let remove = newButton("Delete selected")
  actions.packStart(multiple, packShrink)
  actions.packStart(all, packShrink)
  actions.packStart(clear, packShrink)
  actions.packStart(remove, packShrink)
  layout.packStart(actions, packShrink)
  let status = newLabel("Shift/Ctrl select icons; Ctrl+A selects all. Double-click or Return activates.")
  layout.packStart(status, packShrink)
  icons.onSelectionChanged do (value: IconSelection):
    if value.rows.len == 0:
      preview.clear()
      caption.text = "Choose an icon"
    else:
      let row = value.rows[0]
      if row.valid:
        preview.pixbuf = value.model.value(row.path, 1).pixbufValue.scaled(112, 112)
        caption.text = $value.rows.len & " selected; preview: " & value.model.value(row.path, 0).stringValue
  icons.onActivated do (value: IconActivation):
    if value.row.valid:
      status.text = "Activated: " & value.row.model.value(value.row.path, 0).stringValue
  multiple.onToggled do ():
    icons.selectionMode = if multiple.active: selectionMultiple else: selectionSingle
    all.sensitive = multiple.active
  all.onClicked do (): icons.selectAll()
  clear.onClicked do (): icons.unselectAll()
  remove.onClicked do ():
    # Resolve each proxy reference through both layers before deleting anything.
    var originals: seq[TreeRowReference]
    for row in icons.selectedRows:
      if row.valid:
        let path = filtered.toChildPath(sorted.toChildPath(row.path))
        originals.add(newTreeRowReference(source, path))
    for row in originals:
      if row.valid: source.removeRow(row.path.indices[0])
  warmOnly.onToggled do ():
    for row in 0 ..< source.rowCount:
      let name = source.value(row, 0).stringValue
      source.setValue(row, 2, cell(not warmOnly.active or name in ["Ruby", "Amber"]))
  reverse.onToggled do ():
    sorted.sortBy(0, if reverse.active: sortDescending else: sortAscending)
  icons.selectedIndices = [0]
  window.run()

when isMainModule:
  main()
