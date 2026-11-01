# Included by gtk2.nim. Shared GtkFileChooser interface. The SDK never calls
# gtk_dialog_run; native GTK2 may still use it internally for stock prompts.
type
  FileChooserButton* = object of HBox
  FileChooserWidget* = object of VBox
  FileChooserDialog* = object of Dialog
  FileFilter* = object of ObjectHandle
  FileChooserAction* = enum
    fileOpen, fileSave, fileSelectFolder, fileCreateFolder
  FileSelection* = object
    ## Native filename bytes on Unix; UTF-8 filenames on Windows. URI strings
    ## are portable. Remote selections need not have a corresponding filename.
    filenames*, uris*: seq[string]
    currentFolder*, currentFolderUri*: string
  FileChooserLike = FileChooserButton | FileChooserWidget | FileChooserDialog

proc raw*(w: FileChooserButton): rawGtk.PFileChooserButton = cast[rawGtk.PFileChooserButton](raw(Widget(w)))
proc raw*(w: FileChooserWidget): ptr rawGtk.FileChooserWidget = cast[ptr rawGtk.FileChooserWidget](raw(Widget(w)))
proc raw*(w: FileChooserDialog): rawGtk.PFileChooserDialog = cast[rawGtk.PFileChooserDialog](raw(Widget(w)))
proc raw*(f: FileFilter): rawGtk.PFileFilter = cast[rawGtk.PFileFilter](nativePointer(f))
proc chooser(w: FileChooserLike): rawGtk.PFileChooser = cast[rawGtk.PFileChooser](raw(Widget(w)))
proc ownedFileFilter(p: rawGtk.PFileFilter, borrowed = true): FileFilter =
  if p != nil: result.state = adoptObject(p, borrowed = borrowed, cache = true)
proc isEmpty*(f: FileFilter): bool = f.state == nil
proc destroy*(f: FileFilter) =
  if not f.isDestroyed: rawGtk.destroy(cast[rawGtk.PObject](f.raw))
proc name*(f: FileFilter): string = $rawGtk.get_name(f.raw)
proc `name=`*(f: FileFilter, value: string) = rawGtk.set_name(f.raw, checkedUtf8Text(value))
proc checkedFilterRule(value: string): cstring =
  result = checkedUtf8Text(value)
  if value.len == 0: raise newException(ValueError, "filter rule cannot be empty")
proc addPattern*(f: FileFilter, pattern: string) = rawGtk.add_pattern(f.raw, checkedFilterRule(pattern))
proc addMimeType*(f: FileFilter, mimeType: string) = rawGtk.add_mime_type(f.raw, checkedFilterRule(mimeType))
proc addPixbufFormats*(f: FileFilter) = rawGtk.add_pixbuf_formats(f.raw)
proc newFileFilter*(name = "", patterns: openArray[string] = []): FileFilter =
  let label = checkedUtf8Text(name)
  for pattern in patterns: discard checkedFilterRule(pattern)
  result = ownedFileFilter(rawGtk.file_filter_new(), borrowed = false)
  rawGtk.set_name(result.raw, label)
  for pattern in patterns: result.addPattern(pattern)

proc copiedFileText(text: cstring): string =
  if text != nil:
    try: result = $text
    finally: g.g_free(text)
proc copiedFileStrings(list: g.PGSList): seq[string] =
  # Both the container and every string are transfer-full.
  defer:
    var node = list
    while node != nil:
      g.g_free(node.data)
      node = node.next
    g.free(list)
  var node = list
  while node != nil:
    result.add($cast[cstring](node.data))
    node = node.next
proc readFileSelection(p: rawGtk.PFileChooser): FileSelection =
  result.filenames = copiedFileStrings(rawGtk.get_filenames(p))
  result.uris = copiedFileStrings(rawGtk.get_uris(p))
  result.currentFolder = copiedFileText(rawGtk.get_current_folder(p))
  result.currentFolderUri = copiedFileText(rawGtk.get_current_folder_uri(p))
