# Additional non-deprecated GTK2 raw widgets

These additions target **GTK 2.24** and are exported by `import headers/gtk2`.
They are raw C-ABI bindings, **not** `gtk2` wrappers. No deprecated widget
families were restored.

The generated umbrella `src/headers/gtk2/newwidgets.nim` includes shared types
and per-header declarations from `src/headers/gtk2/newwidgets/`. It is itself
included by `src/headers/gtk2.nim`; see [source layout](source-layout.md). There are 588 generated added functions, covering the following widgets
and their supporting interfaces, data, enums/flags, and callbacks.

## GtkTextBTree private entry-point removal

Removed **57 _gtk_text_btree_* imports** across buffer/iterator/anchor/table
fragments, plus five adjacent private hooks: buffer get_btree, spew,
get_line_log_attrs, notify_will_remove_tag and mark_segment_new. No aliases,
compatibility stubs, native tree constructor/refcount/debug/check/validation facade
or replacement registry/stamp/cache is provided. Twelve now-empty fragments and
umbrella includes are removed. Source/compile guards cover all 62 former signatures.

The SDK never used these hooks. GTK2.24.33 gtktextbtree.h and existing buffer/iterator
source audits confirm they operate on internal tree ownership, segment mutation,
view registration/validation and iterator stamps. They are not public APIs merely
because a particular GTK binary exports a symbol. One obsolete invalidate_region
binding even omitted native cursors_only; it is removed, not repaired/exposed.
No private routine is called to test recovery or force validation, and no installed
GTK, private runtime state, warning policy or native source is changed.

Use these **public operation families**, not one-for-one tree aliases:

- Create/ref owning GtkTextBuffer handles, not trees. Public get_iter_at_offset,
  get_iter_at_line_offset (code points) and get_iter_at_line_index (UTF-8 bytes)
  establish fresh locations; byte indices must be valid character boundaries.
  Checked SDK offsets are stricter than native raw clamping/sentinels.
- Insert/delete text, pixbufs and child anchors through buffer APIs, preserving
  native signals, modified state, ownership and view invalidation. Removing anchor
  ranges performs native cleanup; never unregister anchors or free mark segments.
- Query public iterator tags/slices/visibility and tag-toggle traversal. get_tags
  returns owned GSList nodes with borrowed tags, not a tree-owned tag array: free
  the list and explicitly ref any tag needed beyond its owner/membership lifetime.
  Native slice text uses U+FFFC for object positions; plain text excludes objects.
- Use public mark identities/name lookup, gravity and buffer select_range/place_cursor
  for marks/selections. After edits, discard invalid iterators and reacquire via a
  retained mark/checked offset. There is no public replacement for tree stamps,
  segment mutation counters, arbitrary iterator-string parsing or segment ownership.
- Realized TextView get_iter_location/get_iter_at_location, get_line_yrange/
  get_line_at_y, get_visible_rect and buffer/window coordinate transforms expose
  native geometry without PTextLine/view-ID/cache access. Logical lines and wrapped
  display lines differ. Native layout timing/theme/BiDi/rounding remain GTK's; there
  is no public validity bit, tree validation budget, universal flush or repair API.
  SDK scroll-to-mark keeps its normal native deferred behavior, never realizes views.

Raw PIconSet is now a typed opaque GtkIconSet pointer, preserving pointer ABI. It
was previously untyped pointer, allowing a removed tree reference/unref call to
silently resolve to unrelated IconSet ref functions. Compile tests now reject those
positional calls and exact tree procedure types, while testing native IconSet refs.
Do not cast trees to IconSets/other opaque types; IconSets are native boxed refs,
not GObjects and not storage that applications should allocate/dereference.

Public instance/class ABI is unchanged, including opaque PTextBTree storage. Other
legacy private line/segment/layout APIs/types are **not** certified by this batch;
they remain separately scoped for removal/audit. Four preexisting line-data masks
were relocated beside their existing helpers in textlayout_4.nim, not newly added
or reinterpreted. No SDK accesses tree/flag storage. Seventeen new public signature
checks and an enum plus signed coordinate/out-pointer probe complement existing
buffer/class layout tests; no guessed private tree layout is probed. Public
TTextWindowType is corrected from Nim's default byte enum to native sizeof(cint),
with native-size and cross-target static checks.

