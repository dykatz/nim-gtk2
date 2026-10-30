# Additional non-deprecated GTK2 raw widgets

These additions target **GTK 2.24** and are exported by `import headers/gtk2`.
They are raw C-ABI bindings, **not** `gtk2ui` wrappers. No deprecated widget
families were restored.

The generated umbrella `src/headers/gtk2/newwidgets.nim` includes shared types
and per-header declarations from `src/headers/gtk2/newwidgets/`. It is itself
included by `src/headers/gtk2.nim`; see [source layout](source-layout.md). There are 564 added functions, covering the following widgets
and their supporting interfaces, data, enums/flags, and callbacks.

## Newly covered widgets

| Widget handle type | Constructor / primary API prefix |
| --- | --- |
| `AboutDialog` | `about_dialog_new`, `about_dialog_*` |
| `Assistant` | `assistant_new`, `assistant_*` |
| `Expander` | `expander_new`, `expander_*` |
| `IconView` | `icon_view_new`, `icon_view_*` |
| `ColorButton` | `color_button_new`, `color_button_*` |
| `FontButton` | `font_button_new`, `font_button_*` |
| `FileChooserWidget` | `file_chooser_widget_new`; cast to existing `PFileChooser` for interface methods |
| `RecentChooserWidget` | `recent_chooser_widget_new`, `_new_for_manager` |
| `RecentChooserMenu` | `recent_chooser_menu_new`, `_new_for_manager` |
| `RecentChooserDialog` | `recent_chooser_dialog_new`, `_new_for_manager` |
| `ToolItem` | `tool_item_new`, `tool_item_*` |
| `ToolButton` | `tool_button_new`, `tool_button_*` |
| `ToggleToolButton` | `toggle_tool_button_new`, `toggle_tool_button_*` |
| `RadioToolButton` | `radio_tool_button_new`, `_new_from_widget`, `radio_tool_button_*` |
| `MenuToolButton` | `menu_tool_button_new`, `menu_tool_button_*` |
| `SeparatorToolItem` | `separator_tool_item_new`, `separator_tool_item_*` |
| `ToolPalette` | `tool_palette_new`, `tool_palette_*` |
| `ToolItemGroup` | `tool_item_group_new`, `tool_item_group_*` |
| `Spinner` | `spinner_new`, `spinner_start`, `spinner_stop` |
| `ScaleButton` | `scale_button_new`, `scale_button_*` |
| `VolumeButton` | `volume_button_new`; cast to `ptr ScaleButton` for value methods |
| `PrintUnixDialog` | `print_unix_dialog_new`, `print_unix_dialog_*` (Unix only) |
| `PageSetupUnixDialog` | `page_setup_unix_dialog_new`, `page_setup_unix_dialog_*` (Unix only) |

The modern `toolbar_insert`, item lookup, overflow, and drop APIs were added so
the new tool items can be inserted into existing raw `PToolbar` widgets.

Supporting APIs include `RecentChooser`, `RecentManager`, `RecentInfo`,
`RecentFilter`, `PrintSettings`, `PageSetup`, `PaperSize`, and Unix `Printer`.
New GLib `GError` fields and `g_error_free` are in `glib2`.

Unix print dialog/printer **functions** are available only when
`defined(posix) and not defined(macosx)`. Core print settings, paper sizes,
and page setup are cross-platform. Unix print dialogs are not substituted for
Windows or Quartz native printing facilities.

## Types and calling conventions

New widget/object types are opaque `incompleteStruct` handles. Use pointers
such as `ptr AboutDialog`; do not allocate them with Nim, embed them in structs,
or depend on their size. Constructors return the specific pointer type even
when the native header spells the return `GtkWidget*` or `GtkToolItem*`.
Narrowing the return pointer does not change the ABI.

For example, existing container/widget operations need an explicit base cast:

```nim
import headers/gtk2
import headers/glib2

# After GTK initialization:
let expander = expander_new("Details")
expander_set_expanded(expander, gbool(true))
# add(cast[PContainer](window), cast[PWidget](expander))
```

Recent chooser concrete widgets similarly use an explicit
`cast[ptr RecentChooser](chooser)` for interface methods. No fake C struct
inheritance, legacy `P`/`T` aliases, or unchecked automatic downcasts were added.

