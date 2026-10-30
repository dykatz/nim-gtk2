#!/usr/bin/env python3
"""Generate additive raw GTK 2.24 declarations, without deprecated APIs.

Usage: python3 tools/generate_widgets.py [--include-root /usr/include]
Requires the GTK2 and gtk-unix-print development headers only for regeneration.
The generated bindings need no C headers at build time. Fail on unknown C types
rather than guessing a pointer's width or a callback's calling convention.
"""
import argparse
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BINDINGS = ROOT / 'src/headers'


def binding_source(path):
    """Read legacy includes, excluding the generated additions themselves."""
    if path == BINDINGS / 'gtk2/newwidgets.nim':
        return ''
    text = path.read_text()
    return re.sub(r'^include "([^"]+)"\s*$',
                  lambda m: binding_source(path.parent / (m[1] + '.nim')),
                  text, flags=re.M)

CORE = [
    'aboutdialog', 'assistant', 'expander', 'iconview', 'colorbutton',
    'fontbutton', 'filechooserwidget', 'recentchooser', 'recentchooserwidget',
    'recentchoosermenu', 'recentchooserdialog', 'recentfilter', 'recentmanager',
    'toolbar', 'toolitem', 'toolbutton', 'toggletoolbutton', 'radiotoolbutton',
    'menutoolbutton', 'separatortoolitem', 'toolpalette', 'toolitemgroup',
    'spinner', 'scalebutton', 'volumebutton', 'printsettings', 'pagesetup',
    'papersize',
]
UNIX = ['printer', 'printunixdialog', 'pagesetupunixdialog']
# time_t differs between GTK2 Windows builds; do not guess its ABI. These are
# RecentInfo timestamp helpers, not widget APIs. Everything else in the selected
# nondeprecated headers is emitted, and skipped prototypes are recorded.
DEPRECATED = {'gtk_icon_view_set_orientation', 'gtk_icon_view_get_orientation'}
SKIP = {
    'gtk_recent_info_get_added', 'gtk_recent_info_get_modified',
    'gtk_recent_info_get_visited', 'gtk_recent_info_get_application_info',
}
BASE = {
    'void': 'void', 'char': 'char', 'int': 'cint', 'double': 'cdouble', 'gboolean': 'gboolean', 'gchar': 'char', 'guchar': 'uint8',
    'gint': 'gint', 'guint': 'guint', 'gint32': 'gint32', 'guint32': 'guint32',
    'gint64': 'gint64', 'guint64': 'guint64', 'guint16': 'guint16',
    'gdouble': 'gdouble', 'gfloat': 'gfloat', 'gsize': 'gsize',
    'gssize': 'gssize', 'GType': 'GType', 'GQuark': 'TGQuark',
    'gpointer': 'pointer', 'gconstpointer': 'pointer',
    'GError': 'GError',
    'GtkWidget': 'TWidget', 'GtkWindow': 'TWindow', 'GtkDialog': 'TDialog',
    'GtkAdjustment': 'TAdjustment', 'GtkTreeModel': 'TTreeModel',
    'GtkTreePath': 'TTreePath', 'GtkTreeIter': 'TTreeIter',
    'GtkCellRenderer': 'TCellRenderer', 'GtkTooltip': 'TTooltip',
    'GtkTargetEntry': 'TTargetEntry', 'GtkSelectionData': 'TSelectionData',
    'GtkToolbar': 'TToolbar', 'GtkSizeGroup': 'TSizeGroup',
    'GtkOrientation': 'TOrientation', 'GtkIconSize': 'TIconSize',
    'GtkSelectionMode': 'TSelectionMode', 'GtkToolbarStyle': 'TToolbarStyle',
    'GtkReliefStyle': 'TReliefStyle', 'GtkTextDirection': 'TTextDirection',
    'GtkFileChooserAction': 'TFileChooserAction', 'GtkDestDefaults': 'TDestDefaults',
    'GdkColor': 'gdk2.TColor',
    'GdkDragContext': 'gdk2.TDragContext', 'GdkModifierType': 'gdk2.TModifierType',
    'GdkDragAction': 'gdk2.TDragAction', 'GdkPixmap': 'gdk2.TPixmap',
    'GdkRectangle': 'gdk2.TRectangle', 'GdkScreen': 'gdk2.TScreen',
    'PangoFontDescription': 'pango.TFontDescription',
    'GList': 'TGList', 'GSList': 'TGSList', 'GDestroyNotify': 'TGDestroyNotify',
}
# Public structs supplied to callbacks or passed by the caller cannot be opaque.
STRUCTS = {
    'GtkRecentData': [
        ('display_name', 'cstring'), ('description', 'cstring'),
        ('mime_type', 'cstring'), ('app_name', 'cstring'), ('app_exec', 'cstring'),
        ('groups', 'ptr cstring'), ('is_private', 'gboolean')],
    'GtkRecentFilterInfo': [
        ('contains', 'RecentFilterFlags'), ('uri', 'cstring'),
        ('display_name', 'cstring'), ('mime_type', 'cstring'),
        ('applications', 'ptr cstring'), ('groups', 'ptr cstring'), ('age', 'gint')],
    'GtkPageRange': [('start', 'gint'), ('end', 'gint')],
}


