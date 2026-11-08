## Build: nim c -r --path:src examples/desktop.nim
## Optional real tray integration: /path/to/desktop --tray
## X11 embedding is available on Unix, not Windows or Quartz.
import std/[os, strutils]
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("GTK2 desktop infrastructure", 600, 420)
  defer: window.destroy()
  let invisible = newInvisible()
  defer: invisible.destroy() # Realized input-only resource; not a visual child.
  let layout = newVBox(spacing = 12)
  layout.borderWidth = 16
  window.add(layout)
  let message = newLabel("Invisible resource created without showing it.")
  message.setAlignment(0, 0.5)
  message.setPadding(4, 4)
  layout.packStart(message, packShrink)
  let status = newLabel("Desktop events appear here.")
  status.setAlignment(0, 0.5)
  layout.packEnd(status, packShrink)
  let uriRow = newHBox(spacing = 8)
  layout.packStart(uriRow, packShrink)
  let copyUris = newButton("Copy sample URIs")
  let inspectUris = newButton("Inspect URI clipboard")
  uriRow.packStart(copyUris, packShrink)
  uriRow.packStart(inspectUris, packShrink)
  layout.packStart(newLabel("URI data only: no files opened, no text fallback or automatic paste."), packShrink)
  var uriOffer: UriClipboardOffer
  var uriRequest: UriRequest
  defer:
    uriRequest.cancel()
    uriOffer.clear() # No-op after native ownership-loss notification.
  copyUris.onClicked(proc () =
    uriOffer = getClipboard().offerUris(["file:///tmp/example%20name", "https://example.invalid/%CE%BB"])
    status.text = "Copied two URI tokens (not local file authorization).")
  inspectUris.onClicked(proc () =
    uriRequest.cancel()
    uriRequest = getClipboard().requestUris(window, proc (value: ClipboardUris) =
      case value.kind
      of urisAvailable:
        status.text = if value.uris.len == 0: "Available empty URI list" else: value.uris.join("\n")
      of urisUnavailable: status.text = "No text/uri-list target available"
      of urisRejected: status.text = "Rejected URI data: " & value.error))
  let uriPads = newHBox(spacing = 16)
  layout.packStart(uriPads, packShrink)
  let uriSource = newEventBox()
  let uriDest = newEventBox()
  uriSource.add(newLabel("Drag URI samples (COPY)"))
  uriDest.add(newLabel("Drop URI list: inspect only"))
  for pad in [uriSource, uriDest]:
    pad.setSizeRequest(240, 60)
    uriPads.packStart(pad)
  layout.packStart(newLabel("Drop policy: nonempty urn:example: or https://example.invalid/ lists only."), packShrink)
  let uriDrag = uriSource.enableUriDrag(["https://example.invalid/%CE%BB", "urn:example:sample"])
  let acceptInspection: UriDropPredicate = proc (value: UriDrop): bool =
    # Synchronous, copied-data-only decision: no widgets, clipboard calls or I/O.
    if value.uris.len == 0: return false
    for uri in value.uris:
      if not (uri.startsWith("urn:example:") or uri.startsWith("https://example.invalid/")):
        return false
    true # A demo namespace policy, not a file permission or full URI parser.
  let uriDrop = uriDest.onUriDrop(proc (value: UriDrop) =
    # Accepted native transfer is already finished. Only the observer may update UI.
    status.text = "Accepted URI COPY at " & $value.x & "," & $value.y & ":\n" & value.uris.join("\n"),
    accept = acceptInspection)
  defer:
    uriDrag.disconnect()
    uriDrop.disconnect() # A pending native request drains without delivering to this observer.
  when defined(posix) and not defined(macosx):
    let socket = newSocket()
    socket.setSizeRequest(320, 100)
    let frame = newFrame("Protocol-managed embedded Plug")
    frame.add(socket)
    layout.packStart(frame)
    let row = newHBox(spacing = 8)
    layout.packStart(row, packShrink)
    let attach = newButton("Create embedded Plug")
    let detach = newButton("Destroy embedded Plug")
    row.packStart(attach, packShrink)
    row.packStart(detach, packShrink)
    var plug: Plug
    defer: plug.destroy()
    socket.onPlugAdded(proc () = status.text = "Plug added; socket ID " & $socket.id)
    socket.onPlugRemoved(proc () = status.text = "Plug removed; the socket remains reusable")
    attach.onClicked(proc () =
      if plug.isDestroyed:
        plug = newPlug(socket)
        let box = newVBox(spacing = 8)
        box.borderWidth = 8
        plug.add(box)
        box.packStart(newLabel("This widget tree belongs to a GtkPlug."), packShrink)
        let button = newButton("Embedded button")
        button.onClicked(proc () = status.text = "Embedded button activated")
        box.packStart(button, packShrink)
        plug.showAll())
    detach.onClicked(proc () = plug.destroy())
  else:
    layout.packStart(newLabel("Plug/Socket require the GTK2 X11 backend."), packShrink)
  var tray: StatusIcon
  defer: tray.close()
  if "--tray" in commandLineParams():
    # GTK's constructor can briefly map a private tray window even with
    # visible=false. No actual tray manager/embedding is guaranteed.
    tray = newStatusIconFromIcon("dialog-information")
    tray.title = "Nim GTK2 desktop example"
    tray.tooltipText = "Activate to raise the demo window"
    tray.onActivate(proc () = window.present())
    tray.onPopupMenu(proc (event: StatusPopup) =
      status.text = "Tray popup request: button " & $event.button
      window.present())
    tray.onEmbeddedChanged(proc (embedded: bool) =
      status.text = "Tray embedded: " & $embedded)
    tray.visible = true
  window.run()

when isMainModule: main()