proc selection*(w: FileChooserLike): FileSelection = readFileSelection(chooser(w))
proc filename*(w: FileChooserLike): string = copiedFileText(rawGtk.get_filename(chooser(w)))
proc filenames*(w: FileChooserLike): seq[string] = copiedFileStrings(rawGtk.get_filenames(chooser(w)))
proc uri*(w: FileChooserLike): string = copiedFileText(rawGtk.get_uri(chooser(w)))
proc uris*(w: FileChooserLike): seq[string] = copiedFileStrings(rawGtk.get_uris(chooser(w)))
proc currentFolder*(w: FileChooserLike): string = copiedFileText(rawGtk.get_current_folder(chooser(w)))
proc currentFolderUri*(w: FileChooserLike): string = copiedFileText(rawGtk.get_current_folder_uri(chooser(w)))
proc checkedChooserFilename(value: string): cstring =
  result = checkedString(value)
  if value.len == 0 or not g.toBool(g.g_path_is_absolute(result)):
    raise newException(ValueError, "chooser filenames must be absolute native paths")
  when defined(windows): discard checkedUtf8Text(value)
proc checkedChooserUri(value: string): cstring =
  result = checkedUtf8Text(value)
  var colon = -1
  for i, ch in value:
    if ch == ':':
      colon = i
      break
    if ch notin {'a'..'z', 'A'..'Z'} and (i == 0 or ch notin {'0'..'9', '+', '-', '.'}):
      raise newException(ValueError, "chooser URI must have an absolute URI scheme")
  if colon <= 0: raise newException(ValueError, "chooser URI must have an absolute URI scheme")
  for ch in value:
    if ch <= ' ' or ch == '\x7f': raise newException(ValueError, "URI whitespace/control bytes must be escaped")
proc setFilename*(w: FileChooserLike, value: string): bool {.discardable.} =
  g.toBool(rawGtk.set_filename(chooser(w), checkedChooserFilename(value)))
proc setUri*(w: FileChooserLike, value: string): bool {.discardable.} =
  g.toBool(rawGtk.set_uri(chooser(w), checkedChooserUri(value)))
proc setCurrentFolder*(w: FileChooserLike, value: string): bool {.discardable.} =
  g.toBool(rawGtk.set_current_folder(chooser(w), checkedChooserFilename(value)))
proc setCurrentFolderUri*(w: FileChooserLike, value: string): bool {.discardable.} =
  g.toBool(rawGtk.set_current_folder_uri(chooser(w), checkedChooserUri(value)))
proc fileAcceptLabel(action: FileChooserAction): string =
  if action == fileSave: "gtk-save" elif action == fileCreateFolder: "gtk-new" else: "gtk-open"
proc action*(w: FileChooserLike): FileChooserAction = FileChooserAction(ord(rawGtk.get_action(chooser(w))))
proc selectMultiple*(w: FileChooserLike): bool = g.toBool(rawGtk.get_select_multiple(chooser(w)))
proc `action=`*(w: FileChooserLike, value: FileChooserAction) =
  when w is FileChooserButton:
    if value notin {fileOpen, fileSelectFolder}:
      raise newException(ValueError, "FileChooserButton supports only Open and SelectFolder")
  if value in {fileSave, fileCreateFolder} and w.selectMultiple:
    raise newException(ValueError, "Save/CreateFolder cannot select multiple files")
  rawGtk.set_action(chooser(w), rawGtk.TFileChooserAction(ord(value)))
  when w is FileChooserDialog:
    let button = rawGtk.get_widget_for_response(cast[rawGtk.PDialog](w.raw), g.gint(responseAccept))
    if button != nil:
      let label = fileAcceptLabel(value)
      rawGtk.set_label(cast[rawGtk.PButton](button), label.cstring)
proc `selectMultiple=`*(w: FileChooserLike, value: bool) =
  when w is FileChooserButton:
    if value: raise newException(ValueError, "FileChooserButton supports only single selection")
    # Even assigning false to GTK2's native button property warns.
  else:
    if value and w.action notin {fileOpen, fileSelectFolder}:
      raise newException(ValueError, "Save/CreateFolder cannot select multiple files")
    rawGtk.set_select_multiple(chooser(w), g.gbool(value))
proc requireMultiple(w: FileChooserLike) =
  if not w.selectMultiple: raise newException(ValueError, "enable multiple selection first; use setFilename/setUri for single selection")
