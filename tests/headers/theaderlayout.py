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
                self.assertNotRegex(text, r'_gtk_text_(?:btree|buffer)_|_gtk_mark_segment_new')
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
                self.assertNotRegex(fragment.read_text(), r'(?i)\.(?:btree|TextBuffer_?flag0)\b')

    def test_no_raw_compatibility_modules_at_old_paths(self):
        for module in HEADERS.glob('*.nim'):
            if module.stem != 'gtk2': # src/gtk2.nim is now the ergonomic public API.
                self.assertFalse((ROOT / 'src' / module.name).exists(), module.name)
        self.assertFalse((ROOT / 'src/gtk2ui.nim').exists())
        self.assertFalse((ROOT / 'src/gtk2ui').exists())


if __name__ == '__main__':
    unittest.main()
