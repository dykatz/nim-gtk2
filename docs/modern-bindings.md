# Raw bindings on modern Nim

This is a new SDK: **there is no legacy source-compatibility requirement**.
The calculator is the primary consumer and regression target. Obsolete aliases,
rename shims, and address-integer overloads are removed rather than maintained
for hypothetical callers.

The raw modules still describe the C ABI, while `gtk2` owns references and
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
| Old `nimrod_init` spelling | Removed; use `nim_init` in raw code or `gtk2.init` in application code. |
| Old X11 rename pragmas | Removed from `x`, `xlib`, `xutil`, and `xrender`; use their canonical names. |
| Xlib `cuchar` fields | `uint8`, preserving unsigned byte width. |
| `TFile` | `File` for the C `FILE*` in the optional Pango utility binding. |
| Implicit temporary `string` to `cstring` conversion | Keep a local Nim string alive and pass `.cstring` explicitly. |
| 32-bit `gsize` / `gssize` | Pointer-sized `uint` / `int`. |
| `GType = gulong` | `GType = gsize`, including on 64-bit Windows where C `unsigned long` is only 32 bits. |

### Rich clipboard negotiation

RichClipboardOffer pins immutable native bytes/explicit plain fallback until native
clear notification, without retaining a source buffer or user callback. Native
get/clear handlers contain exceptions and release pins once, including replacement
failure paths. Dropping a token is not a clipboard-clear operation.

RichTextRequest requires explicit trust: false never requests native rich bytes;
true requests only the selected native atom and copies borrowed selection data
before return. Parsing and application observations happen at UI idle, using the
detached serialization decoder/tag policy. Missing targets may fall back to text;
malformed/denied rich replies are rejected without a silent downgrade.

Cancellation releases user captures/schema/view/format promptly while independent
native/source pins protect outstanding C callback data. Owner views cancel on
edits/destruction and buffer identity is rechecked before decode/delivery. Existing
plain paste/native key bindings are unchanged; no automatic untrusted native parsing
or live rich insertion is supplied. Hidden tests never claim/request selections;
isolated tests include foreign owners. ABI probes cover callback info width and
the new public selection target getter's native atom representation.

### Native rich-text serialization

Public raw rich-text registration, native codec callbacks, transferred atom arrays
and serialize/deserialize operations now use pointer-width GdkAtom/gsize, native
gboolean and GError**. C probes exercise wide values and exact callback ABI.

The ergonomic TextFormat owns a private registration buffer with immutable tag
creation policy; SerializedText owns copied binary bytes and native format identity.
Serialization uses an exact detached insert_range snapshot to avoid GTK2's
past-end image scan. Anchors/non-pixbuf U+FFFC are rejected before its native progress
bug. Imports decode into an unobserved new buffer, optionally sharing an existing
tag table only when creation is forbidden. No application callback runs mid-import.

Native section framing is checked before dispatch, but XML/pixdata remain trusted
native data, not a sandbox. The opt-in tests/headers/text_serialization.c diagnostic
and patches/gtk2-text-serialization.patch document native progress/error/cleanup
defects; installed libraries and native warnings are unchanged. See docs/gtk2.md
for policy, object limits and the expanded text example. Explicit rich clipboard
document transfer is covered above; live insertion, custom ergonomic codecs and
undo remain separate work.

### Text child anchors and embedded widgets

TextChildAnchor uses owned non-floating GObject handles and public buffer/iterator/
widget APIs only. Construction retains new() before insert(), avoiding GTK's
borrowed convenience return becoming dangling when a changed observer deletes the
new anchor immediately. Native buffer pins span the constructor/delete helper.

Shared SDK buffer identities use independent weak-notify/signal pins and weak
metadata entries: an anchor never owns its buffer or view. Native finalization
clears identity and queues one-shot UI-idle deletion observations. Disconnect,
owner finalization or delivery releases the corresponding captures/pins; callbacks
never run inside native text-segment widget cleanup. Existing synchronous buffer
changed/widget destroy callbacks still forbid unsafe native reentrancy.

Embedding checks buffer identity, live anchors, ordinary parenting/cycles and one
widget per anchor per view. Public widget lists are transfer-container snapshots.
Deletion, view destruction and buffer replacement follow GTK ownership without
private segment/layout access. C probes verify insert/deleted pointer/cdecl/gboolean
shapes; hidden ARC/ORC tests cover weak ownership and constructor-time deletion, and
isolated mapped tests exercise actual two-view inline allocation/cleanup.

### Multiple IconView selection

Fixed IconView models/layouts now support native selection modes, checked multi-row
operations, ascending copied paths/indices and stable displayed-model references.
Mode changes clear selected items with public calls, explicitly leaving BROWSE
before clearing through NONE. GTK2 has no public cursor/range-anchor reset; the SDK
does not inspect anchor_item or rebind the fixed model to simulate one.