Enums and flags are distinct `cint` types with named GTK constants. Only flag
types have bitwise operators. All callbacks use `cdecl`; the callback signatures
are marked `gcsafe` consistently with the existing raw API. Callbacks must obey
GTK's UI-thread rules, must not unwind Nim exceptions through C, and must keep
any user-data memory alive until GTK releases it. Callback/data lifetime is not
managed automatically by raw bindings.

## Ownership

Native GTK ownership rules apply. Most widget constructors return floating
references; top-level windows have their own GTK lifecycle. Use native parenting,
`g_object_ref_sink`, `destroy`, and `g_object_unref` deliberately. Supporting
GObjects such as `PrintSettings` use ordinary reference counting. Keep a custom
`RecentManager` alive until all choosers using it have been destroyed.

Important return-value distinctions:

| Result | Ownership / release |
| --- | --- |
| About-dialog strings/authors; font-button font name | Borrowed; do not free |
| `recent_chooser_get_current_uri` | Owned string; `glib2.g_free` |
| `recent_chooser_get_uris` | Owned string vector; `glib2.g_strfreev` |
| `recent_chooser_get_items` | Owned list and info references; `recent_info_unref` each item, then `glib2.free` the list |
| `icon_view_get_selected_items` | Owned list and paths; free each path with `gtk2.free`, then `glib2.free` the list |
| `print_settings_get_page_ranges` | Owned array; `glib2.g_free` |
| `print_unix_dialog_get_settings` | New settings object; `g_object_unref` |
| `page_setup_unix_dialog_get_page_setup` | Borrowed object |
| `paper_size_new` / `paper_size_copy` | Boxed values; `paper_size_free`, not `g_object_unref` |
| `recent_manager_lookup_item` | Owned info reference; `recent_info_unref` |
| `GError**` outputs | Start with a nil `ptr glib2.GError`; release a returned error with `g_error_free` |

String arrays use `ptr cstring` and must be null-terminated where GTK specifies.
Varargs functions require correctly promoted C argument types and terminating
nil sentinels. Prefer non-varargs APIs where available. Consult GTK 2.24's native
API documentation for the ownership of less common getters and callback data.

## Regeneration and scope

`tools/generate_widgets.py` translates the selected GTK 2.24 headers, skips
`GTK_DISABLE_DEPRECATED` sections and the obsolete IconView orientation methods,
and fails on unknown C types or unparsed public prototypes. Existing declarations
are not duplicated. GTK headers are needed **only** for regeneration or the
optional native ABI test; ordinary SDK builds require no GTK headers or Python.

```sh
python3 tools/generate_widgets.py
python3 tools/generate_widgets.py --check
```

Pass `--include-root PATH` if the headers are not under `/usr/include`.
The generated symbol manifest is `tests/new_widget_symbols.txt`.

Four **non-widget** RecentInfo timestamp helpers are intentionally omitted:
`get_added`, `get_modified`, `get_visited`, and `get_application_info`. They
involve `time_t`, whose ABI differs between GTK2 Windows builds; this pass does
not guess its width. This is not a full repair of all pre-existing raw bindings.

## Validation

```sh
nimble testRawWidgets       # symbols/support objects, then hidden widgets
nimble testRawWidgetAbi     # generation check + native C ABI; GTK2 headers required
```

The no-display tests can also run alone:

```sh
nim r --path:src --warningAsError:Deprecated tests/tnewwidgets.nim
```

Every added symbol is checked in the native GTK library. Hidden-widget tests
exercise all new widget families, callbacks, models, recent filters/managers,
controls, toolbar/palette parenting, and Unix dialogs. They never show a window,
run a dialog, or submit a print job. They isolate data/config/cache directories
and recent-document fixtures in a temporary directory. The tests pump a bounded,
nonblocking main context to finish pending widget work before destruction.
GTK2 has an empty-recent-list cleanup bug with modern GLib; a populated fixture
avoids that native bug without suppressing warnings.

The optional C probe verifies public struct sizes/offsets, enum widths, and C-to-Nim
callback invocation. Native tests currently run on 64-bit illumos with GTK 2.24.33;
Windows/macOS semantic checks are not substitutes for native platform ABI tests.