Unrealized tests/tgtk2textbtreeaudit.nim covers all removals, typed IconSet refs,
Unicode line char/byte boundaries, tag lists/toggles, iterator reacquisition and
native image/anchor deletion. Isolated testMappedTextGeometry checks real wrapped
layout/coordinate round-trips and mark-based reacquisition after genuine edits,
without rebinding or fabricated cache resets. It requires an isolated display and
GTK2_TEST_VIRTUAL_DISPLAY=1; normal tests never realize/map, claim PRIMARY, request
selections or synthesize input. The text example labels native characters/logical
lines/clean state accurately and navigates by stable marks, not cached iterators.

## GtkTextBuffer raw migration: public state and signal lifetimes

Removed the private modified getter/unsigned setter and both mask/shift constants,
without aliases. Keep public get_modified/set_modified(PTextBuffer, gboolean);
GTK normalizes nonzero gboolean inputs. The old private OR-write could not clear
state and bypassed native notification. Opaque flag storage now uses native guint
instead of guint16; instance/class size and field offsets are checked. The class
now names the missing paste_done(buffer, clipboard) callback, followed by five true
reserved slots rather than six. This preserves native class size/order; it does
not add an SDK subclass or paste-completion observer API.

modified is native dirty state, not an undo/save/security policy. Its setter emits
modified-changed only on transitions and does not change text, selection, tags,
history or files. There is **no modified GObject property/notify::modified**.
SDK onChanged runs after the default changed handler sets the flag; observers are
synchronous, not coalesced or end-of-transaction snapshots. Native bulk replacement
can report deletion and insertion separately. Mark/tag/style/selection-only changes
do not inherently dirty the buffer. Constructor text starts clean by SDK policy;
marking clean after a real successful save is an explicit application decision.

Public cursor-position and has-selection properties are read-only. SDK cursorOffset
and selectRange use native place_cursor/select_range, not separate mark moves or
private cached fields. Offsets are code points, not bytes/graphemes; direction is
preserved and bounds are ordered. Cursor placement collapses selection. Invalid
coordinates/UTF-8 reject before mutations. onCursorMoved is synchronous native
notify::cursor-position: it may fire during edits or even when a select_range call
keeps the insert offset unchanged; it is not a generic final selection observer.
Raw bound-only mark movement need not notify cursor-position. No IME/edit/history
transaction is synthesized. Normal tests use buffers without views; realized views
can register selection clipboards/claim PRIMARY even when unmapped, so those tests
require an isolated display and explicit GTK2_TEST_VIRTUAL_DISPLAY=1.

**deleteSelection returns whether a nonempty selection existed**, not whether any
text was deleted. Interactive mode honors native tag/default editability and can
return true without altering readonly text, or delete only permitted portions.
Non-interactive mode is explicit programmatic deletion and does not enforce those
permissions. Readonly view defaults can themselves be overridden by tags; neither
dirty flags, selection pixels nor native presentation is authorization.

Basic text/insert/delete/selection/dirty-state mutations and removeAllTags pin their
native buffer during synchronous callbacks, including observers dropping last public
aliases. withUserAction retains/pins its original target, balances native begin/end
on exception/reassignment, and preserves nested outermost-only signals. It groups
notifications, not edits: changes are immediate, are not rolled back on failure and
GTK2 supplies no undo stack. Existing callback disconnect/capture-cycle policies
remain; pins do not permit destructive BTree reentrancy, nested event pumping or
iterator-invalidating edits from native traversal observers. No warning suppression,
implicit realization, private cache repair or buffer rebinding was added. Private
BTree entry points/guessed internals remain a separate removal audit.

