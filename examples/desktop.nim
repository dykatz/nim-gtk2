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
  let imageRow = newHBox(spacing = 8)
  layout.packStart(imageRow, packShrink)
  let imageSample = block:
    var rgba = newSeq[byte](32 * 24 * 4)
    for y in 0..<24:
      for x in 0..<32:
        let i = (y * 32 + x) * 4
        rgba[i] = byte(17 + x * 6)
        rgba[i+1] = byte(35 + y * 8)
        rgba[i+2] = 200
        rgba[i+3] = 0x90
    newPixbuf(newRgbaPixels(32, 24, rgba)) # Copied native-owned gradient, no codec.
  let imageSourcePad = newEventBox()
  imageSourcePad.setSizeRequest(48, 40)
  imageSourcePad.add(newImage(imageSample))
  imageRow.packStart(imageSourcePad, packShrink)
  let imageDrag = imageSourcePad.enableImageDrag(imageSample) # Drag this preview: private begin snapshots.
  imageDrag.setIcon(imageSample)
  defer: imageDrag.disconnect()
  let copyImage = newButton("Copy sample image")
  let clearImage = newButton("Clear image offer")
  let saveImage = newButton("Save sample PNG…")
  let encodeImage = newButton("Encode PNG bytes")
  imageRow.packStart(copyImage, packShrink)
  imageRow.packStart(clearImage, packShrink)
  imageRow.packStart(saveImage, packShrink)
  imageRow.packStart(encodeImage, packShrink)
  encodeImage.onClicked(proc () =
    try:
      let png = imageSample.encodePng(maxBytes = 64 * 1024) # Limit only the post-encoding SDK copy.
      let copy = png.bytes # Independent pure bytes, not a native buffer or automatic offer/file.
      status.text = "Encoded " & $png.len & " PNG bytes in RAM; copied " & $copy.len & ". No file/clipboard changes."
    except PixbufError as error:
      status.text = "Native PNG encode failed (" & $error.domain & ":" & $error.code & "): " & error.msg
    except ValueError as error:
      status.text = "PNG application-copy limit: " & error.msg)
  saveImage.onClicked(proc () =
    let dialog = newFileChooserDialog(window, "Save sample as PNG", fileSave)
    dialog.overwriteConfirmation = true # UI confirmation, not atomic save/permission enforcement.
    dialog.setCurrentName("sample.png")
    dialog.onResponse(proc (id: ResponseId, selection: FileSelection) =
      defer: dialog.destroy()
      if id != responseAccept: return
      if selection.filenames.len != 1:
        status.text = "Choose one native local filename; no URI-to-path authorization is inferred."
        return
      try:
        imageSample.savePng(selection.filenames[0]) # Synchronous explicit write, always PNG regardless of extension.
        status.text = "PNG saved. Native encoding is not an atomic/rollback transaction."
      except PixbufError as error:
        status.text = "PNG save failed (native " & $error.domain & ":" & $error.code & "): " & error.msg)
    dialog.present())
  var imageOffer: ImageClipboardOffer
  defer: imageOffer.clear()
  copyImage.onClicked(proc () =
    imageOffer = getClipboard().offerImage(imageSample) # Private pixel copy, not a shared preview.
    status.text = "Image offered using native writable formats; paste in another application.")
  clearImage.onClicked(proc () =
    imageOffer.clear()
    status.text = "Cleared our image offer if still current; other owners are untouched.")
  let imageRequestRow = newHBox(spacing = 8)
  layout.packStart(imageRequestRow, packShrink)
  let trustImages = newCheckButton("Trust incoming image data (native codecs)") # Initially OFF.
  let inspectImage = newButton("Decode trusted clipboard image")
  let incomingImage = newImage()
  imageRequestRow.packStart(trustImages, packShrink)
  imageRequestRow.packStart(inspectImage, packShrink)
  let imageDestPad = newEventBox()
  imageDestPad.setSizeRequest(64, 48)
  imageDestPad.add(incomingImage)
  imageRequestRow.packStart(imageDestPad, packShrink)
  inspectImage.sensitive = false
  var imageRequest: ImageRequest
  defer: imageRequest.cancel()
  trustImages.onToggled(proc () =
    inspectImage.sensitive = trustImages.active
    if not trustImages.active:
      imageRequest.cancel() # Stops delivery only, not already-started native decoding.
      incomingImage.pixbuf = Pixbuf())
  inspectImage.onClicked(proc () =
    if not trustImages.active: return
    imageRequest.cancel()
    imageRequest = getClipboard().requestImage(window, true, proc (value: ClipboardImage) =
      case value.kind
      of imageAvailable:
        let w = value.image.width
        let h = value.image.height
        let extent = max(w, h)
        incomingImage.pixbuf = if extent <= 64: value.image else:
          value.image.scaled(max(1, w * 64 div extent), max(1, h * 64 div extent))
        let pixels = value.image.rgbaPixels(maxBytes = 4096 * 4)
        status.text = "Trusted decoded copy: " & $w & "x" & $h & "; " & $pixels.len & " copied RGBA8 bytes"
      of imageUnavailable:
        status.text = "No native image result (absent/unsupported/decoder failure are not distinguished)."
      of imageRejected:
        status.text = "Rejected image copy: " & value.error,
      maxPixels = 4096)) # Post-decode copy limit, NOT codec/native allocation protection.
  let trustImageDrops = newCheckButton("Trust image drops onto preview (native codecs; initially OFF)")
  layout.packStart(trustImageDrops, packShrink)
  var imageDrop: ImageDropSite
  defer: imageDrop.disconnect()
  let smallImage: ImageDropPredicate = proc (value: ImageDropInfo): bool =
    value.width <= 64 and value.height <= 64 # Copied metadata only; NOT permission or codec validation.
  trustImageDrops.onToggled(proc () =
    if not trustImageDrops.active:
      imageDrop.disconnect() # Native wires drain; already-started decoders cannot be stopped.
    elif imageDrop.draining:
      trustImageDrops.active = false
      status.text = "Previous image drop is draining; retry enabling from a later event."
    else:
      imageDrop = imageDestPad.onImageDrop(true, proc (value: ImageDrop) =
        incomingImage.pixbuf = value.image # Native COPY is already finished.
        status.text = "Trusted image COPY at " & $value.info.x & "," & $value.info.y & ": " &
          $value.info.width & "x" & $value.info.height,
        maxPixels = 4096, accept = smallImage))
  let binaryRow = newHBox(spacing = 8)
  layout.packStart(binaryRow, packShrink)
  let copyBinary = newButton("Copy sample bytes")
  let clearBinary = newButton("Clear byte offer")
  let inspectBinary = newButton("Inspect sample byte target")
  binaryRow.packStart(copyBinary, packShrink)
  binaryRow.packStart(clearBinary, packShrink)
  binaryRow.packStart(inspectBinary, packShrink)
  let sampleBytes = newBinaryData("application/vnd.example.gtk2-demo", [0'u8, 255, 128, 0, 13, 10])
  var binaryOffer: BinaryClipboardOffer
  var binaryRequest: BinaryRequest
  defer:
    binaryRequest.cancel()
    binaryOffer.clear()
  copyBinary.onClicked(proc () =
    binaryOffer = getClipboard().offerBinary(sampleBytes)
    status.text = "Offered " & $sampleBytes.len & " opaque bytes as " & sampleBytes.mime & "; no text/image fallback.")
  clearBinary.onClicked(proc () =
    binaryOffer.clear()
    status.text = "Cleared our byte offer if still locally active.")
  inspectBinary.onClicked(proc () =
    binaryRequest.cancel()
    binaryRequest = getClipboard().requestBinary(window, sampleBytes.mime, proc (value: ClipboardBytes) =
      case value.kind
      of bytesAvailable:
        status.text = "Received " & $value.bytes.len & " opaque bytes for " & value.mime & "; not decoded."
      of bytesUnavailable: status.text = "No sample application byte target available."
      of bytesRejected: status.text = "Rejected byte reply: " & value.error,
      maxBytes = 4096)) # Limits our copy, not GTK's native wire allocation.
  let binaryPads = newHBox(spacing = 16)
  layout.packStart(binaryPads, packShrink)
  let binarySourcePad = newEventBox()
  let binaryDestPad = newEventBox()
  binarySourcePad.add(newLabel("Drag opaque sample bytes (COPY)"))
  binaryDestPad.add(newLabel("Drop sample MIME: count only"))
  for pad in [binarySourcePad, binaryDestPad]:
    pad.setSizeRequest(240, 48)
    binaryPads.packStart(pad)
  let binaryDrag = binarySourcePad.enableBinaryDrag(sampleBytes)
  let acceptSample: BinaryDropPredicate = proc (value: BinaryDrop): bool =
    value.mime == sampleBytes.mime and value.bytes.len > 0 # Copied data only, no GTK/I/O.
  let binaryDrop = binaryDestPad.onBinaryDrop(sampleBytes.mime, proc (value: BinaryDrop) =
    status.text = "Accepted binary COPY at " & $value.x & "," & $value.y & ": " & $value.bytes.len & " opaque bytes.",
    maxBytes = 4096, accept = acceptSample) # App copy bound, not a native receipt limit.
  defer:
    binaryDrag.disconnect()
    binaryDrop.disconnect() # Pending replies drain without observation; no DELETE.
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
  # Both source families own private copies; future drags use this sample icon.
  binaryDrag.setIcon(imageSample)
  uriDrag.setIcon(imageSample)
  let iconRow = newHBox(spacing = 8)
  layout.packStart(iconRow, packShrink)
  let sampleIcons = newButton("Copied sample drag icons")
  let nativeIcons = newButton("Native default drag icons")
  iconRow.packStart(sampleIcons, packShrink)
  iconRow.packStart(nativeIcons, packShrink)
  sampleIcons.onClicked(proc () =
    binaryDrag.setIcon(imageSample)
    uriDrag.setIcon(imageSample)
    status.text = "Copied icons apply to future drags; active contexts are unchanged.")
  nativeIcons.onClicked(proc () =
    binaryDrag.clearIcon()
    uriDrag.clearIcon()
    status.text = "Future drags use GTK's actual default, including application-wide defaults.")
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
