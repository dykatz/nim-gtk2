# Removed GTK2-deprecated widgets

This SDK omits widgets already deprecated in **GTK2**, as well as the old
`GTK_ENABLE_BROKEN` widgets. Removal includes public types, constructors,
methods, cast/type-check macros, bitfield helpers, and widget-specific
constants/callbacks. There is no compatibility module or warning suppression.

The inventory was checked against the installed GTK **2.24.33** headers, using
whole-widget `GTK_DISABLE_DEPRECATED` guards and `GTK_ENABLE_BROKEN` guards.
A header containing a few deprecated methods does **not** mean its entire
widget is deprecated. Deprecations introduced only in GTK3 are outside this
removal pass.

## Removed families

| Removed binding | Replacement / approach |
| --- | --- |
| `CList` | `TreeView` with `ListStore` |
| `CTree` | `TreeView` with `TreeStore` |
| `Combo` | `ComboBox` / `ComboBoxText` |
| `Curve` | Custom `DrawingArea` with Cairo |
| `GammaCurve` | Scale plus custom drawing |
| `FileSelection` | `FileChooserDialog` |
| `InputDialog` | Application-specific input-device configuration |
| `List`, `ListItem` | `TreeView` with a list model |
| `OldEditable` | `Editable` interface / `Entry` / `TextView` |
| `OptionMenu` | `ComboBoxText` |
| `Pixmap` widget | `Image`; GDK pixmaps are not removed |
| `Preview` | `Image` or `DrawingArea` |
| `Ruler`, `HRuler`, `VRuler` | Custom measurement drawing |
| `Text` (`GTK_ENABLE_BROKEN`) | `TextView` with `TextBuffer` |
| `Tree`, `TreeItem` (`GTK_ENABLE_BROKEN`) | `TreeView` with `TreeStore` |
| `TipsQuery` | Modern widget tooltip API |
| Public `Progress` base API | `ProgressBar` |
| `Tooltips` support object and old toolbar tooltip toggles | `set_tooltip_text` / modern `Tooltip` |

This does **not** remove unrelated names that happen to contain these words:
`TextView`, `TextBuffer`, `TreeView`, `TreeModel`, `ListStore`, `ComboBox`,
`TargetList`, `ProgressBar`, GDK `Pixmap`, and ATK `Text` remain available.
Some replacements have raw bindings only and still need ergonomic `gtk2`
wrappers; custom drawing and device configuration may need additional API work.

## ABI details that must remain

`GtkProgressBar` embeds a `GtkProgress` instance, and its class embeds the
corresponding class layout. Their fields remain as **private** `ProgressLayout`
and `ProgressClassLayout` types. They expose no deprecated widget API.

`GtkToolbar` contains a historical tooltip pointer. Its pointer-sized slot
remains private as `legacyTooltips`, so subsequent fields do not move. On the
current 64-bit illumos target, the rewrite preserves the previous sizes:
`TProgressBar` 176 bytes, `TProgressBarClass` 808 bytes, `TToolbar` 176 bytes,
and `TToolbarClass` 872 bytes. These are before/after layout checks, not a claim
that the entire historical binding has undergone a native ABI audit.

The status-icon `query_tooltip` callback now uses the existing modern
`PTooltip`, correcting its former use of deprecated `PTooltips`.

`HandleBox` and `TearoffMenuItem` are **retained**: they were not deprecated in
GTK2. Likewise, `ColorSelection` and `FontSelection` are not removed merely
because later GTK versions deprecated them. `Item` remains as the native base
class for menu items.

## Examples and regression tests

No existing example uses the removed widgets, so no example implementation
needed replacing. All example programs are rebuilt with deprecations treated
as errors, including the calculator.

`tests/headers/tmodernbindings.nim` no longer exercises CTree casts. It instead asserts
that removed public types/constructors are absent and that modern replacements,
related overloads, `HandleBox`, `TearoffMenuItem`, and modern tooltip callbacks
still compile. `tests/tgtk2.nim` creates hidden `ProgressBar` and `Toolbar`
widgets to exercise the retained native layouts.

```sh
nimble testModernBindings
nimble testBindings
nimble testUi
nimble testCalculator
```

The first two require no display. The latter two use hidden widgets and require
a display, but do not open visible application windows.