Sixteen native signature/class checks and full instance/class offsets plus signed
insert/mark/paste callback probes cover ABI. Unrealized tests/tgtk2textbufferaudit.nim
covers dirty/signal ordering, Unicode/selection/invalidity, permissions/return value,
alias-drop pins, nested/exceptional original-target actions and purity guards.
Isolated testMappedTextBufferState verifies actual shared-view selection/paint,
dirty-only no-content-change and explicit readonly programmatic/native-interactive
behavior without synthetic input. The text example labels its clean flag action as
not a save/undo and its readonly control as a view default.

## GtkTextTagTable raw migration: public construction and traversal

Removed table_add_buffer/table_remove_buffer, formerly bound to the private
_gtk_text_tag_table_* registration hooks, without aliases or replacement bookkeeping.
Those hooks manipulate GTK's weak list of buffers and native BTree tag cleanup;
they are not an application attach/detach API. Use public text_buffer_new(table) for
initial sharing, and ordinary final unref for buffer teardown. Never write table
hash/anonymous/count/buffers fields, register a buffer twice, manually unregister it,
retarget private table pointers or repair native lists. ABI storage is retained,
not endorsed for access. No installed GTK changes or native patches are needed.

Source audit of GTK2.24.33 gtktexttagtable.c and gtktextbuffer.c confirms:

- text_tag_table_new returns an owned nonfloating GObject, not a widget/boxed value.
  text_buffer_new(table) refs its supplied table and internally registers itself;
  get_tag_table returns borrowed, lazily creating a default table if needed. The
  public GObject tag-table property is construct-only, not a live table setter;
  initial GtkBuilder/GObject construction likewise uses GTK's native registration.
  Each buffer unregisters itself on native finalization. Tables do not own buffers.
- table_add returns void in GTK2, requires a detached tag and unique named-tag names,
  and refs the tag. Duplicate names/foreign membership are native precondition
  violations, not an SDK merge or recovery path. Anonymous tags can coexist; a raw
  empty-string name is still named, unlike the SDK createTag("") anonymous policy.
- table_lookup returns borrowed or nil, not a fresh ref. Retain before removing the
  tag or releasing its owner. Explicit table_remove strips that tag's ranges from
  **all** registered buffers, removes membership, compacts priorities, emits
  tag-removed and releases the table's tag ref. Adding/name reuse does not apply
  ranges or make an old detached SDK handle a member again.
- Table finalization detaches/releases tags **without** emitting tag-removed. A
  retained raw tag does not own its table; a retained SDK TextTag deliberately owns
  its recorded table handle but still does not keep document buffers alive.
- table_foreach is a synchronous scope-call callback with borrowed tag/data and
  unspecified order, not priority order. The table must stay alive. Do not add/remove
  members during traversal, pump nested events, destroy relevant owners or let Nim
  exceptions cross the C boundary. A ref taken in the callback retains that tag,
  but does not legalize table mutation. If changes are needed, collect owned refs
  without mutation, return from foreach, then operate and release on the UI thread.

Sharing a table shares tag definitions, not text, cursors or ranges. Native
registration/removal cannot be emulated by SDK lists. Existing checked membership
uses public foreach with an internal pointer-comparison callback only; no user
callback/reflection/traversal wrapper, public table handle, rebinding/cache reset
or new source of application authorization was introduced. Existing pinning protects
specified native owners, **not every peer buffer**: raw callbacks must not destroy
other registered buffers or alter membership during table-wide removal/BTree
traversal. The private buffer registry cannot be safely enumerated or repaired by
the SDK. Readonly/view defaults and styling remain native, not security boundaries.

Seven additional constructor/type/class callback signature checks, full table field
offsets and C-to-Nim foreach/tag-changed/added/removed callback probes preserve ABI.
Unrealized tests/tgtk2tagtables.nim covers ownership, borrowed lookup retention,
named/empty/anonymous traversal, post-traversal removal, silent table finalization,
shared-buffer teardown and native range removal/name reuse. Compile/source guards
reject removed hooks and private-list access in implementations. Isolated
testMappedTextTags now checks both separate buffers repainting, table-wide removal
and peer finalization without private registration or a simulated cache reset.
The text example's anonymous highlight toggle performs real table-wide deletion
visible in both views, independently of property unsetting. Normal tests never
realize/map, claim PRIMARY, request selections or synthesize input.