Selection observers now coalesce at idle; the typed overload collects the final
selection there. Native callback data weakly borrows the view and destruction
cancels pending work. Activations copy a path/reference at emission and deliver
per-emission at idle, so user code cannot destroy native item state halfway through
GTK's selection/activation traversal. Legacy positional activation conveniences
share this deferred timing. Stable proxy references retain proxy coordinates, not
source identity; applications explicitly translate before source edits.

C probes check the public cursor getter's pointer-to-pointer/gboolean ABI. Hidden
ARC/ORC tests and isolated XTEST Shift/Ctrl+A/Return tests cover ownership, mode
transitions, native range selection and observer-driven teardown.

### Synchronous model functions and audited cell presentation

Custom sort comparisons, filter visibility and text cell-data functions use native
cdecl/gint/gboolean/pointer callback shapes, checked by C probes. The visible-function
setter and column queue-resize declarations were added with their public GTK2 ABI.
Filter's set-once native visible bridge is never reinstalled on predicate replacement.

Application functions receive copied paths/CellValues, never live GtkTreeIters or
renderer pointers. Comparators normalize signs before returning a gint. Functions
must be pure with respect to GTK: checked ObjectHandle access is rejected during
execution, and last ordinary object-state native releases are deferred to UI idle
so a native traversal cannot lose its object halfway through. This is not a sandbox
for raw calls or arbitrary user/controller destructors; those remain forbidden.
Exceptions have explicit equality/hidden/default-text fallbacks and are reported.

Native function data and GObject lookup roots have independent pins. Reinstalling
the same comparator for resort preserves its connection through GTK's destroy-then-
replace callback; replacing a function invalidates the old connection. Filter
predicate replacement uses a stable bridge with a new application state. Explicit
disconnection releases captures but callers explicitly refresh native caches.

Text functions validate and reset all managed presentation attributes per call,
including foreground and font override flags. A fixed owned pixbuf column broadens
rendering without exposing private renderer layouts or arbitrary property bags.
See docs/gtk2.md and TODO.md for contracts and the remaining renderer work.

### Entry completion and editable text input

EntryCompletion is an opaque non-floating GObject. Core setters/getters retain
native gint/gboolean/pointer/cdecl signatures; C probes verify match-selected's
completion/model/iter/data pointers and handled gboolean return. ComboBox's missing
public get_type declaration was added without copying native private layouts.

The SDK owns a fixed text model and popup-only configuration. It handles native
match-selected before its true-handled default, copies the match and commits at
UI idle so native popup code cannot continue after an application callback tears
its state down. Native objects are retained across the text setter; pending work
is generation/attachment checked and canceled on edits/replacement/detach/destroy.
Native matching and popup navigation remain GTK's implementation. No private
handler IDs or renderer/popup fields are inspected.

Editable ComboBoxText adds a retained public entry view, private-child removal/
destruction guards and copied/coalesced text observations. Existing text mutations
now validate UTF-8 before GTK. This is not arbitrary model/renderer rebinding or
inline/custom-provider completion.

### RadioAction and UIManager boundaries

RadioAction and UIManager are opaque native GObjects; GtkUIManagerItemType keeps
C enum width. Native probes check signed gint radio values, the two-instance
changed callback and pointer-width signed gssize (including -1) for UI loading.
Radio getters use public property/group APIs, never copied GTK private layouts.

The ergonomic UIManager freezes a retained SDK action schema while merging native
presentation nodes. XML preflight rejects missing commands before lazy GTK warnings;
merge identity tokens cannot retain or accidentally address another manager.
Native update/removal is guarded and pinned: reentrant close is postponed until
traversal returns, including last-handle release from a destroy observer. Teardown
removes UI references and drains native updates before native finalization.

Managed shortcuts use the existing native action closure machinery in the manager's
own GtkAccelGroup. No global accel-map entries are created; pre-existing paths or
foreign shortcut bindings are rejected. Public no-show-all protects action-managed
visibility across parent showAll. Raw mutable/shadowing schemas remain separate.

### GtkBuilder ownership and signal ABI

Builder/Buildable use opaque native pointers. add_from_string takes gsize, not
Nim int/cint; GError** and GtkBuilderConnectFunc retain exact native widths, pointer
levels, cdecl and GConnectFlags representation. C probes invoke constructor/loader
function pointers and the complete signal-connector callback through GTK headers.
No GtkBuilder private layout or internal name-data key is read by the SDK.

The ergonomic Builder owns a fresh UI document: close destroys XML-owned widgets,
invalidates shared widget states, disconnects retained non-widget SDK callbacks and
releases the native object table. Factories clean partial documents on GError failure;
this is not rollback or a sandbox for native constructor side effects. Core GTypes
are explicitly registered because GTK2's lazy GModule lookup is unreliable when
GTK is dynamically loaded locally by Nim.

