# Included by gtk2ui.nim. Nonblocking dialogs reuse Window lifecycle semantics.
type
  Dialog* = object of Window
  MessageDialog* = object of Dialog
  AboutDialog* = object of Dialog
  DialogButtons* = enum
    buttonsNone, buttonsOk, buttonsClose, buttonsCancel, buttonsYesNo, buttonsOkCancel

proc raw*(w: Dialog): rawGtk.PDialog = cast[rawGtk.PDialog](raw(Widget(w)))
proc raw*(w: MessageDialog): rawGtk.PMessageDialog = cast[rawGtk.PMessageDialog](raw(Widget(w)))
proc raw*(w: AboutDialog): ptr rawGtk.AboutDialog = cast[ptr rawGtk.AboutDialog](raw(Widget(w)))

proc modal*(w: Window): bool = g.toBool(rawGtk.get_modal(w.raw))
proc `modal=`*(w: Window, value: bool) = rawGtk.set_modal(w.raw, g.gbool(value))
proc destroyWithParent*(w: Window): bool = g.toBool(rawGtk.get_destroy_with_parent(w.raw))
proc `destroyWithParent=`*(w: Window, value: bool) = rawGtk.set_destroy_with_parent(w.raw, g.gbool(value))
proc `transientFor=`*(w: Window, parent: Window) =
  let p = w.raw
  var ancestor = parent.raw
  var seen: seq[rawGtk.PWindow]
  while ancestor != nil:
    if ancestor == p or ancestor in seen:
      raise newException(ValueError, "transient window relationship would contain a cycle")
    seen.add(ancestor)
    ancestor = rawGtk.get_transient_for(ancestor)
  rawGtk.set_transient_for(p, parent.raw)
proc clearTransientFor*(w: Window) = rawGtk.set_transient_for(w.raw, nil)
proc present*(w: Window) =
  ## Shows the tree and raises the window, without entering a GTK main loop.
  w.showAll()
  rawGtk.present(w.raw)

proc attachDialogParent(w: Dialog, parent: Window, destroyWithParent: bool) =
  try:
    w.transientFor = parent
    w.destroyWithParent = destroyWithParent
  except Exception:
    w.destroy() # A constructor failure must not leak GTK's toplevel reference.
    raise

proc newDialog*(title = "", modal = false): Dialog =
  let label = checkedString(title)
  result.state = adoptWidget(rawGtk.dialog_new())
  rawGtk.set_title(cast[rawGtk.PWindow](result.raw), label)
  result.modal = modal
proc newDialog*(parent: Window, title = "", modal = false,
                destroyWithParent = true): Dialog =
  discard parent.raw
  result = newDialog(title, modal)
  attachDialogParent(result, parent, destroyWithParent)

proc packStart*(w: Dialog, child: Widget, options = packExpandWidget, padding = 0) =
  checkChild(w, child)
  let pad = g.guint(checkedInt(padding))
  let area = cast[rawGtk.PBox](rawGtk.get_content_area(w.raw))
  rawGtk.pack_start(area, child.raw, g.gbool(options != packShrink),
    g.gbool(options == packExpandWidget), pad)
proc packEnd*(w: Dialog, child: Widget, options = packExpandWidget, padding = 0) =
  checkChild(w, child)
  let pad = g.guint(checkedInt(padding))
  let area = cast[rawGtk.PBox](rawGtk.get_content_area(w.raw))
  rawGtk.pack_end(area, child.raw, g.gbool(options != packShrink),
    g.gbool(options == packExpandWidget), pad)
proc addButton*(w: Dialog, text: string, response: ResponseId): Button =
  let p = rawGtk.add_button(w.raw, checkedString(text), g.gint(response))
  result.state = adoptObject(p, borrowed = true)
proc addActionWidget*(w: Dialog, button: Button, response: ResponseId) =
  checkChild(w, button)
  rawGtk.set_can_default(cast[rawGtk.PWidget](button.raw), g.gbool(true))
  rawGtk.add_action_widget(w.raw, cast[rawGtk.PWidget](button.raw), g.gint(response))
proc setResponseSensitive*(w: Dialog, response: ResponseId, enabled: bool) =
  rawGtk.set_response_sensitive(w.raw, g.gint(response), g.gbool(enabled))
proc `defaultResponse=`*(w: Dialog, response: ResponseId) =
  rawGtk.set_default_response(w.raw, g.gint(response))
proc respond*(w: Dialog, response: ResponseId) = rawGtk.response(w.raw, g.gint(response))
proc onResponse*(w: Dialog, fn: proc (id: ResponseId) {.closure.}): Connection {.discardable.} =
  connectResponse(w, fn)

proc newMessageDialog*(text: string, kind = messageInfo, buttons = buttonsOk,
                       title = "", modal = false): MessageDialog =
  let message = checkedString(text)
  let caption = checkedString(title)
  # Never pass application text as printf's format string (including %n).
  result.state = adoptWidget(rawGtk.message_dialog_new(nil, rawGtk.TDialogFlags(0),
    rawGtk.TMessageType(ord(kind)), rawGtk.TButtonsType(ord(buttons)), "%s", message))
  rawGtk.set_title(cast[rawGtk.PWindow](result.raw), caption)
  result.modal = modal
proc newMessageDialog*(parent: Window, text: string, kind = messageInfo,
                       buttons = buttonsOk, title = "", modal = false,
                       destroyWithParent = true): MessageDialog =
  discard parent.raw
  result = newMessageDialog(text, kind, buttons, title, modal)
  attachDialogParent(result, parent, destroyWithParent)