def clean(text):
    text = re.sub(r'/\*.*?\*/', '', text, flags=re.S)
    out, stack, active = [], [], True
    for line in text.splitlines():
        directive = re.match(r'\s*#\s*(if\w*|else|elif|endif)\b(.*)', line)
        if directive:
            op, condition = directive.groups()
            if op in ('if', 'ifdef', 'ifndef'):
                test = 'GTK_DISABLE_DEPRECATED' not in condition
                stack.append((active, test))
                active = active and test
            elif op in ('else', 'elif'):
                parent, test = stack[-1]
                active = parent and not test
            elif op == 'endif':
                active, _ = stack.pop()
            continue
        if active and not line.lstrip().startswith('#'):
            out.append(line)
    text = '\n'.join(out)
    text = re.sub(r'\bG_GNUC_\w+(?:\s*\([^)]*\))?', '', text)
    return text.replace('G_BEGIN_DECLS', '').replace('G_END_DECLS', '')


def prototypes(text):
    pattern = r'(?m)^((?:const\s+)?\w+\s*(?:\*\s*(?:const\s*)?)*)\b(gtk_\w+)\s*\(([^;]*?)\)\s*;'
    return re.findall(pattern, text, re.S)


def nim_name(c):
    return c.removeprefix('Gtk').removeprefix('Pango')


