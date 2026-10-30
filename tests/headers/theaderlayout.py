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

    def test_no_raw_compatibility_modules_at_old_paths(self):
        for module in HEADERS.glob('*.nim'):
            if module.stem != 'gtk2': # src/gtk2.nim is now the ergonomic public API.
                self.assertFalse((ROOT / 'src' / module.name).exists(), module.name)
        self.assertFalse((ROOT / 'src/gtk2ui.nim').exists())
        self.assertFalse((ROOT / 'src/gtk2ui').exists())


if __name__ == '__main__':
    unittest.main()