proc selectFilename*(w: FileChooserLike, value: string): bool {.discardable.} =
  requireMultiple(w)
  g.toBool(rawGtk.select_filename(chooser(w), checkedChooserFilename(value)))
proc selectUri*(w: FileChooserLike, value: string): bool {.discardable.} =
  requireMultiple(w)
  g.toBool(rawGtk.select_uri(chooser(w), checkedChooserUri(value)))
proc unselectFilename*(w: FileChooserLike, value: string) = rawGtk.unselect_filename(chooser(w), checkedChooserFilename(value))
proc unselectUri*(w: FileChooserLike, value: string) = rawGtk.unselect_uri(chooser(w), checkedChooserUri(value))
proc selectAll*(w: FileChooserLike) =
  requireMultiple(w)
  rawGtk.select_all(chooser(w))
proc unselectAll*(w: FileChooserLike) = rawGtk.unselect_all(chooser(w))
proc setCurrentName*(w: FileChooserLike, value: string) =
  let text = checkedUtf8Text(value)
  if w.action notin {fileSave, fileCreateFolder}:
    raise newException(ValueError, "currentName is only available for Save/CreateFolder")
  if value in [".", ".."] or '/' in value:
    raise newException(ValueError, "currentName must be a basename, not a path")
  when defined(windows):
    if '\\' in value: raise newException(ValueError, "currentName must be a basename, not a path")
  rawGtk.set_current_name(chooser(w), text)
proc localOnly*(w: FileChooserLike): bool = g.toBool(rawGtk.get_local_only(chooser(w)))
proc `localOnly=`*(w: FileChooserLike, value: bool) = rawGtk.set_local_only(chooser(w), g.gbool(value))
proc showHidden*(w: FileChooserLike): bool = g.toBool(rawGtk.get_show_hidden(chooser(w)))
proc `showHidden=`*(w: FileChooserLike, value: bool) = rawGtk.set_show_hidden(chooser(w), g.gbool(value))
proc createFolders*(w: FileChooserLike): bool = g.toBool(rawGtk.get_create_folders(chooser(w)))
proc `createFolders=`*(w: FileChooserLike, value: bool) = rawGtk.set_create_folders(chooser(w), g.gbool(value))
proc overwriteConfirmation*(w: FileChooserLike): bool = g.toBool(rawGtk.get_do_overwrite_confirmation(chooser(w)))
proc `overwriteConfirmation=`*(w: FileChooserLike, value: bool) = rawGtk.set_do_overwrite_confirmation(chooser(w), g.gbool(value))
proc filters*(w: FileChooserLike): seq[FileFilter] =
  let list = rawGtk.list_filters(chooser(w)) # Container-only transfer.
  defer: g.free(list)
  var node = list
  while node != nil:
    result.add(ownedFileFilter(cast[rawGtk.PFileFilter](node.data)))
    node = node.next
proc hasFileFilter(w: FileChooserLike, filter: FileFilter): bool =
  let p = filter.raw
  for candidate in w.filters:
    if candidate.raw == p: return true
proc addFilter*(w: FileChooserLike, filter: FileFilter) =
  if hasFileFilter(w, filter): raise newException(ValueError, "filter is already in this chooser")
  rawGtk.add_filter(chooser(w), filter.raw)
proc removeFilter*(w: FileChooserLike, filter: FileFilter) =
  if not hasFileFilter(w, filter): raise newException(ValueError, "filter is not in this chooser")
  rawGtk.remove_filter(chooser(w), filter.raw)
proc filter*(w: FileChooserLike): FileFilter = ownedFileFilter(rawGtk.get_filter(chooser(w)))
proc `filter=`*(w: FileChooserLike, value: FileFilter) =
  if not hasFileFilter(w, value): raise newException(ValueError, "add the filter to the chooser before selecting it")
  rawGtk.set_filter(chooser(w), value.raw)

