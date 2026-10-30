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
  layout.packStart(actions, packShrink)
  let status = newLabel("Double-click an icon to activate it")
  layout.packStart(status, packShrink)
  icons.onSelectionChanged do ():
    let index = icons.selectedIndex
    if index < 0:
      preview.clear()
      caption.text = "Choose an icon"
    else:
      let model = icons.model
      preview.pixbuf = model.value(index, 1).pixbufValue.scaled(112, 112)
      caption.text = model.value(index, 0).stringValue
  icons.onItemActivated do (index: int):
    status.text = "Activated: " & icons.model.value(index, 0).stringValue
  warmOnly.onToggled do ():
    for row in 0 ..< source.rowCount:
      source.setValue(row, 2, cell(not warmOnly.active or row < 2))
  reverse.onToggled do ():
    sorted.sortBy(0, if reverse.active: sortDescending else: sortAscending)
  icons.selectedIndex = 0
  window.run()

when isMainModule:
  main()
