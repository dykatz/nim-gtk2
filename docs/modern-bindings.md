# Raw bindings on modern Nim

This is a new SDK: **there is no legacy source-compatibility requirement**.
The calculator is the primary consumer and regression target. Obsolete aliases,
rename shims, and address-integer overloads are removed rather than maintained
for hypothetical callers.

The raw modules still describe the C ABI, while `gtk2ui` owns references and
converts Nim application concepts (strings, booleans, closures) at the boundary.
Modernizing does not mean replacing C pointers with GC-managed `ref` objects,
changing C structs into managed classes, or using one-byte Nim booleans for C
integer booleans. Native ABI correctness remains mandatory.

## Modern representations

The calculator previously produced 32 deprecation warnings on Nim 2.3.1.
The warnings came from obsolete Nim syntax/types, not GTK runtime failures.

| Obsolete construct | SDK representation |
| --- | --- |
| `{.deadCodeElim: on.}` | Removed: modern Nim already eliminates dead code. |
| `ByteAddress` | `uint` for address bits/arithmetic; deprecated CTree helpers have been removed entirely. |
| Cairo `PContext`, `PSurface`, `TContext`, etc. | Removed aliases: use `ptr Context`, `ptr Surface`, `Context`, etc. |
| Cairo status mapped to `AssertionError` or `IOError` | `CairoError`, a `CatchableError` with the native `status` field. A failed native operation is not a Nim assertion defect. |
| Old `nimrod_init` spelling | Removed; use `nim_init` in raw code or `gtk2ui.init` in application code. |
| Old X11 rename pragmas | Removed from `x`, `xlib`, `xutil`, and `xrender`; use their canonical names. |
| Xlib `cuchar` fields | `uint8`, preserving unsigned byte width. |
| `TFile` | `File` for the C `FILE*` in the optional Pango utility binding. |
| Implicit temporary `string` to `cstring` conversion | Keep a local Nim string alive and pass `.cstring` explicitly. |
| 32-bit `gsize` / `gssize` | Pointer-sized `uint` / `int`. |
| `GType = gulong` | `GType = gsize`, including on 64-bit Windows where C `unsigned long` is only 32 bits. |

The original GTK-family modules no longer use dead-code pragmas. The calculator,
core raw bindings, and the Cairo/FreeType/Xlib smoke test pass with deprecations
treated as errors. Cairo has no legacy pointer/type alias tail. GTK2-deprecated
widget families, including CTree and its helpers, have been
[removed entirely](deprecated-widgets.md).

Cairo errors can be handled uniformly:

```nim
try:
  cairo.checkStatus(status)
except cairo.CairoError as error:
  echo error.status, ": ", error.msg
```

All non-success native status values, including Cairo's `StatusNoMemory`, use
this error type. No native status is presented as a Nim `AssertionDefect` or
`OutOfMemDefect`.

## GLib size correctness

Use `gsize` (`uint`) for unsigned lengths and size-output variables, and `gssize`
(`int`) for signed lengths or documented `-1` sentinels. The former 32-bit types
could truncate lengths, misrepresent `GString` fields, and allow native functions
to write eight-byte outputs into four-byte Nim variables on a 64-bit host.

Do not change `gulong` itself to `uint`: it must continue to match the platform's
C `unsigned long`. Likewise, raw GTK `TWidget`/`PWidget` names are not inherently
invalid Nim types; the application-facing `gtk2ui.Widget` provides the clean
high-level API without confusing C struct pointers with managed references.

## Layout-related raw corrections

The layout wrappers also restore the native `gtk_notebook_set_tab_pos` binding.
`set_tab_pos` now calls GTK with `TPositionType`; the old OR-only private-bitfield
setter was removed rather than retained as a compatibility overload. Notebook
`set_tab_reorderable` / `get_tab_reorderable` now use native `gboolean`, not
one-byte Nim `bool`. Native `get_child1` / `get_child2` paned getters and widget
`get_visible` were added so wrappers need not read private struct fields.

## Feedback-related raw corrections

