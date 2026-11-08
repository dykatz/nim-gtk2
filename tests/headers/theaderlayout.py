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

    def test_binary_requests_bound_copies_and_keep_wire_idle_cancellation_separate(self):
        text = (ROOT / 'src/gtk2/binaryrequests.nim').read_text()
        self.assertLess(text.index('if size > s.maxBytes: return'), text.index('result.bytes = newSeq[byte](size)'))
        self.assertIn('rawGtk.selection_data_get_data_type(selection) != s.atom', text)
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