## GtkTextTag raw migration: real override properties

Removed **48 private flag/padding helpers and 48 mask/shift constants**, without
aliases. Public native tag/table instance/class storage remains ABI-checked. Stale
pad1/pad2 masks actually address paragraph-background-set/accumulative-margin in
GTK2.24, not padding. No SDK code interprets those words or substitutes new masks.

Most old *_set names correspond to public gboolean GObject properties, but spelling
is not a blind underscore conversion: bg_color_set -> background-set, fg_color_set
-> foreground-set, bg_stipple_set -> background-stipple-set, fg_stipple_set ->
foreground-stipple-set, bg_full_height_set -> background-full-height-set. The
remaining real flags map to scale-set, justification-set, left-margin-set,
indent-set, rise-set, strikethrough-set, right-margin-set, pixels-above-lines-set,
pixels-below-lines-set, pixels-inside-wrap-set, tabs-set, underline-set,
wrap-mode-set, invisible-set, editable-set and language-set. Raw users must use
actual public GParamSpec/GValue types and lifecycle, not private word writes.
Padding has no public property. Paragraph-background and accumulative-margin are
real named policies, not replacements for obsolete pad helpers.

Assigning a tag property establishes an override: underline=false explicitly
requests no underline, and editable=false explicitly denies native interactive
editing where applicable. Unsetting the corresponding public *-set property removes
that tag's contribution, permitting lower-priority tags/view defaults to win. It
does not remove the tag's ranges, reset its stored value, or mean false. SDK
clearBold/clearItalic/clearUnderline/clearInvisible/clearEditable now complement
existing clearForeground/clearBackground through those actual properties. Getter
values are the tag's stored property, not a computed effective style or *-set flag.

SDK priority reads/sets native priority after checking actual membership with public
table_foreach. Values must be 0..<table size; invalid inputs are atomic. Priorities
are unique, higher wins and native reassignment shifts other ranks. Removed tags
or tags moved to a different table through raw APIs reject checked priority/range
operations; properties on a live detached tag remain native. Membership is not
inferred from a non-nil cached handle/name/private pointer. Tags retain their SDK
table handle, not a document buffer. Creation owns before native tag-added signals;
removal during that notification can return a valid but detached tag.

**Native priority is not a repaint command.** GTK2.24.33 set_priority only changes
ranks and emits no tag-changed notification. Fresh iterator-style queries reflect
ordering, while existing view layouts can stay cached until a genuine native style/
range invalidation. The SDK does not fake signals, detach/reapply tags, rebind
buffers or promise automatic redraw. Applications must account for native behavior;
authorization must not depend on cached pixels, priority or visibility alone.
Tag editability can override a view's default editability under GTK's rules.

Property/color/override helpers pin native tag and SDK table lifetimes through
notifications; range apply/remove and table removal also pin relevant buffer/tag/
table owners. Shared renderer property helpers pin their native emitter too. This
prevents premature final release, not arbitrary destructive table/BTree reentrancy:
raw observers still obey GTK traversal rules and must not pump nested events or
mutate a table during foreach. No generic property/reflection/tag-event or native
subclass API was added.

Ten native signature checks and tag/table layout/cdecl event probes cover ABI.
Unrealized tests/tgtk2texttagaudit.nim rejects every old helper/constant, validates
property metadata, false/unset/priority/membership and alias-drop lifetimes, plus
purity and removal during tag-added. Isolated testMappedTextTags requires
GTK2_TEST_VIRTUAL_DISPLAY=1 for inheritance/removal pixels and fresh priority
queries, without simulating a cache reset. The text example has an explicit unset
underline-override button, distinct from its manual value checkbox. Normal tests
never map/realize, claim PRIMARY, request selections or synthesize desktop input.

## GtkTextAttributes/Appearance raw migration and ownership