def ident(s):
    # Quoting all parameter/field identifiers also handles Nim keywords and
    # case-insensitive collisions (type, method, object, from, end, ...).
    return '`' + s.strip('_') + '`'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--include-root', type=Path, default=Path('/usr/include'))
    parser.add_argument('--check', action='store_true', help='verify generated files without writing')
    args = parser.parse_args()
    version = (args.include_root / 'gtk-2.0/gtk/gtkversion.h').read_text()
    major = re.search(r'#define\s+GTK_MAJOR_VERSION\s+\(?([0-9]+)', version)
    minor = re.search(r'#define\s+GTK_MINOR_VERSION\s+\(?([0-9]+)', version)
    if not major or not minor or (int(major[1]), int(minor[1])) != (2, 24):
        raise SystemExit('Regeneration requires GTK 2.24 headers')
    paths = [(False, args.include_root / 'gtk-2.0/gtk' / ('gtk' + x + '.h')) for x in CORE]
    paths += [(True, args.include_root / 'gtk-unix-print-2.0/gtk' / ('gtk' + x + '.h')) for x in UNIX]
    headers = [(unix, p.name, clean(p.read_text())) for unix, p in paths]
    enum_text = '\n'.join(t for _, _, t in headers)
    enum_text += clean((args.include_root / 'gtk-2.0/gtk/gtkenums.h').read_text())
    # Ellipsization is used by tool items/groups. It was not in the old Pango
    # binding; its C enum has the same int representation as GTK enums.
    enum_text += '''\ntypedef enum { PANGO_ELLIPSIZE_NONE, PANGO_ELLIPSIZE_START,
      PANGO_ELLIPSIZE_MIDDLE, PANGO_ELLIPSIZE_END } PangoEllipsizeMode;\n'''
    enums = dict((name, body) for body, name in re.findall(
        r'typedef\s+enum\s*\{([^}]+)\}\s*(\w+)\s*;', enum_text, re.S))
    callbacks = {}
    for unix, header, text in headers:
        for ret, name, params in re.findall(
                r'typedef\s+(\w+\s*\**\s*)\(\s*\*\s*(\w+)\s*\)\s*\((.*?)\)\s*;', text, re.S):
            callbacks[name] = (ret, params, unix)
    opaque = set()
    for _, _, text in headers:
        opaque.update(re.findall(r'typedef\s+struct\s+\w+\s+(\w+)\s*;', text))
    # Types from GLib/GIO returned by supporting print/recent APIs.
    opaque.update(['GKeyFile', 'GIcon'])
    mapping = dict(BASE)
    used_enums, used_objects, used_callbacks = set(), set(), set()

    def ctype(decl):
        decl = re.sub(r'\bconst\b', '', decl).strip()
        stars = decl.count('*')
        base = decl.replace('*', '').strip()
        if base == 'GdkPixbuf' and stars:
            return 'ptr ' * (stars - 1) + 'gdk2pixbuf.PPixbuf'
        if base in ('gchar', 'char') and stars:
            return 'ptr ' * (stars - 1) + 'cstring'
        if base == 'void' and stars:
            return 'ptr ' * (stars - 1) + 'pointer'
        if base not in mapping:
            if base in enums:
                used_enums.add(base)
            elif base in callbacks:
                used_callbacks.add(base)
            elif base in opaque or base in STRUCTS:
                used_objects.add(base)
            else:
                raise ValueError('Unknown C type: ' + decl)
            mapping[base] = nim_name(base)
        return 'ptr ' * stars + mapping[base]

    def parameters(params):
        result = []
        for part in params.split(','):
            part = part.strip()
            if part in ('', 'void'): continue
            if part == '...': continue
            match = re.match(r'(.*?)\b(\w+)\s*(?:\[\s*\])?$', part, re.S)
            if not match: raise ValueError('Cannot parse parameter: ' + part)
            decl, name = match.groups()
            if '[' in part: decl += '*'
            result.append(ident(name) + ': ' + ctype(decl))
        return '; '.join(result)

    constructors = {
        'about_dialog': 'GtkAboutDialog', 'assistant': 'GtkAssistant',
        'expander': 'GtkExpander', 'icon_view': 'GtkIconView',
        'color_button': 'GtkColorButton', 'font_button': 'GtkFontButton',
        'file_chooser_widget': 'GtkFileChooserWidget',
        'recent_chooser_widget': 'GtkRecentChooserWidget',
        'recent_chooser_menu': 'GtkRecentChooserMenu',
        'recent_chooser_dialog': 'GtkRecentChooserDialog',
        'tool_item': 'GtkToolItem', 'tool_button': 'GtkToolButton',
        'toggle_tool_button': 'GtkToggleToolButton',
        'radio_tool_button': 'GtkRadioToolButton',
        'menu_tool_button': 'GtkMenuToolButton',
        'separator_tool_item': 'GtkSeparatorToolItem',
        'tool_palette': 'GtkToolPalette', 'tool_item_group': 'GtkToolItemGroup',
        'spinner': 'GtkSpinner', 'scale_button': 'GtkScaleButton',
        'volume_button': 'GtkVolumeButton', 'print_unix_dialog': 'GtkPrintUnixDialog',
        'page_setup_unix_dialog': 'GtkPageSetupUnixDialog',
    }
    for error_enum in ['GtkRecentChooserError', 'GtkRecentManagerError']:
        ctype(error_enum)
    original = binding_source(BINDINGS / 'gtk2.nim')
    existing_names = {n.replace('_', '').lower() for n in
        re.findall(r'^proc\s+`?(\w+)`?\*?\s*\(', original, re.M)}
    functions, seen = [], set()
    for unix, header, text in headers:
        for ret, name, params in prototypes(text):
            if name in SKIP or name in DEPRECATED: continue
            if name in seen: raise ValueError('Duplicate prototype: ' + name)
            seen.add(name)
            if name.removeprefix('gtk_').replace('_', '').lower() in existing_names:
                continue
            result = ctype(ret)
            for prefix, concrete in constructors.items():
                if re.match('gtk_' + prefix + r'_new(?:_|$)', name):
                    # Native constructors often spell their return GtkWidget*
                    # or GtkToolItem*. Narrowing a pointer return is ABI-neutral.
                    result = ctype(concrete + ' *')
                    break
            arguments = parameters(params)
            suffix = '' if result == 'void' else ': ' + result
            pragmas = 'cdecl, gcsafe, dynlib: lib, importc: "' + name + '"'
            if '...' in params: pragmas += ', varargs'
            functions.append((unix, header, name,
                'proc ' + name.removeprefix('gtk_') + '*(' + arguments + ')' + suffix + ' {.' + pragmas + '.}'))
    # Every public function-like name in these stripped headers must be parsed,
    # deliberately skipped, or an existing declaration. No silent regex misses.
    candidates = {name for _, _, text in headers
                  for name in re.findall(r'\b(gtk_\w+)\s*\(', text)}
    missing = candidates - seen - SKIP - DEPRECATED
    if missing:
        raise ValueError('Unparsed public prototypes: ' + ', '.join(sorted(missing)))
    # Callback parameter types can add enum/struct dependencies of their own.
    cb_defs = {}
    while used_callbacks - cb_defs.keys():
        for name in sorted(used_callbacks - cb_defs.keys()):
            ret, params, unix = callbacks[name]
            result = ctype(ret)
            suffix = '' if result == 'void' else ': ' + result
            cb_defs[name] = '  ' + mapping[name] + '* = proc (' + parameters(params) + ')' + suffix + ' {.cdecl, gcsafe.}'
    for name in list(used_objects):
        if name in STRUCTS:
            # Record the enum needed by the public filter-info struct.
            if name == 'GtkRecentFilterInfo': ctype('GtkRecentFilterFlags')
    output = [
        '# Generated by tools/generate_widgets.py from GTK 2.24 headers.',
        '# Included by gtk2.nim; do not import this implementation file directly.',
        '# No deprecated functions, C struct inheritance guesses, or P/T aliases.',
        '# Opaque object types are pointer-only handles; do not allocate them.',
        '# See docs/raw-widgets.md for platform and ownership rules.',
        '', 'type',
    ]
    for name in sorted(used_enums):
        output.append('  ' + mapping[name] + '* = distinct cint')
    for name in sorted(used_objects):
        nim = mapping[name]
        pragmas = 'pure, final' if name in STRUCTS else 'pure, final, incompleteStruct'
        output.append('  ' + nim + '* {.' + pragmas + '.} = object')
        for field, value in STRUCTS.get(name, []):
            output.append('    ' + ident(field) + '*: ' + value)
    output.extend(cb_defs[n] for n in sorted(cb_defs))
    output.append('')
    for name in sorted(used_enums):
        nim = mapping[name]
        output.append('proc `==`*(a, b: ' + nim + '): bool {.borrow.}')
        if name in {'GtkPrintCapabilities', 'GtkRecentFilterFlags', 'GtkToolPaletteDragTargets'}:
            for op in ['or', 'and', 'xor']:
                output.append('proc `' + op + '`*(a, b: ' + nim + '): ' + nim + ' {.borrow.}')
            output.append('proc `not`*(a: ' + nim + '): ' + nim + ' {.borrow.}')
    output += ['', 'const']
    for name in sorted(used_enums):
        value, env = -1, {}
        for entry in enums[name].split(','):
            entry = entry.strip()
            if not entry: continue
            parts = entry.split('=', 1)
            symbol = parts[0].strip()
            if len(parts) == 2:
                expr = parts[1].strip()
                for key, val in env.items(): expr = re.sub(r'\b' + key + r'\b', str(val), expr)
                if not re.fullmatch(r'[0-9xXa-fA-F\s()<>|+\-~]+', expr):
                    raise ValueError('Unsupported enum expression: ' + expr)
                value = eval(expr, {'__builtins__': {}}, {})
            else: value += 1
            env[symbol] = value
            output.append('  ' + symbol.removeprefix('GTK_') + '* = ' + mapping[name] + '(' + str(value) + ')')
    dest = BINDINGS / 'gtk2/newwidgets.nim'
    files = {dest.parent / 'newwidgets/types.nim': '\n'.join(output) + '\n'}
    umbrella = ['# Generated by tools/generate_widgets.py; included by headers/gtk2.nim.',
                'include "newwidgets/types"']
    groups = {}
    for unix, header, name, declaration in functions:
        groups.setdefault((unix, header), []).append(declaration)
    for (unix, header), declarations in groups.items():
        stem = Path(header).stem.removeprefix('gtk')
        umbrella.append('include "newwidgets/' + stem + '"')
        lines = ['# Generated from ' + header + '; included by headers/gtk2.nim.']
        if unix:
            lines.append('when defined(posix) and not defined(macosx):')
        lines.extend(('  ' if unix else '') + d for d in declarations)
        files[dest.parent / ('newwidgets/' + stem + '.nim')] = '\n'.join(lines) + '\n'
    files[dest] = '\n'.join(umbrella) + '\n'
    symbols = ROOT / 'tests/new_widget_symbols.txt'
    symbol_text = '\n'.join(('unix ' if unix else 'core ') + name
                            for unix, _, name, _ in functions) + '\n'
    files[symbols] = symbol_text
    for path, generated in files.items():
        if args.check:
            if not path.exists() or path.read_text() != generated:
                raise SystemExit('Generated files differ; run python3 tools/generate_widgets.py')
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(generated)
    print(f'Generated {len(functions)} functions; {len(used_objects)} handles/structs; {len(used_enums)} enum/flag types')
    print('Skipped time_t-dependent helpers: ' + ', '.join(sorted(SKIP)))


if __name__ == '__main__':
    main()
