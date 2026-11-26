# Included by gtk2.nim. Stage parsing away from the observed destination.
type TextInsertedRange* = tuple[first, last: int] # Unicode offsets, end exclusive.

proc insertRichText*(destination: TextBuffer, offset: int, fragment: TextBuffer): TextInsertedRange =
  ## Programmatic insertion from a distinct buffer sharing the exact tag table.
  ## Native tag inheritance and mark gravity apply. No selection replacement.
  pinTextBuffer(destination, dest)
  pinTextBuffer(fragment, source)
  if dest == source:
    raise newException(ValueError, "rich insertion requires a distinct fragment buffer")
  if rawGtk.get_tag_table(dest) != rawGtk.get_tag_table(source):
    raise newException(ValueError, "rich insertion requires the same native tag table")
  var position = bufferIter(destination, offset)
  let count = rawGtk.get_char_count(source).int
  if count > high(g.gint).int - rawGtk.get_char_count(dest).int:
    raise newException(ValueError, "rich insertion would exceed the native character count")
  var first, last: rawGtk.TTextIter
  rawGtk.get_bounds(source, addr first, addr last)
  var scan = first
  while rawGtk.compare(addr scan, addr last) < 0:
    if rawGtk.get_child_anchor(addr scan) != nil:
      raise newException(ValueError, "rich insertion cannot copy child anchors")
    discard rawGtk.forward_char(addr scan)
  result = (offset, offset + count)
  if count == 0: return

  # Native GTK emits insert-text, insert-pixbuf, apply-tag and mark signals while
  # still using iterators in both buffers. Keep releases deferred and queue SDK
  # text observations until after this entire user action. Raw handlers must
  # not mutate either buffer/table or run a nested main loop during this call.
  richCommitActive = true
  inc modelFunctionDepth
  defer:
    dec modelFunctionDepth
    richCommitActive = false
  rawGtk.begin_user_action(dest)
  defer: rawGtk.end_user_action(dest)
  rawGtk.insert_range(dest, addr position, addr first, addr last)

proc insertRichText*(destination: TextBuffer, offset: int, format: TextFormat,
                     text: SerializedText): TextInsertedRange =
  ## Decode trusted native bytes into a detached fragment bound to the target
  ## schema. Parsing or schema errors do not begin a destination user action.
  discard bufferIter(destination, offset)
  let fragment = format.deserialize(text, tagsFrom = destination)
  destination.insertRichText(offset, fragment)