Removed **33 unsafe helpers and 34 mask/shift constants** across TextAttributes and
its embedded TextAppearance, without aliases. These include OR-only style setters,
render-only inside_selection/is_text state, realized state and padding manipulation.
Native public instance storage remains and is checked with sizeof/offsetof probes;
retained flag words/padding are not supported portable bitfield accessors.

Native `reference(PTextAttributes)` now correctly **returns PTextAttributes**, matching
GtkTextAttributes* gtk_text_attributes_ref(...). Capture or explicitly discard that
return; each successful ref adds ownership even when returning the same pointer.
Attributes are reference-counted **boxed values, not GObjects**: never use g_object_ref,
g_object_unref or the SDK ObjectHandle machinery on them. new/copy and
get_default_attributes return owned values; balance them with native unref. The
view-default getter returns a copy, not a borrowed view-owned pointer. Ref returns
an alias. GLib g_boxed_copy for this registered type also refs the same value, while
explicit gtk_text_attributes_copy makes an independent value, copying font/tabs and
referencing stipples appropriately. Language data follows native interned ownership.
Do not memcpy snapshots, manually edit their reference count or shallow-share owned
resource pointers. Direct public font/tab assignments require native allocation and
ownership discipline (including releasing any previous resource), not borrowed pointers.

copy_values copies source into an existing **unrealized** destination and preserves
the destination's native reference count. Self-copy is a native no-op. Realized here
is attribute color/resource state, not widget realization: never forge the bit to
bypass native checks. Raw owners should normally prefer new independent copies.

**Native ownership caveat:** source audit of GTK2.24.33 found that copy_values frees
destination font/stipples but overwrites existing tabs/paragraph-background color
without freeing them. Replacing already populated destinations can leak. The SDK
does not silently free private resources or patch the library. Optional source-only
patch: patches/gtk2-text-attributes-copy-values.patch (audited/dry-run, not validated
as a rebuilt GTK library). Tests use fresh tabs/paragraph-color destinations and
normal public copy/unref lifetimes; no installed GTK/settings are modified.

For style inspection, obtain an owned get_default_attributes(view), then apply
get_attributes(iter, values) for tag overrides at that iterator. Its gboolean tells
whether tags contributed attributes, **not** whether the resulting values exist,
whether text is visible/editable/selected, or whether an operation is authorized.
Unspecified fields retain the supplied defaults. A new attributes object alone is
not a view's font/theme defaults. These detached snapshots do not retain a live
view/buffer or track subsequent tags/theme/selection changes. Mutating an owned
snapshot does not update the document or view.

For application style changes, use public GtkTextTag properties/apply/remove APIs
(ergonomic tag.underline/invisible/editable, etc.). False clears a boolean value but
can remain an explicit override; it is not the same as removing a tag or unsetting
its property. Use native iterator editability/visibility APIs where needed, not
attribute bit guesses. Padding, allocated-color and render-only state have no new
SDK flag replacement. No shadow cache, palette realization, reflection/snapshot
wrapper or generic style authorization layer is introduced by this raw audit.

Eight native prototypes, pointer-return/cdecl checks and public layout probes plus
source/compile guards cover migration. Unrealized ARC/ORC ownership tests cover ref,
boxed aliasing, independent font/tab copies, self-copy/ref-preserving copy_values,
view-default/tag overlays and public tag clearing. Isolated testMappedTextAttributes
requires GTK2_TEST_VIRTUAL_DISPLAY=1 for native style pixels and detached snapshot
survival through tag changes/view destruction. The text example toggles the live
emphasis tag's underline property, not a copied attributes object. Normal tests
never realize/map, claim PRIMARY, request selections or simulate input.

## GtkTextMark raw migration: no guessed private body

Removed four mark-body helpers (visible/set_visible and not_deleteable/
set_not_deleteable), four mask/shift constants and both guessed TTextMarkBody/
PTextMarkBody declarations, without aliases. Those private BTree/segment details
are not GTK2 public types. The public GtkTextMark instance retains its opaque
segment pointer ABI slot; GtkTextMarkClass retains its four reserved slots. Native
size/offset checks cover these real header records, not invented private bodies.