`TImageType` and `TMessageType` now have native `cint` enum width and include the
GTK 2.24 values `IMAGE_ICON_NAME`, `IMAGE_GICON`, and `MESSAGE_OTHER`. The native
header probe checks their widths and final values. Image clearing, named-icon
access, pixel sizing, statusbar message-area access, and widget sensitivity/default
eligibility use native methods rather than reading old private struct layouts.
This is not a full audit of the legacy Image/InfoBar/Statusbar structs.

## Dialog-related raw corrections

`TButtonsType` now has native `cint` width, checked by the C header probe.
Dialog content/action-area getters, `gtk_message_type_get_type`, and the plain
secondary-message formatter were added as native imports. GLib's `set_enum` /
`get_enum` (`g_value_set_enum` / `g_value_get_enum`) now resolve from **libgobject**,
not libglib. This repairs the functions used by MessageDialog properties; it is
not a full audit of the neighboring legacy enum/flags helpers.

## Text-related raw corrections

`gtk_text_buffer_get_has_selection` and `gtk_text_buffer_backspace` now use
`gboolean` for native boolean results/arguments rather than Nim `bool`.
TextView tab-acceptance getter/setter imports and `WRAP_WORD_CHAR` were added.
The header probe checks GtkTextIter storage size/final-field offset and
GtkWrapMode width/value. The ergonomic layer uses temporary, caller-allocated
iterators only; it does not inspect private TextBuffer/TextView record layouts.

## Model-related raw corrections

`PCellLayout` is now an actual pointer to an incomplete interface type, not an
empty value object. TreeModel/TreePath pointees are also marked incomplete.
Cell-layout text-attribute/packing imports, batched ListStore values-vector
imports, and the native TreeViewColumn owner getter were added.
`gtk_list_store_remove` now returns the native `gboolean` rather than discarding
its return type in the declaration. The header probe checks GtkTreeIter storage
and GValue size/field offset, important for caller-allocated value arrays. This
does not audit legacy private model/view/renderer record layouts.

## Hierarchical model-related raw corrections

TreeStore values-vector setter/insertion imports and the native TreeView
`expand_to_path` import were added. `gtk_tree_store_remove` now declares its
native `gboolean` result, matching the earlier ListStore correction. Managed
TreePath values copy indices instead of retaining borrowed GtkTreePath pointers;
all native path allocations are freed and temporary iterator/value storage uses
the existing native-header ABI probes. Private TreeStore/TreeView layouts remain
outside this audit.

## Proxy and row-reference raw corrections

Added an opaque TreeModelFilter handle and native construction, boolean-column
visibility, refilter, child-model, and path-conversion imports. Row-reference
pointers now point to an incomplete native type rather than aliasing untyped
`pointer`; the native model getter is also imported. The Sort child-iterator
conversion correctly returns `gboolean`. A native-header check covers GtkSortType
width/value. Proxy private layouts and custom comparator/predicate callbacks are
not audited or wrapped by this batch.

## Remaining scope

This is not a complete audit of every historical module. Other optional X11
extension modules still contain old alias pragmas, `cuchar`, and address
arithmetic; those are modernization work, not compatibility promises. The
optional `gtkhtml` module has pre-existing compilation failures. There is no
policy to preserve any of these obsolete APIs, and no warning category is
globally suppressed to hide them.

## Validation

```sh
nimble testModernBindings
nimble testBindings
```

These enforce deprecation-free calculator/core/smoke-test compilation. The
no-display native tests check GLib widths, `GString` layout, native size outputs,
pointer conversions, deprecated-widget exclusion, and typed Cairo errors. They load GLib/Cairo
but do not initialize GTK or open a window. `nimble testUi` and
`nimble testCalculator` provide hidden-widget integration checks.

Native runtime validation is on 64-bit illumos with Nim 2.3.1. Semantic checks
also pass for Windows amd64 and i386; those are not native runtime tests. Other
target ABIs still need native CI coverage. Pointer-width assertions are evaluated
for the target Nim is compiling.