proc title*(w: FileChooserButton): string = $rawGtk.file_chooser_button_get_title(w.raw)
proc `title=`*(w: FileChooserButton, value: string) = rawGtk.file_chooser_button_set_title(w.raw, checkedUtf8Text(value))
proc `title=`*(w: FileChooserDialog, value: string) = rawGtk.set_title(cast[rawGtk.PWindow](w.raw), checkedUtf8Text(value))
proc widthChars*(w: FileChooserButton): int = rawGtk.file_chooser_button_get_width_chars(w.raw).int
proc `widthChars=`*(w: FileChooserButton, value: int) = rawGtk.file_chooser_button_set_width_chars(w.raw, checkedInt(value))
proc focusOnClick*(w: FileChooserButton): bool = g.toBool(rawGtk.file_chooser_button_get_focus_on_click(w.raw))
proc `focusOnClick=`*(w: FileChooserButton, value: bool) = rawGtk.file_chooser_button_set_focus_on_click(w.raw, g.gbool(value))
proc newFileChooserButton*(title = "Choose a File", action = fileOpen): FileChooserButton =
  let caption = checkedUtf8Text(title)
  if action notin {fileOpen, fileSelectFolder}:
    raise newException(ValueError, "FileChooserButton supports only Open and SelectFolder")
  result.state = adoptWidget(rawGtk.file_chooser_button_new(caption, rawGtk.TFileChooserAction(ord(action))))
proc newFileChooserWidget*(action = fileOpen): FileChooserWidget =
  result.state = adoptWidget(rawGtk.file_chooser_widget_new(rawGtk.TFileChooserAction(ord(action))))
proc newFileChooserDialog*(title = "Choose a File", action = fileOpen, modal = false): FileChooserDialog =
  let caption = checkedUtf8Text(title)
  # No varargs buttons here: install typed, signed response IDs through Dialog.
  result.state = adoptWidget(rawGtk.file_chooser_dialog_new(caption, nil, rawGtk.TFileChooserAction(ord(action)), nil))
  result.modal = modal
  discard Dialog(result).addButton("gtk-cancel", responseCancel)
  discard Dialog(result).addButton(fileAcceptLabel(action), responseAccept)
  result.defaultResponse = responseAccept
proc newFileChooserDialog*(parent: Window, title = "Choose a File", action = fileOpen,
                           modal = false, destroyWithParent = true): FileChooserDialog =
  discard parent.raw
  result = newFileChooserDialog(title, action, modal)
  attachDialogParent(result, parent, destroyWithParent)

# Final-value observations are coalesced, not acceptance callbacks. The native
# emitter is borrowed; its destroy anchor cancels work even if Nim handles lapse.
type FileSelectionBinding = ref object
  fn: proc (value: FileSelection) {.closure.}
  owner: rawGtk.PFileChooser
  last: FileSelection
  watches: seq[g.gulong]
  active, pending: bool
  idle: g.guint
proc stopFileSelection(binding: FileSelectionBinding) =
  binding.active = false
  binding.pending = false
  let idle = binding.idle
  binding.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  let watches = binding.watches
  binding.watches = @[]
  for id in watches:
    if g.g_signal_handler_is_connected(binding.owner, id): g.g_signal_handler_disconnect(binding.owner, id)
  binding.owner = nil
  binding.fn = nil
proc releaseFileSelection(data: pointer, closure: g.PGClosure) {.cdecl.} =
  let binding = cast[FileSelectionBinding](data)
  stopFileSelection(binding)
  GC_unref(binding)
proc destroyFileSelection(instance, data: pointer) {.cdecl.} = stopFileSelection(cast[FileSelectionBinding](data))
proc releaseFileSelectionIdle(data: pointer) {.cdecl.} = GC_unref(cast[FileSelectionBinding](data))
proc dispatchFileSelection(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let binding = cast[FileSelectionBinding](data)
    if binding.active and binding.pending:
      binding.pending = false
      try:
        let value = readFileSelection(binding.owner)
        if value != binding.last:
          binding.last = value
          let fn = binding.fn
          fn(value)
      except Exception as error: reportSignalError(error)
    if not binding.active or not binding.pending:
      binding.idle = 0
      return g.gbool(false)
    g.gbool(true)
proc fileSelectionThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let binding = cast[FileSelectionBinding](data)
    if not binding.active: return
    binding.pending = true
    if binding.idle == 0:
      GC_ref(binding)
      binding.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchFileSelection),
        cast[pointer](binding), cast[pointer](releaseFileSelectionIdle))