| Old private-body access | Public GTK2.24 path |
| --- | --- |
| visible / set_visible(PTextMarkBody,guint) | get_visible / set_visible(PTextMark,gboolean) |
| name/tree/line body reads | get_name, get_buffer, GtkTextBuffer get_iter_at_mark |
| gravity inferred from segment/class | get_left_gravity; choose immutable gravity when creating a mark |
| not_deleteable flag | No general public flag getter/setter; do not forge deletion permission |
| guessed body tree-null/deletion tests | get_deleted and nullable get_buffer |

Native mark creation/addition APIs text_mark_new and add_mark are now bound.
Constructed marks are non-floating, transfer-full GObjects; on add_mark the buffer
takes its own reference to the mark. A mark itself does **not** keep its buffer alive.
Raw public add_mark supports detached marks under GTK's membership/name rules;
no new ergonomic reinsertion or mutable-gravity protocol is introduced.

Ergonomic createMark now owns text_mark_new **before** insertion, rather than
adopting the convenience create_mark's borrowed return. A synchronous native
mark-set handler may delete the mark before that borrowed return reaches the
caller. Owned-before-add keeps the returned handle valid; it can already be deleted.
Creation/move/delete/visibility operations pin relevant native objects through
callbacks. These pins prevent premature final release, not arbitrary destructive
reentrancy inside GTK's BTree/layout traversal; raw callbacks still obey native
rules and must not pump nested events or invalidate active native traversal.

TextMark.buffer explicitly returns an owning TextBuffer handle and raises on a
deleted mark. That returned handle may retain the buffer; the mark alone does not.
Deleted marks can retain readable name/gravity/visibility, but checked offset,
move/delete/scroll and buffer access reject lost/mismatched membership. Visibility
on a detached mark is native policy, not reinsertion. Built-in insert/selection
marks are protected by public buffer mark identity checks, not a guessed flag.
Deleting a mark is not deleting document text or an undo command. Visible mark
cursors do not change buffer text, selection, readonly rights or clipboard policy.

Eight prototype/cdecl pointer/boolean checks plus public instance/class layout
probes cover ABI. tests/tgtk2textmarkrawaudit.nim rejects private types/helpers/
constants and tests clearing, gravity, wrong buffer/protected marks, immediate
native deletion, dropped aliases, buffer lifetime and purity on unrealized views.
Opt-in testMappedTextMarks requires GTK2_TEST_VIRTUAL_DISPLAY=1 and an isolated
display for native cursor visibility/movement/deletion pixels and shared-view
gravity checks. Normal tests never map/realize, own PRIMARY, request selections or
simulate input. The text example can explicitly show its bookmark cursor and
retains that policy across its explicit document replacement.

## GtkTextView raw migration: public policy, not private flags

All **16 TextView bitfield helpers** and **16 mask/shift constants** are removed
without aliases. Instance storage/layout is retained for ABI, not public state
manipulation. The old OR-only setters could not reliably clear policy and bypassed
GTK synchronization. Worse, obsolete just_selected_element/disable_scroll_on_focus
masks correspond to accepts_tab/width_changed positions in GTK2.24, not the states
their names claimed. Do not translate those masks into a different private write.

| Removed helper pair | Real public replacement |
| --- | --- |
| editable / set_editable(PTextView,guint) | get_editable / set_editable(PTextView,gboolean) |
| cursor_visible / set_cursor_visible(PTextView,guint) | get_cursor_visible / set_cursor_visible(PTextView,gboolean) |
| overwrite_mode / set_overwrite_mode(PTextView,guint) | get_overwrite / set_overwrite(PTextView,gboolean), now bound explicitly |
| need_im_reset, just_selected_element, disable_scroll_on_focus, onscreen_validated, mouse_cursor_obscured and setters | No equivalent public flag getter/setter |

Use existing public accepts-tab policy for actual Tab behavior, not an obsolete
selection bit. IM reset actions, focus/scroll APIs and redraw requests are not
private-state flag replacements. No fabricated state query, cache validation,
scroll suppression, drag reset, model/buffer rebinding or key simulation is added.

