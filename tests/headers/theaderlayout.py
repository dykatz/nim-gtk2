#!/usr/bin/env python3
"""Check raw-binding umbrellas and include ownership without native libraries."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
HEADERS = ROOT / 'src/headers'
UMBRELLAS = ('gtk2', 'gdk2', 'glib2', 'atk', 'pango', 'gdk2pixbuf', 'xkb')
INCLUDE = re.compile(r'^include\s+(?:"([^"]+)"|([\w/]+))[^\S\n]*$', re.M)


class HeaderLayout(unittest.TestCase):
    def test_only_ergonomic_module_remains_at_source_root(self):
        self.assertEqual({p.name for p in (ROOT / 'src').glob('*.nim')}, {'gtk2.nim'})
        self.assertEqual({p.name for p in (ROOT / 'src').iterdir() if p.is_dir()},
                         {'headers', 'gtk2'})

    def test_header_fragments_are_reachable_and_included_once(self):
        for module in UMBRELLAS:
            with self.subTest(module=module):
                seen = set()

                def visit(path):
                    path = path.resolve()
                    self.assertTrue(path.is_relative_to(HEADERS))
                    self.assertNotIn(path, seen, 'duplicate/cyclic include: ' + str(path))
                    seen.add(path)
                    for match in INCLUDE.finditer(path.read_text()):
                        name = match[1] or match[2]
                        child = path.parent / name
                        if child.suffix != '.nim':
                            child = Path(str(child) + '.nim')
                        visit(child)

                visit(HEADERS / (module + '.nim'))
                fragments = {p.resolve() for p in (HEADERS / module).rglob('*.nim')}
                self.assertTrue(fragments)
                self.assertTrue(fragments <= seen, 'orphaned header fragments')

    def test_audited_private_bitfield_helpers_do_not_return(self):
        for fragment in [HEADERS / 'gtk2.nim', *(HEADERS / 'gtk2').glob('*.nim')]:
            text = fragment.read_text()
            with self.subTest(fragment=fragment.name):
                self.assertNotRegex(text, r'\b(?:bm|bp)_TGtk(?:Entry|TextView|TextMarkBody|TextAttributes|TextAppearance|TextTag|TextBuffer)_')
                self.assertNotRegex(text, r'\b[PT]TextMarkBody\b')
                self.assertNotRegex(text, r'_gtk_text_(?:btree|buffer|line)_|gtk_text_line_segment_split')
                self.assertNotRegex(text, r'_gtk_(?:char|toggle|pixbuf|widget|mark)_segment_|_gtk_change_node_toggle_count|_gtk_anchored_child_get_layout')
                self.assertNotRegex(text, r'\b(?:bm|bp)_TGtkTextLineData_')
                self.assertNotRegex(text, r'\b[PT]Text(?:TagInfo|ToggleBody|ChildBody|LineSegment(?:Class)?|Seg\w+|BTreeNode)\b')
                self.assertNotRegex(text, r'(?i)\b(?:_gtk_text_tag_table_|table_)(?:add|remove)_buffer\b')
                if fragment.name.startswith('texttagtable') and '_types' not in fragment.name:
                    self.assertNotRegex(text, r'\.(?:hash|anonymous|anon_count|buffers)\b')
                if fragment.name.startswith('textmark'):
                    self.assertNotRegex(text, r'\.segment\b|\.flag0\b')
                if '_types' not in fragment.name:
                    if fragment.name.startswith('entry'):
                        self.assertNotRegex(text, r'(?i)\.(?:Entry_?flag0|flag1)\b')
                    if fragment.name.startswith('textview'):
                        self.assertNotRegex(text, r'(?i)\.TextView_?flag0\b')
                    if fragment.name.startswith('texttag'):
                        self.assertNotRegex(text, r'(?i)\.TextTag_?flag0\b')
                    if fragment.name.startswith('textbuffer'):
                        self.assertNotRegex(text, r'(?i)\.TextBuffer_?flag0\b')

    def test_sdk_does_not_access_private_text_tree_storage(self):
        for fragment in [ROOT / 'src/gtk2.nim', *(ROOT / 'src/gtk2').glob('*.nim')]:
            with self.subTest(fragment=fragment.name):
                self.assertNotRegex(fragment.read_text(), r'(?i)\.(?:btree|TextBuffer_?flag0|segments|view_id|tag_root|toggle_count)\b')

    def test_png_bytes_are_copied_bounded_and_native_buffers_always_freed(self):
        text = (ROOT / 'src/gtk2/pngbytes.nim').read_text()
        pure = text.split('proc encodePng*', 1)[0]
        self.assertIn('payload: seq[byte]', pure)
        self.assertIn('newSeq[byte](value.payload.len)', pure)
        self.assertNotIn('rawPixbuf.', pure)
        self.assertLess(text.index('requireOutsideModelFunction()'), text.index('if maxBytes < 0'))
        self.assertIn('g.g_object_ref(p)', text)
        self.assertIn('defer: g.g_object_unref(p)', text)
        self.assertIn('if buffer != nil: g.g_free(buffer)', text)
        self.assertIn('if error != nil: g.g_error_free(error)', text)
        self.assertLess(text.index('if buffer != nil: g.g_free(buffer)'), text.index('rawPixbuf.save_to_bufferv('))
        self.assertIn('failure.domain = error.domain', text)
        self.assertIn('failure.code = error.code.int', text)
        self.assertIn('addr size, "png", nil, nil, addr error)', text)
        self.assertLess(text.index('size > g.gsize(maxBytes)'), text.index('int(size)'))
        self.assertIn('copyMem(addr result.payload[0], buffer, result.payload.len)', text)
        raw = (ROOT / 'src/headers/gdk2pixbuf/core_2.nim').read_text()
        self.assertIn('buffer: ptr cstring, buffer_size: ptr gsize', raw)
        for forbidden in ('rawPixbuf.save(', 'rawPixbuf.savev(', 'loadPixbuf(', '$buffer',
                          'request_', 'set_can_store', 'realize(', 'main_iteration', 'writeFile('):
            self.assertNotIn(forbidden, text)

    def test_png_files_use_pinned_vector_encoding_and_owned_native_errors(self):
        text = (ROOT / 'src/gtk2/pngfiles.nim').read_text()
        self.assertLess(text.index('requireOutsideModelFunction()'), text.index('checkedString(filename)'))
        self.assertIn('var name = newString(filename.len)', text)
        self.assertIn('g.g_object_ref(p)', text)
        self.assertIn('defer: g.g_object_unref(p)', text)
        self.assertIn('if error != nil: g.g_error_free(error)', text)
        self.assertIn('failure.domain = error.domain', text)
        self.assertIn('failure.code = error.code.int', text)
        self.assertIn('rawPixbuf.savev(p, name.cstring, "png", nil, nil, addr error)', text)
        self.assertIn('rawPixbuf.savev_utf8(p, name.cstring, "png", nil, nil, addr error)', text)
        raw = (ROOT / 'src/headers/gdk2pixbuf/core_2.nim').read_text()
        self.assertIn('option_keys: PPchar, option_values: PPchar, error: ptr ptr GError)', raw)
        load = (ROOT / 'src/gtk2/pixbufs.nim').read_text().split('proc loadPixbuf*', 1)[1].split('proc width*', 1)[0]
        self.assertLess(load.index('requireOutsideModelFunction()'), load.index('pixbuf_new_from_file'))
        self.assertIn('pixbuf_new_from_file_utf8(name.cstring, addr error)', load)
        for forbidden in ('rawPixbuf.save(', 'loadPixbuf(', 'rename', 'removeFile(', 'g_unlink',
                          'set_can_store', 'store(', 'request_', 'realize(', 'main_iteration'):
            self.assertNotIn(forbidden, text)

    def test_rgba_values_are_copied_pure_and_native_rows_are_bounded(self):
        text = (ROOT / 'src/gtk2/rgbapixels.nim').read_text()
        pure = text.split('proc checkPixelSpan', 1)[0]
        self.assertNotIn('rawPixbuf.', pure)
        self.assertNotIn('requireOutsideModelFunction()', pure)
        self.assertIn('width > high(g.gint).int div 4 or height > high(g.gint).int div (width * 4)', pure)
        self.assertIn('result.payload[0]', pure)
        self.assertIn('int64(height - 1) * stride.int64 + int64(width * channels)', text)
        self.assertLess(text.index('if size > maxBytes:'), text.index('rawPixbuf.get_pixels(p)'))
        self.assertIn('copyMem(addr result.payload[dest], addr source[src], rowBytes)', text)
        self.assertIn('result.payload[d+3] = 255', text)
        self.assertIn('rawPixbuf.get_bits_per_sample(p) != 8', text)
        self.assertIn('rawPixbuf.get_colorspace(p) != rawPixbuf.COLORSPACE_RGB', text)
        self.assertEqual(text.count('requireOutsideModelFunction()'), 3)
        for forbidden in ('pixbuf_new_from_data(', 'loadPixbuf(', 'request_', 'realize(', 'show(', 'sink = true'):
            self.assertNotIn(forbidden, text)

    def test_image_drag_has_trust_envelope_metadata_only_policy_and_single_finish(self):
        text = (ROOT / 'src/gtk2/imagedrag.nim').read_text()
        self.assertIn('if not trusted: raise', text)
        self.assertIn('ImageDropPredicate* = proc (value: ImageDropInfo)', text)
        metadata = text.split('ImageDropInfo* = object', 1)[1].split('ImageDrop* = object', 1)[0]
        self.assertNotIn('Pixbuf', metadata)
        self.assertEqual(text.count('rawGtk.drag_finish('), 1)
        self.assertIn('g.gbool(valid), g.gbool(false)', text)
        self.assertIn('selection_data_get_data_type(selection) == wire.target', text)
        self.assertIn('selection_data_get_format(selection) == 8', text)
        self.assertIn('copyClipboardImage(decoded, s.maxPixels)', text)
        self.assertIn('if decoded != nil and s.active:', text)
        self.assertIn('if decoded != nil: g.g_object_unref(decoded)', text)
        self.assertIn('finally: dec modelFunctionDepth', text)
        self.assertIn('s.accept = nil', text)
        self.assertIn('receiver: Window', text)
        self.assertIn('target_table_free(targets.table, targets.count)', text)
        self.assertLess(text.index('valid = acceptImageDrop(s, value.info)'), text.index('rawGtk.drag_finish('))
        for forbidden in ('DEST_DEFAULT_DROP', 'set_text(', 'set_uris(', 'realize(', 'show(',
                          '"gtk-drag-dest"', 'loadPixbuf(', 'set_can_store'):
            self.assertNotIn(forbidden, text)

    def test_image_requests_gate_decode_bound_copy_and_keep_owner_weak(self):
        text = (ROOT / 'src/gtk2/imagerequests.nim').read_text()
        self.assertLess(text.index('if not trusted:'), text.index('rawGtk.request_image('))
        self.assertLess(text.index('if width * height > maxPixels.int64:'), text.index('rawPixbuf.copy(image)'))
        self.assertIn('ownerWidget: g.PGObject', text)
        self.assertIn('if not s.active:', text)
        self.assertIn('defer: GC_unref(s)', text)
        self.assertIn('cancelImageRequest(s) # Clear captures/owner', text)
        for forbidden in ('Connection(', 'wait_for_', 'set_can_store', 'request_text(',
                          'request_uris(', 'get_pixbuf(', 'loadPixbuf(', 'realize('):
            self.assertNotIn(forbidden, text)

    def test_drag_icons_are_copied_configuration_applied_only_at_real_begin(self):
        api = (ROOT / 'src/gtk2/dragicons.nim').read_text()
        self.assertIn('TextDragSource | UriDragSource | BinaryDragSource', api)
        self.assertIn('let snapshot = image.copy()', api)
        self.assertEqual(api.count('requireOutsideModelFunction()'), 2)
        self.assertIn('source.state.icon = Pixbuf()', api)
        self.assertNotIn('rawGtk.', api)
        for name in ('textdrag', 'uridrag', 'binarydrag'):
            text = (ROOT / ('src/gtk2/' + name + '.nim')).read_text()
            self.assertIn('applySourceIcon(context, s.icon)', text)
            self.assertIn('s.icon = Pixbuf()', text)
            self.assertNotIn('drag_source_set_icon', text)
        text = (ROOT / 'src/gtk2/textdrag.nim').read_text()
        self.assertIn('rawGtk.drag_set_icon_pixbuf(context, p, -2, -2)', text)
        for forbidden in ('drag_set_icon_stock', 'gtk-site-data', 'GtkDragSourceInfo',
                          'get_cursor(', 'drag_set_icon_default', 'realize('):
            self.assertNotIn(forbidden, text + api)

    def test_binary_drag_keeps_copy_finish_receiver_and_pure_scope_explicit(self):
        text = (ROOT / 'src/gtk2/binarydrag.nim').read_text()
        self.assertEqual(text.count('rawGtk.drag_finish('), 1)
        self.assertIn('g.gbool(valid), g.gbool(false)', text)
        self.assertIn('readSelectionBytes(selection, s.atom, s.mime, s.maxBytes)', text)
        self.assertIn('finally: dec modelFunctionDepth', text)
        self.assertIn('s.accept = nil', text)
        self.assertIn('receiver: Window', text)
        self.assertIn('rawGtk.set_screen(receiver.raw, rawGtk.get_screen(s.widget))', text)
        self.assertIn('s.wires.len != 0', text)
        self.assertIn('queueBinaryCleanup(s)', text)
        self.assertLess(text.index('valid = acceptBinaryDrop(s, value)'), text.index('rawGtk.drag_finish('))
        for forbidden in ('DEST_DEFAULT_DROP', 'set_text(', 'set_uris(', 'get_pixbuf(',
                          'realize(', 'show(', 'map(', '"gtk-drag-dest"'):
            self.assertNotIn(forbidden, text)

    def test_binary_requests_bound_copies_and_keep_wire_idle_cancellation_separate(self):
        text = (ROOT / 'src/gtk2/binaryrequests.nim').read_text()
        self.assertLess(text.index('if size > maxBytes: return'), text.index('result.bytes = newSeq[byte](size)'))
        self.assertIn('rawGtk.selection_data_get_data_type(selection) != atom', text)
        self.assertIn('rawGtk.selection_data_get_format(selection) != 8', text)
        self.assertIn('defer: GC_unref(s)', text)
        self.assertIn('if not s.nativePending: s.clipboard = Clipboard()', text)
        self.assertIn('s.fn = nil', text)
        self.assertIn('s.value = ClipboardBytes()', text)
        self.assertIn('g.g_idle_add_full', text)
        self.assertIn('ownerWidget: g.PGObject', text)
        self.assertIn('g.g_signal_connect_data', text)
        self.assertNotIn('owner: Connection', text)
        for forbidden in ('get_pixbuf(', 'get_text(', 'get_uris(', 'newBinaryData(',
                          'main_iteration', 'realize(', 'show(', 'selection_convert'):
            self.assertNotIn(forbidden, text)

    def test_binary_clipboard_keeps_byte_length_copy_and_protocol_scope_explicit(self):
        text = (ROOT / 'src/gtk2/binaryclipboard.nim').read_text()
        self.assertIn('bytes.len > high(g.gint).int - 1', text)
        self.assertIn('copyMem(addr result.payload[0], unsafeAddr bytes[0], bytes.len)', text)
        self.assertIn('rawGtk.set(selection, s.atom, 8, p, g.gint(value.payload.len))', text)
        self.assertIn('s.value = BinaryData()', text)
        self.assertIn('GC_unref(s)', text)
        self.assertIn('checkBinaryMime(value.target)', text)
        for forbidden in ('set_can_store', 'request_contents', 'set_text(', 'set_uris(',
                          'get_pixbuf(', 'realize(', 'show(', 'main_iteration'):
            self.assertNotIn(forbidden, text)

    def test_image_clipboard_keeps_copy_encoding_and_native_clear_explicit(self):
        text = (ROOT / 'src/gtk2/imageclipboard.nim').read_text()
        self.assertLess(text.index('let snapshot = image.copy()'), text.index('rawGtk.set_with_data('))
        self.assertIn('rawGtk.add_image_targets(list, 0, g.gbool(true))', text)
        self.assertIn('rawGtk.set_pixbuf(selection, snapshot.raw)', text)
        self.assertIn('s.snapshot = Pixbuf()', text)
        self.assertIn('GC_unref(s)', text)
        self.assertIn('rawGtk.target_table_free(targets, count)', text)
        for forbidden in ('set_can_store', 'request_contents', 'get_pixbuf(', 'set_image(',
                          'image/png', 'text/plain', 'realize(', 'show(', 'main_iteration'):
            self.assertNotIn(forbidden, text)

    def test_uri_drag_keeps_native_finish_and_receiver_scope_explicit(self):
        text = (ROOT / 'src/gtk2/uridrag.nim').read_text()
        self.assertEqual(text.count('rawGtk.drag_finish('), 1)
        self.assertIn('rawGtk.drag_finish(context, g.gbool(valid), g.gbool(false)', text)
        self.assertIn('readSelectionUris(selection)', text)
        self.assertIn('finally: dec modelFunctionDepth', text)
        self.assertIn('s.accept = nil', text)
        self.assertLess(text.index('valid = acceptUriDrop(s, value)'), text.index('rawGtk.drag_finish('))
        clipboard = (ROOT / 'src/gtk2/clipboard.nim').read_text().split('proc getClipboard*', 1)[1].split('proc setText*', 1)[0]
        self.assertLess(clipboard.index('requireOutsideModelFunction()'), clipboard.index('rawGdk.atom_intern('))
        self.assertNotRegex(text, r'rawGtk\.(?:realize|show|show_all|map|drag_(?:source|dest)_add_text_targets)\s*\(')
        self.assertNotIn('DEST_DEFAULT_DROP', text)
        self.assertNotIn('gtk-drag-dest', text) # No private native qdata access.

    def test_no_raw_compatibility_modules_at_old_paths(self):
        for module in HEADERS.glob('*.nim'):
            if module.stem != 'gtk2': # src/gtk2.nim is now the ergonomic public API.
                self.assertFalse((ROOT / 'src' / module.name).exists(), module.name)
        self.assertFalse((ROOT / 'src/gtk2ui.nim').exists())
        self.assertFalse((ROOT / 'src/gtk2ui').exists())


if __name__ == '__main__':
    unittest.main()