proc onSelectionChanged*(w: FileChooserLike, fn: proc (value: FileSelection) {.closure.}): Connection {.discardable.} =
  let p = chooser(w)
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let binding = FileSelectionBinding(fn: fn, owner: p, last: readFileSelection(p), active: true)
  GC_ref(binding)
  let anchor = g.g_signal_connect_data(p, "destroy", cast[g.TGCallback](destroyFileSelection),
    cast[pointer](binding), releaseFileSelection, g.TGConnectFlags(0))
  w.state.handlers.add(anchor)
  for signal in ["selection-changed", "current-folder-changed"]:
    binding.watches.add(g.g_signal_connect_data(p, signal.cstring, cast[g.TGCallback](fileSelectionThunk),
      cast[pointer](binding), nil, g.G_CONNECT_AFTER))
  Connection(state: w.state, id: anchor)

# Action/response snapshots are copied at signal time, then delivered at idle.
type
  FileEvent = object
    response: ResponseId
    selection: FileSelection
  FileEventBinding = ref object
    fn: proc (event: FileEvent) {.closure.}
    values: seq[FileEvent]
    active: bool
    idle: g.guint
proc releaseFileEventIdle(data: pointer) {.cdecl.} = GC_unref(cast[FileEventBinding](data))
proc releaseFileEvent(data: pointer, closure: g.PGClosure) {.cdecl.} =
  let binding = cast[FileEventBinding](data)
  binding.active = false
  let idle = binding.idle
  binding.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  binding.values = @[]
  binding.fn = nil
  GC_unref(binding)
proc dispatchFileEvent(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let binding = cast[FileEventBinding](data)
    if binding.active and binding.values.len > 0:
      let value = binding.values[0]
      binding.values.delete(0)
      let fn = binding.fn
      try: fn(value)
      except Exception as error: reportSignalError(error)
    if not binding.active or binding.values.len == 0:
      binding.idle = 0
      return g.gbool(false)
    g.gbool(true)
proc queueFileEvent(instance, data: pointer, response = responseNone) =
  let binding = cast[FileEventBinding](data)
  if not binding.active: return
  binding.values.add(FileEvent(response: response, selection: readFileSelection(cast[rawGtk.PFileChooser](instance))))
  if binding.idle == 0:
    GC_ref(binding)
    binding.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchFileEvent),
      cast[pointer](binding), cast[pointer](releaseFileEventIdle))
proc fileEventThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: queueFileEvent(instance, data)
    except Exception as error: reportSignalError(error)
proc fileResponseThunk(instance: pointer, response: g.gint, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: queueFileEvent(instance, data, ResponseId(response))
    except Exception as error: reportSignalError(error)
proc connectFileEvent(w: Widget, signal: cstring, fn: proc (event: FileEvent) {.closure.}, response = false): Connection =
  let p = w.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let binding = FileEventBinding(fn: fn, active: true)
  GC_ref(binding)
  let thunk = if response: cast[g.TGCallback](fileResponseThunk) else: cast[g.TGCallback](fileEventThunk)
  let id = g.g_signal_connect_data(p, signal, thunk, cast[pointer](binding), releaseFileEvent, g.G_CONNECT_AFTER)
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)
proc onFileActivated*(w: FileChooserLike, fn: proc (value: FileSelection) {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectFileEvent(w, "file-activated", proc (event: FileEvent) = fn(event.selection))
proc onFileSet*(w: FileChooserButton, fn: proc (value: FileSelection) {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectFileEvent(w, "file-set", proc (event: FileEvent) = fn(event.selection))
proc onResponse*(w: FileChooserDialog, fn: proc (id: ResponseId, value: FileSelection) {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectFileEvent(w, "response", proc (event: FileEvent) = fn(event.response, event.selection), response = true)
proc connectFileResponse(w: Widget, fn: proc (id: ResponseId) {.closure.}): Connection =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectFileEvent(w, "response", proc (event: FileEvent) = fn(event.response), response = true)