proc dialogStringProperty(w: Widget, name: cstring): string =
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_STRING)
  defer: g.unset(addr value)
  g.get_property(cast[g.PGObject](w.raw), name, addr value)
  $g.get_string(addr value)
proc setDialogStringProperty(w: Widget, name: cstring, text: cstring) =
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_STRING)
  defer: g.unset(addr value)
  g.set_string(addr value, text)
  g.set_property(cast[g.PGObject](w.raw), name, addr value)
proc plainMessageText(w: MessageDialog) =
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_BOOLEAN)
  defer: g.unset(addr value)
  g.set_boolean(addr value, g.gbool(false))
  g.set_property(cast[g.PGObject](w.raw), "use-markup", addr value)
proc text*(w: MessageDialog): string = dialogStringProperty(w, "text")
proc `text=`*(w: MessageDialog, text: string) =
  let message = checkedString(text)
  plainMessageText(w)
  setDialogStringProperty(w, "text", message)
proc secondaryText*(w: MessageDialog): string = dialogStringProperty(w, "secondary-text")
proc `secondaryText=`*(w: MessageDialog, text: string) =
  let message = checkedString(text)
  if text.len == 0: rawGtk.format_secondary_text(w.raw, nil)
  else: rawGtk.format_secondary_text(w.raw, "%s", message)
proc messageKind*(w: MessageDialog): MessageKind =
  var value: g.TGValue
  discard g.init(addr value, rawGtk.message_type_get_type())
  defer: g.unset(addr value)
  g.get_property(cast[g.PGObject](w.raw), "message-type", addr value)
  MessageKind(g.get_enum(addr value))
proc `messageKind=`*(w: MessageDialog, kind: MessageKind) =
  var value: g.TGValue
  discard g.init(addr value, rawGtk.message_type_get_type())
  defer: g.unset(addr value)
  g.set_enum(addr value, g.gint(ord(kind)))
  g.set_property(cast[g.PGObject](w.raw), "message-type", addr value)

proc newAboutDialog*(programName = "", version = "", modal = false): AboutDialog =
  let name = checkedString(programName)
  let release = checkedString(version)
  result.state = adoptWidget(rawGtk.about_dialog_new())
  if programName.len > 0: rawGtk.about_dialog_set_program_name(result.raw, name)
  if version.len > 0: rawGtk.about_dialog_set_version(result.raw, release)
  result.modal = modal
proc newAboutDialog*(parent: Window, programName = "", version = "", modal = false,
                     destroyWithParent = true): AboutDialog =
  discard parent.raw
  result = newAboutDialog(programName, version, modal)
  attachDialogParent(result, parent, destroyWithParent)

template aboutStringProperty(name, setterName, getter, setter: untyped) =
  proc name*(w: AboutDialog): string = $getter(w.raw)
  proc setterName*(w: AboutDialog, text: string) = setter(w.raw, checkedString(text))

aboutStringProperty(programName, `programName=`, rawGtk.about_dialog_get_program_name, rawGtk.about_dialog_set_program_name)
aboutStringProperty(version, `version=`, rawGtk.about_dialog_get_version, rawGtk.about_dialog_set_version)
aboutStringProperty(comments, `comments=`, rawGtk.about_dialog_get_comments, rawGtk.about_dialog_set_comments)
aboutStringProperty(copyright, `copyright=`, rawGtk.about_dialog_get_copyright, rawGtk.about_dialog_set_copyright)
aboutStringProperty(license, `license=`, rawGtk.about_dialog_get_license, rawGtk.about_dialog_set_license)
aboutStringProperty(website, `website=`, rawGtk.about_dialog_get_website, rawGtk.about_dialog_set_website)
aboutStringProperty(websiteLabel, `websiteLabel=`, rawGtk.about_dialog_get_website_label, rawGtk.about_dialog_set_website_label)
aboutStringProperty(translatorCredits, `translatorCredits=`, rawGtk.about_dialog_get_translator_credits, rawGtk.about_dialog_set_translator_credits)
aboutStringProperty(logoIconName, `logoIconName=`, rawGtk.about_dialog_get_logo_icon_name, rawGtk.about_dialog_set_logo_icon_name)
proc wrapLicense*(w: AboutDialog): bool = g.toBool(rawGtk.about_dialog_get_wrap_license(w.raw))
proc `wrapLicense=`*(w: AboutDialog, value: bool) = rawGtk.about_dialog_set_wrap_license(w.raw, g.gbool(value))

proc copyStringVector(p: ptr cstring): seq[string] =
  if p == nil: return @[]
  let values = cast[ptr UncheckedArray[cstring]](p)
  var i = 0
  while values[i] != nil:
    result.add($values[i])
    inc i
proc stringVector(values: openArray[string]): seq[cstring] =
  for text in values: discard checkedString(text)
  result = newSeq[cstring](values.len + 1)
  for i, text in values: result[i] = text.cstring

template aboutListProperty(name, setterName, getter, setter: untyped) =
  proc name*(w: AboutDialog): seq[string] = copyStringVector(getter(w.raw))
  proc setterName*(w: AboutDialog, values: openArray[string]) =
    var strings = stringVector(values)
    setter(w.raw, addr strings[0]) # GTK copies the null-terminated vector.

aboutListProperty(authors, `authors=`, rawGtk.about_dialog_get_authors, rawGtk.about_dialog_set_authors)
aboutListProperty(artists, `artists=`, rawGtk.about_dialog_get_artists, rawGtk.about_dialog_set_artists)
aboutListProperty(documenters, `documenters=`, rawGtk.about_dialog_get_documenters, rawGtk.about_dialog_set_documenters)