Ergonomic TextView editable/cursorVisible/acceptsTab and new overwriteMode use native
boolean methods and pin the native view through notification. Policies are per view:
shared buffer identity/text/selection/modified state is not rewritten. Readonly does
not forbid explicit TextBuffer edits. Hiding the caret neither hides text nor forbids
editing. Native overwrite/IME/selection replacement and Insert binding remain GTK
behavior; programmatic buffer insertion is still insertion, not synthesized typing.

**Stock GTK2 overwrite caveat:** changing overwrite on an unrealized TextView can
invalidate a NULL layout/GdkWindow (even a public geometry query does not establish
all windows). The checked setter rejects a changing policy before realization with
ValueError; assigning the unchanged policy is safe. It never realizes/maps a view,
examines private fields or suppresses warnings. Raw set_overwrite remains the native
API with native behavior. Configure changed overwrite after normal realization,
not by realizing an editor in a normal hidden test: realization/selection can affect
PRIMARY. The conservative precondition remains even on externally patched GTK.

Optional native reproducer: tests/headers/textview_overwrite.c, run with
G_DEBUG=fatal-warnings (stock 2.24.33 fails). Optional GTK SOURCE patch:
patches/gtk2-textview-overwrite-layout.patch gates cursor invalidation on realization.
It was audited/dry-run against GTK2.24.33 source, not installed or tested as a rebuilt
GTK library. The SDK never applies it or changes installed libraries/settings.

GtkTextViewClass also lacked backspace before clipboard methods. The slot now has
its native name, following clipboard/toggle/move_focus offsets are corrected, and
seven true reserved slots remain with total class size unchanged. Native probes
check instance/class sizes/selected offsets, eight boolean prototypes and action/
focus callback signatures/cdecl direction arguments. This is not an ergonomic
subclass API, nor a license for runtime access to retained private fields.

Hidden tests/tgtk2textviewrawaudit.nim reject every removed helper/constant, test
unrealized-safe bool clearing, shared-buffer isolation, notification pins, purity
and destroyed handles, plus explicit unrealized overwrite rejection. Source guards
cover both fragments and the umbrella. Isolated testMappedTextViewPolicy requires
GTK2_TEST_VIRTUAL_DISPLAY=1 and Unix X11 XTEST for actual overwrite/Insert/selection,
readonly, hidden-caret Tab insertion and focus traversal. Normal tests do not
realize/map, own PRIMARY, request selections or fake input.

## GtkEntry raw migration: no private bitfield helpers

The remaining **20 GtkEntry bitfield getter/setter helpers** and **26 Entry mask/
shift constants** have been removed without aliases. Constants formerly placed in
`menu_2.nim` were Entry implementation details, not menu APIs or ABI storage.
`entry_types.nim` storage is unchanged: retained fields describe native layout,
not permission to read/change private state as an application transaction.

| Removed Entry helper pair | Supported public replacement |
| --- | --- |
| `editable` / `set_editable(PEntry,guint)` | `get_editable` / `set_editable(cast[PEditable](entry),gboolean)` (GtkEditable interface) |
| `visible` / `set_visible(PEntry,guint)` | `get_visibility` / `set_visibility(PEntry,gboolean)` (text concealment, **not** widget show/hide) |
| `editing_canceled` / `set_editing_canceled` | GtkCellEditable's public boolean `editing-canceled` GObject property, only in its native editing-session contract |
| `in_drag`, `cache_includes_preedit`, `need_im_reset`, `cursor_visible`, `in_click`, `is_cell_renderer`, `mouse_cursor_obscured` and corresponding `set_` helpers | No equivalent public flag API; do not invent replacements or inspect private state |
| Previously removed `overwrite_mode`, `has_frame`, `activates_default` unsigned helpers | Native `get_...` / `set_...(PEntry,gboolean)` APIs |

