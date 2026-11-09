# Included after pixbufs. Native PNG encoding only; no decoding or external publication.
type PngBytes* = object
  payload: seq[byte]

proc len*(value: PngBytes): int = value.payload.len
proc isEmpty*(value: PngBytes): bool = value.payload.len == 0
proc bytes*(value: PngBytes): seq[byte] =
  result = newSeq[byte](value.payload.len)
  if result.len > 0: copyMem(addr result[0], unsafeAddr value.payload[0], result.len)

proc encodePng*(image: Pixbuf, maxBytes = 16 * 1024 * 1024): PngBytes =
  ## Bounds only the application copy, after native encoding/allocation has completed.
  requireOutsideModelFunction()
  if maxBytes < 0: raise newException(ValueError, "PNG maxBytes must be nonnegative")
  let p = image.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  var buffer: cstring
  var size: g.gsize
  var error: ptr g.GError
  defer:
    if buffer != nil: g.g_free(buffer)
    if error != nil: g.g_error_free(error)
  let ok = rawPixbuf.save_to_bufferv(p, addr buffer, addr size, "png", nil, nil, addr error)
  if error != nil:
    let failure = newException(PixbufError, $error.message)
    failure.domain = error.domain
    failure.code = error.code.int
    raise failure
  if not g.toBool(ok):
    raise newException(PixbufError, "native PNG encoding failed without GError")
  if buffer == nil or size == 0:
    raise newException(PixbufError, "native PNG encoder returned an empty buffer")
  # maxBytes fits int and gsize is unsigned pointer width: compare before conversion.
  if size > g.gsize(maxBytes):
    raise newException(ValueError, "PNG encoding exceeds maxBytes")
  result = PngBytes(payload: newSeq[byte](int(size)))
  copyMem(addr result.payload[0], buffer, result.payload.len)
