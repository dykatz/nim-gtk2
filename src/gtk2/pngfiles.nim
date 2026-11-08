# Included after pixbufs. Explicit synchronous native PNG encoding, not atomic persistence.
proc savePng*(image: Pixbuf, filename: string) =
  ## Writes/replaces a path through the installed PNG writer. Native failure may leave
  ## partial data or remove the file; no rollback, overwrite authority or fallback.
  requireOutsideModelFunction()
  discard checkedString(filename)
  let p = image.raw
  discard g.g_object_ref(p) # Native lifetime independent of caller/controller aliases.
  defer: g.g_object_unref(p)
  var name = newString(filename.len) # Owned bytes survive native codec/module reentrancy.
  if name.len > 0: copyMem(addr name[0], unsafeAddr filename[0], name.len)
  var error: ptr g.GError
  let ok = when defined(windows):
    rawPixbuf.savev_utf8(p, name.cstring, "png", nil, nil, addr error)
  else:
    rawPixbuf.savev(p, name.cstring, "png", nil, nil, addr error)
  defer:
    if error != nil: g.g_error_free(error)
  if error != nil:
    let failure = newException(PixbufError, $error.message)
    failure.domain = error.domain
    failure.code = error.code.int
    raise failure
  if not g.toBool(ok):
    # Do not fabricate a native error domain/code when the native API supplied none.
    raise newException(PixbufError, "native PNG encoding failed without GError")