Native setters perform synchronization and can clear a policy. Old helpers ORed
bits into private words, bypassed GTK behavior and could not reliably clear them.
Use actual gboolean arguments (not unsigned masks) and explicit interface casts.
For ergonomic code use Entry.editable, textVisible, overwriteMode, hasFrame and
activatesDefault via `import gtk2`. Editable's checked setter now also pins the
native entry across property notification, like the other checked Entry policies.

`editing-canceled` is **not** an undo command, general cancel operation, or proof
that a renderer session exists. Raw property users must use public GParamSpec/
GValue metadata and observe GtkCellEditable's actual lifecycle. The SDK's copied
renderer edit/commit API remains the application-level path. No new ergonomic
property/reflection/subclassing API is introduced here.

Public IM-context reset/filter actions, layout/preedit index conversions, DnD
signals and cursor/selection APIs are not substitutes for writing/querying these
private flags. This audit does not synthesize an IME reset, cancel a drag, hide a
caret, forge renderer identity or detach/rebind native models. Generic widget
visibility, TextView cursor visibility and GtkEntry password concealment differ.

The related native record audit also corrected **GtkEntryClass slot names**:
`backspace` now precedes clipboard callbacks, `toggle_overwrite` is at its proper
slot, and `get_text_area_size` replaces incorrectly named padding. Two real reserved
slots remain, with total class size unchanged. No raw subclass implementation is
provided. Entry instance size/selected offsets and class size/slot offsets are
checked against GTK2 headers; callback/prototype probes verify gboolean interface
signatures and signed gint*/cdecl text-area arguments. These developer probes do
not turn private fields into a supported runtime API.

`tests/tgtk2entryrawaudit.nim` rejects all removed helper pairs/constants at compile
time, exercises real boolean clearing and typed public property access on
**unrealized** widgets, and checks combo/SpinButton and editable-notify lifetime.
Header-layout tests reject reintroduced Entry masks/private accesses. Existing
isolated `testMappedEntryEditing` covers native readonly keyboard behavior; no new
mapped test is needed for removal-only helpers. Normal tests never map/realize
entries, own PRIMARY, request selections or manipulate desktop input.

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
| `CellView` | `cell_view_new`, `cell_view_*` (deprecated renderer getter omitted) |
| `HSV` | `hsv_new`, `hsv_*`, `rgb_to_hsv` |
| `OffscreenWindow` | `offscreen_window_new`, `offscreen_window_*` |
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

The existing file chooser declarations also use the correct title/action button
constructor signature, focus-on-click symbol, and GtkWidget return from the
varargs dialog constructor. PFileChooser is an opaque interface pointer, not a
fake Dialog instance layout. Its action/error enums have C width; FileFilterFlags
is a combinable distinct cint. FileChooserButton's private data is opaque and its
class includes all seven native reserved pointer slots. On Windows, filename APIs
use the same `_utf8` exports selected by GTK2's C headers. Native ABI probes cover
the button/class and filter-info layout plus the filter callback's flags/strings.

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
| `print_unix_dialog_get_page_setup` | Borrowed PageSetup; ref or copy if retaining |
| `page_setup_unix_dialog_get_page_setup` | **Full object ref in GTK2.24 implementation, despite transfer-none annotation**; `g_object_unref` |
| `page_setup_unix_dialog_get_print_settings` | Borrowed, nullable settings |
| `page_setup_get_paper_size` | Borrowed boxed paper; copy if retaining |
| `print_settings_get_paper_size` | Newly allocated boxed paper; `paper_size_free` |
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
The generated symbol manifest is `tests/headers/new_widget_symbols.txt`.

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
nim r --path:src --warningAsError:Deprecated tests/headers/tnewwidgets.nim
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
callback invocation, including Layout/HandleBox instance/class sizes and child
signal argument order. It checks GLib gsize/GType/GObjectClass widths first. On
64-bit illumos/Solaris it selects `/usr/lib/64/pkgconfig` so a default 32-bit
`glibconfig.h` cannot produce misleading class-layout results. Native tests currently run on 64-bit illumos with GTK 2.24.33;
Windows/macOS semantic checks are not substitutes for native platform ABI tests.