XML handlers are collected using the scope-call full connector, copied, validated
against public GSignal metadata and explicitly mapped to closures. Only void/no-arg,
non-destroy declarations are supported; parameterized/return-valued/swapped/object
connections require typed SDK APIs or raw GTK. User delivery is deferred/cancellable,
not a guessed native signal signature or symbol-name autoconnection.

### GTK2 actions and native accelerators

Action, ToggleAction and ActionGroup are opaque non-floating GObjects; no GTK private
instance layouts are copied into the SDK. The raw declarations use exact cstring,
gboolean, pointer and cdecl signatures. Native C probes invoke constructor and
boolean accessors through the real GTK prototypes, without a display.

The ergonomic layer creates native menu/tool proxies and uses native action accel
closures with window-local GtkAccelGroups. It neither rewrites the global accel map
nor invents callback ABI. Activation/toggle handlers copy payloads and defer user
code until native post-activation has completed. Groups retain member SDK handles;
accelerator cleanup holds an extra native reference to make unregistration safe
regardless of field destruction order. Proxy visibility is action-managed through
public no-show-all, preventing a parent showAll from exposing hidden commands.

### Clipboard and drag/drop boundaries

PClipboard is now ptr to an opaque incomplete TClipboard, not a generic pointer.
Public selection data length/type/format/data getters, standard drag text-target
helpers and the selected-action query retain their C pointer/width semantics.
Native probes cover GtkTargetEntry/GtkSelectionData sizes/offsets, GtkDestDefaults/
GdkDragAction widths, clipboard callbacks and signed drop coordinates/unsigned time.
The SDK never substitutes managed strings/booleans into native callback signatures.

Clipboard requests use request_contents with native encoding fallback so valid
zero-length text can be distinguished from unavailable text (request_text/get_text
can conflate those in GTK2). Borrowed native selection data is copied immediately;
application delivery is at UI idle, and cancellation retains the opaque native
callback bridge until GTK actually completes. Drag/drop is COPY-only and manually
finishes tracked transfers; it never combines SDK finish with DEFAULT_DROP's
native automatic finish or guesses a MOVE/delete policy after deferred delivery.

### Rendering/input and rich-text ABI corrections

Copied input events are checked against C GdkEventKey/Button/Motion/Scroll sizes
and relevant offsets. GdkScrollDirection now explicitly has C-enum width rather
than Nim's small-enum storage. Public widget allocation/focus/mapped queries were
added with C-width gboolean and typed output pointers. Missing double/triple-click
and scroll event constants are available. Text-search flag constants now match
GTK2 (VISIBLE_ONLY = 1, TEXT_ONLY = 2), with native probes guarding both bits.

Scoped DrawContext.raw exposes the existing borrowed Cairo pointer ABI, not a
managed object substituted into native function signatures. Public GParamSpec
metadata initializes precise GValue property types for styles/renderers; GTK
private tag/renderer/tree structures are never inspected to implement these APIs.

### Desktop ABI corrections

GdkNativeWindow is uint32 on GTK2 X11, not a generic pointer or Xlib's unsigned
long Window; Win32 and Quartz define GDK_NATIVE_WINDOW_POINTER and retain pointer
representation. GdkAtom uses pointer-sized uint storage for its legacy numeric
macros (including Win64, where gulong would truncate it). Native event-selection
layout and window-ID width are checked against GTK/GDK headers.

StatusIcon string constructors take cstring, storage-type returns TImageType by
value, and get_geometry takes ptr PScreen for its GdkScreen** output. Its private
platform-specific storage is opaque rather than a guessed struct; scroll-event
uses PEventScroll. Tooltip getters are transfer-full strings. Misc get_alignment
and get_padding take single output pointers, not var pointer parameters. The raw
public Plug/Socket embedded/window queries are available without invoking their
private add/remove helpers. These ABI corrections intentionally do not preserve
incorrect old signatures.

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
invalid Nim types; the application-facing `gtk2.Widget` provides the clean
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

## Pixbuf-related raw corrections

`PPixbuf` now points to an incomplete native struct rather than untyped `pointer`.
GdkPixbuf colorspace, interpolation, alpha-mode, and error enums explicitly use
native C enum width; the missing incomplete-animation error value is included.
The file-load error parameter is a typed `GError**`. Native-header probes check
these enum widths and the added value. Managed object-valued model cells retain
pixbuf references before unsetting temporary GValues; selected IconView paths and
lists are copied then freed. Native pixel storage is never backed by borrowed
Nim memory. Animation and other legacy GdkPixbuf surfaces remain outside this
focused audit.

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
