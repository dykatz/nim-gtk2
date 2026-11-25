# No realized widgets, input, selections or codecs.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2pixbuf as p

proc wrap(native: p.PPixbuf): Pixbuf =
  let holder = newImage()
  defer: holder.destroy()
  n.set_from_pixbuf(holder.raw, native)
  holder.pixbuf

gtk2.init()
suite "copied native Pixbuf saturation/pixelation":
  test "native references, quantization, format, alpha and independent identity copies":
    for alpha in [false, true]:
      let channels = if alpha: 4 else: 3
      let native = p.pixbuf_new(p.COLORSPACE_RGB, g.gbool(alpha), 8, 9, 8)
      require native != nil
      defer: g.g_object_unref(native)
      let stride = p.get_rowstride(native).int
      let data = cast[ptr UncheckedArray[byte]](p.get_pixels(native))
      for y in 0..<8:
        for i in 0..<9*channels: data[y*stride+i] = byte((y*9*channels+i) mod 256)
      let source = wrap(native)
      let before = source.rgbaPixels().bytes
      for factor in [0.0, 0.1, 0.5, 0.999999999, 1.0]:
        for pixelate in [false, true]:
          let output = source.saturated(factor, pixelate)
          let reference = p.pixbuf_new(p.COLORSPACE_RGB, g.gbool(alpha), 8, 9, 8)
          require reference != nil
          defer: g.g_object_unref(reference)
          p.saturate_and_pixelate(native, reference, g.gfloat(factor), g.gbool(pixelate))
          let bytes = output.rgbaPixels().bytes
          check bytes == wrap(reference).rgbaPixels().bytes
          check output.width == 9 and output.height == 8 and output.hasAlpha == alpha
          check output.raw != native
          for i in countup(3, bytes.high, 4): check bytes[i] == before[i]
          if factor == 0 and not pixelate:
            for i in countup(0, bytes.high, 4): check bytes[i] == bytes[i+1] and bytes[i] == bytes[i+2]
          if factor == 1:
            check (bytes == before) == not pixelate
          p.fill(output.raw, 0xdeadbeef'u32)
          check source.rgbaPixels().bytes == before
  test "subpixbuf with wider backing uses its own checkerboard origin and retains no pixels from source":
    let parent = newPixbuf(7, 3, 0x12345680'u32)
    let native = p.new_subpixbuf(parent.raw, 1, 1, 3, 2)
    require native != nil
    defer: g.g_object_unref(native)
    let source = wrap(native)
    let expected = newPixbuf(source.rgbaPixels()).saturated(0.4, true).rgbaPixels().bytes
    let output = source.saturated(0.4, true)
    check expected == output.rgbaPixels().bytes
    let identity = source.saturated()
    let original = source.rgbaPixels().bytes
    p.fill(parent.raw, 0xffffffff'u32)
    check output.rgbaPixels().bytes == expected
    check identity.rgbaPixels().bytes == original
  test "range and pure guards even for a no-op or invalid handle":
    let image = newPixbuf(2, 3)
    for factor in [NaN, Inf, NegInf, -1e-100, 1.000000000001, high(float)]:
      expect ValueError: discard image.saturated(factor)
    expect ValueError: discard default(Pixbuf).saturated()
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var calls, denied: int
    completion.setMatch(proc (value: CompletionMatchInput): bool =
      inc calls
      try: discard image.saturated()
      except ValueError as e:
        if e.msg == "GTK handle access is forbidden inside a synchronous model function; use copied row values": inc denied
      try: discard default(Pixbuf).saturated(NaN)
      except ValueError as e:
        if e.msg == "GTK handle access is forbidden inside a synchronous model function; use copied row values": inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 2
