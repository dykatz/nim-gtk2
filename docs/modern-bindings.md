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

### Copied URI drop acceptance

`onUriDrop(observer, accept = predicate)` now optionally evaluates a fixed
`UriDropPredicate` over independent copied values before native finish. Nil retains
valid-COPY transport acceptance; false/errors reject without an idle observation.
Invalid/canceled/non-COPY data never invokes the policy. Predicate identity is fixed
for the attachment, not a snapshot of arbitrary captured application state.

The shared synchronous-function guard denies checked GTK access, clipboard lookup,
site mutation/disconnect and nested GUI work; ordinary final releases wait for idle.
Guard restoration and exception containment precede native completion. Disconnect/
destroy clears policy captures even while independent wire/receiver pins drain;
tokens alone do not cancel. This is not a sandbox, asynchronous acceptance, file
permission check, full URI parser or MOVE implementation. Observers remain post-
finish and may reenter GTK only after acceptance.

The raw public `gdk_drag_drop_succeeded` getter and native prototype/full gboolean
probe support actual X11 wire-bit regression checks, unlike GTK2's success-like
source `drag-end` reporting. Hidden lifetime/purity and real local/foreign predicate/
error/cancellation/copy/deferred-release tests extend the existing URI tasks. Desktop
pads demonstrate a nonempty copied namespace policy without file opening. See
[URI guide](gtk2.md#uri-copy-only-dragdrop-pads). Private audits remain deferred.

### URI COPY-only drag/drop functionality

Ordinary DrawingArea/EventBox pads now offer URI-only drag-begin snapshots and
copied per-drop idle observations. Native action is checked twice; empty lists
succeed, malformed/unavailable/text/MOVE drops do not deliver. Completion uses
exactly one finish/delete=false per tracked request and never DEFAULT_DROP.
Observation is not application authorization, pre-finish acceptance or automatic
file opening. Source URI values can be replaced atomically for later drags.

Disconnect/destroy promptly releases observations, but separate wire/context/widget
pins and an unrealized same-screen receiver survive until the true native reply/
timeout. This avoids GTK's removal of the destroyed pad's signal handlers. A native
URI destination reservation blocks replacement while draining; cleanup gets its
own idle pin and never accesses private GTK state or realizes/maps the receiver.
GTK2's XDND source-success reporting is not destination acceptance proof; no patch,
extra finish or simulated history/cancel is added.

Five public prototypes/three callback signatures and signed-coordinate/full unsigned
payload probes supplement hidden ownership/purity/conflict tests and isolated real
XTEST/local/foreign/delayed-reply regressions. Desktop example adds URI inspection
pads. See [URI pad guide](gtk2.md#uri-copy-only-dragdrop-pads). Copied synchronous acceptance is described above; asynchronous acceptance and
images/binary/MOVE remain separate, and private layout audits remain deferred.

### URI clipboard functionality

Copied `UriList` values, URI-only ownership offers and cancelable/owner-bound
asynchronous `requestUris` now expose public GTK2 text/uri-list transfer without
launching or opening data. Empty/absent/rejected results are distinct; malformed
replies never downgrade to text or expose partial lists. Native comment/line parsing
runs only after UTF-8/NUL/type/format checks, then ASCII scheme/escape token checks;
this is not full URI authority validation or application authorization.

Independent native offer/wire/idle pins preserve lifetime when tokens are dropped,
requests canceled, owners destroyed or callbacks reenter/throw. Full `gchar**` native
get results are copied/freed with `g_strfreev`; setter inputs stay live until GTK
copies them. Two new raw public prototypes and native signature/char**/gboolean
callback probes accompany hidden and isolated ARC/ORC regressions. The desktop
example offers/inspects only on explicit clicks. See [URI guide](gtk2.md#uri-clipboard-transfers).
URI pads are described above; images/binary and MOVE remain separate, and private
layout audits are deferred.

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

### Raw GtkTextLine/private segment audit

Removed 39 private imports (including unprefixed private segment split), four
line-data helpers/four constants, guessed segment bodies/vtables and unused private
node/tag-info types. Line/line-data pointers needed by remaining TextLayout calls
are opaque, not public concrete layouts. Six fragments/includes are removed and
the public table foreach callback declaration moved intact to its table types.
No private allocation/refcount/cache/registration repair or ABI guess is added.

Fourteen public signature checks, iterator size/alignment/anchor storage offsets
and an above-BMP gunichar callback probe extend ABI coverage. Unrealized tests cover
removals, CRLF/Unicode counts, iterator-copy storage versus buffer lifetime, borrowed
list elements and anchor cleanup. Isolated geometry tests add real display-line
navigation/wrap policy changes; the text example toggles native wrap in both views.
Remaining private TextLayout/display/cursor APIs/types await their own audit.
See [line migration](raw-widgets.md#gtktextline-and-segment-removal-opaque-internals-public-iteration).

### Raw GtkTextBTree private entry-point audit

Removed 57 private BTree imports plus five adjacent buffer/debug/mark-segment hooks,
without aliases. Twelve empty fragments/includes are gone; public instance/class
storage and opaque tree pointers remain. No SDK tree access, stamps/validation/cache
repair, private ownership wrapper or synthetic rebind/reset. The subsequent line/segment audit above removes those
APIs/types/masks; remaining TextLayout/display/cursor internals stay separately scoped.

PIconSet is now a typed opaque pointer to prevent accidental tree ref/unref fallback;
TextWindowType uses native sizeof(cint), not a byte enum. Seventeen public signature
checks, native enum width, signed coordinate/out-pointer probes and all former
call-signature/source guards accompany Unicode line char/byte, tags/toggles, stable
marks and image/anchor tests. Isolated actual wrapped geometry/transform/reacquisition
coverage uses public APIs only; no ordinary test realizes widgets or claims PRIMARY.
The text example reports native logical counts/clean state and navigates by marks.
See [tree migration](raw-widgets.md#gtktextbtree-private-entry-point-removal).

### Raw GtkTextBuffer flag/public-state audit

Removed private modified-bit getter/unsigned setter and two constants, preserving
public gboolean state APIs. Opaque storage now uses guint; the class names paste_done
before five actual reserved slots. Sixteen signature checks, full instance/class
offsets and signed insert/mark/paste callback probes verify native ABI.

Public dirty/cursor/selection signals remain synchronous/native, not transactions;
modified has no GObject property. deleteSelection reports nonempty selection, even
when interactive permissions prevent edits. Native buffer pins protect basic
mutations/removeAllTags and original-target user action lifetime; groups balance
on exceptions but do not defer/rollback edits or provide undo. No private BTree
cache/history/registration repair, implicit realization or warning suppression.

Unrealized ARC/ORC state, Unicode, permissions/returns, alias-drop, nesting/purity
and removal guards accompany isolated shared-view selection/pixel coverage. The
text example distinguishes mark-clean from saving and readonly view defaults from
immutable buffers. See [raw migration](raw-widgets.md#gtktextbuffer-raw-migration-public-state-and-signal-lifetimes).

### Raw GtkTextTagTable private-hook/traversal audit

Removed both private buffer registration bindings without aliases. Public native
construction/final release manages membership: no manual registration or private
list access. Raw table/tag/buffer ownership, silent table finalization, named versus
anonymous tags, synchronous unordered borrowed foreach and post-traversal changes
are documented separately from SDK retained-table handles. No mirror/traversal API
or synthetic rebind/reset is introduced. Raw destructive peer teardown during
native removal remains unsupported; lifetime pins do not cover every peer buffer.

Seven new native signature/class callback checks, full table offsets and foreach/
class callback probes complement compile/source guards. Unrealized ARC/ORC tests
exercise shared-buffer cleanup and ownership; isolated existing tag tests now
check separate-buffer paint/removal/peer finalization. The text example adds an
anonymous highlight tag toggle with real table-wide deletion.
See [table migration](raw-widgets.md#gtktexttagtable-raw-migration-public-construction-and-traversal).

### Raw GtkTextTag public-property audit

Removed 48 private flag/padding helpers and 48 constants without aliases. Native
instance/class/tag-table ABI remains checked, with ten signature/cdecl event probes
and compile/source guards. Real public *-set properties remove contributions; false
assignments remain explicit overrides. New SDK clearBold/Italic/Underline/Invisible/
Editable helpers complement color clears. Stored getters are not effective style.

Checked native priority validates membership/range; priority changes shift ranks
but GTK2 emits no style invalidation, so no automatic repaint is promised or faked.
Property/range/table operations pin tag/table/buffer owners as appropriate; shared
renderer property helpers also pin emitters. Unrealized ARC/ORC tests cover metadata,
false/unset/membership/priority, alias-drop lifetimes and guards. Isolated native
pixels cover inheritance/removal and fresh priority queries without model rebinding.
See [raw migration](raw-widgets.md#gtktexttag-raw-migration-real-override-properties).

### Raw GtkTextAttributes/Appearance audit

Removed 33 helpers/34 masks without aliases, preserving native storage. Corrected
reference(PTextAttributes) to return its native pointer. Attributes are refcounted
boxed values, not GObjects; new/copy/view-default copies require unref, refs/boxed
copies alias, explicit copies isolate owned font/tabs. Defaults plus iterator tag
overlays inspect style; returned gboolean means tag contribution, not permission.
Detached snapshots do not mutate or track a live view/document.

Eight prototype/pointer-return and layout probes, compile/source guards and
unrealized ARC/ORC tests cover ownership/self-copy/default overlays. Isolated native
pixels verify tag changes versus detached values and survival after view teardown.
The text example uses a real tag underline property, not attribute bit edits.
Native 2.24.33 copy_values source leaks old destination tabs/paragraph color; optional
source-only patch is separate, not installed or validated as a rebuilt library.
See [raw ownership guide](raw-widgets.md#gtktextattributesappearance-raw-migration-and-ownership).

### Raw GtkTextMark private-body/ownership audit

Removed four body helpers/four masks and guessed TTextMarkBody/PTextMarkBody types
without shims. Public mark visibility/name/gravity/deletion/buffer APIs replace
private reads; not_deleteable has no general public flag replacement. Native public
instance/class storage is unchanged and checked against headers, with eight
prototype and cdecl pointer/boolean probes. Compile/source guards reject regression.

createMark owns a non-floating text_mark_new before add_mark: a raw mark-set
listener may delete the mark before a borrowed convenience return arrives. Native
lifetime pins cover creation/move/delete/visibility. Mark handles do not retain
buffers; explicit TextMark.buffer returns an owning buffer handle or raises if
deleted. No private state, reinsertion/gravity mutation, fake deletion or undo is
introduced. Unrealized ARC/ORC tests cover synchronous deletion/dropped aliases,
gravity/public policies/guards; isolated pixel/shared-view tests cover rendering.
See [raw migration](raw-widgets.md#gtktextmark-raw-migration-no-guessed-private-body).

### Raw GtkTextView public-policy audit

Removed 16 raw private-bitfield helpers/16 constants without aliases, including
obsolete masks whose names do not match GTK2.24 fields. Public gboolean methods
replace editable/caret/overwrite helpers; private IME/cache/focus flags have no
invented replacement. Instance storage remains, and native class backspace plus
clipboard/toggle/move_focus offsets are corrected with seven true reserved slots.
Native size/offset/prototype/cdecl probes and source/compile guards cover ABI/removal.

Existing TextView editable/cursorVisible/acceptsTab and new overwriteMode pin native
lifetime. Shared buffer text/identity/selection is not changed by view policy. A
changing overwrite setting requires realization: stock GTK invalidates missing
layout/windows before that. No implicit realization, private/runtime repair or
warning suppression is used; optional source patch and native diagnostic are
separate. Unrealized ARC/ORC tests reject that precondition and cover safe bools,
pins and guards; isolated XTEST covers actual editing, Insert, caret and Tab/focus.
See [raw migration](raw-widgets.md#gtktextview-raw-migration-public-policy-not-private-flags).

### Raw GtkEntry private-flag audit

All remaining 20 raw Entry bitfield helpers and 26 mask/shift constants are removed,
without compatibility aliases. Instance ABI storage remains; public GtkEditable
boolean methods and Entry text-visibility APIs are the supported policy path.
GtkCellEditable editing-canceled is a public typed property, not a generic undo or
cancel operation. Private drag/cache/IME/click/caret/renderer flags have no equivalent
public getter/setter; no shadow state, reset simulation or model rebinding is added.

Native-header probes also exposed/fixed misnamed GtkEntryClass backspace/clipboard/
toggle/text-area slots with class size unchanged. Size/offset/prototype/cdecl probes,
compile rejection for every removed helper/constant, static source guards and
unrealized ARC/ORC migration/lifetime tests cover the change. Entry.editable now pins
native lifetime through raw notify; inputs demonstrates readonly policy. See the
[raw migration inventory](raw-widgets.md#gtkentry-raw-migration-no-private-bitfield-helpers).

### Entry progress feedback

Checked progressFraction/progressPulseStep float64 properties and progressPulse()
use public gdouble APIs, pinning native lifetime through notification/drawing work.
Finite 0..1 validation is atomic, including preserving activity on rejection.
First pulse resets fraction to zero without notify::progress-fraction; fraction zero
is not an activity query. Explicit fraction assignment, even zero, ends activity.
No private/shadow mode, timer, event pump, job runner or simulated text is added.
Native step endpoints, bounce, RTL/style and hide/show remain native policy.

Unrealized ARC/ORC tests cover notification semantics, guards, pins and unchanged
text/selection/completion/icon/read-only/password/combo/SpinButton state. Five
prototype checks and a precise gdouble/pulse callback probe cover ABI. Isolated
opt-in offscreen pixel/geometry tests cover rendering and clear/activity transitions;
inputs offers requested fraction, pulse-once and explicit clear controls.

### Entry editing/concealed-text presentation

Native overwriteMode/hasFrame bool controls and invisibleChar uint32 scalar policy
use public GTK getters/setters. Zero deliberately means explicit blank feedback;
surrogates/out-of-range scalars reject atomically. invisibleCharSet uses the public
GObject property and unsetInvisibleChar restores GTK's font-selected default. All
mutations, including existing textVisible, pin the native object across callbacks.
Obsolete unsigned overwrite/frame bitfield helpers are removed without shims;
ABI storage remains, with nine prototype and 32-bit gunichar checks.

Typed overwrite/Insert/IME behavior stays native; programmatic insertText remains
GtkEditable insertion. No key simulation, private flags, undo/numeric transaction,
secret storage transformation or implicit completion-history reset is added. Hidden
ARC/ORC unrealized tests and isolated keyboard/PRIMARY regressions cover combo and
inherited SpinButton behavior, guards, atomicity, visibility and notification lifetime.

Password mask is presentation, not a security/clipboard boundary. Native PRIMARY
can return displayed glyphs/spaces and GTK password-hint characters; no global hint
settings or ownership behavior is suppressed. SDK selectedText/copy/cut safeguards
remain unchanged. Inputs has a separate non-secret mask-policy sample.

### Entry icons and copied button observations

Raw GtkEntryIconPosition is a C-width enum; icon getters/setters retain native
pixbuf/string/gboolean signatures. Pixbuf and name getters are borrowed natively
(ref/copy in the SDK); tooltip text is transfer-full (copy/free). Configuration uses
public GTK APIs with pointer pins, validated positions/UTF-8 and plain tooltips,
not private icon records, internal children or markup. Empty image clears retain
native per-position policies; rendered named-icon pixbufs can be retained safely.

onIconEvent copies EntryIconEvent(position, ButtonEvent) before returning to GTK;
application code runs at UI idle, not inside icon press/release traversal. It is
not a clicked command: preserve button/multi-press/outside-release semantics and
leave gesture/authorization/text edits to application policy. No password text or
borrowed event/window pointer escapes. Readonly/password icons remain native.

Per-position generations cancel stale configuration events; hide/unmap/destroy,
final sensitivity/public GdkWindow viewability checks and per-listener revalidation
protect deferred delivery, including ancestor windows hiding without child unmap.
Native/qdata/source pins retain bridges, not widgets; non-owning tokens release
captures on disconnect and owner cleanup. Explicit GUI cycles/raw reentrancy remain
application responsibilities. Inputs, unrealized ARC/ORC lifecycle tests, native
icon/prototype/button ABI and isolated real-icon pointer regressions cover the API.
Stock/GIcon providers, drag protocols and markup remain separate work.

### Entry limits/presentation/default activation

maxLength validates 0..65535 native code points; zero retains GTK's stock allocation
ceiling (65535 total bytes including NUL), not unlimited UTF-8 capacity. widthChars
accepts only -1 or a nonnegative gint; alignment validates finite 0..1 and crosses
FFI as gfloat; activatesDefault uses gboolean and actual native default handling.
Default response choice/sensitivity/authorization remain explicit application policy.

GTK truncates/emits changed before storing max-length. A pinned scoped policy marker
therefore defers existing/new SDK Entry changed/activate and parent ComboBox changed
observers until committed-state idle delivery; ordinary/inline timing otherwise stays
as documented. Native/state capture cleanup is guarded by pointer pins, without
private field writes or model rebinding. Max changes invalidate queued SDK completion
work but do not implement atomic validation, filter long choices or fake rollback.
SpinButton/native clipboard/IME behavior remains GTK's own.

Raw alignment's incorrect PWidget argument is corrected to PEntry, with its native
gfloat getter added. Obsolete unsigned activates-default bitfield overloads are
removed: only the native getter/gboolean setter is used. ABI storage remains intact.
Expanded inputs/dialog examples, unrealized ARC/ORC truncation/lifetime tests, eight
prototype/native scalar probes and isolated Return/default/completion regressions
cover the contract. See docs/gtk2.md for character-vs-byte and callback details.

### Entry cursor/selection observations

onSelectionChanged(Entry) exposes copied EntrySelection coordinates through an
idle-coalesced, deduplicated EntrySelectionConnection, optionally initial=true.
The notify::cursor-position/selection-bound handlers only schedule: GTK still
recomputes/updates PRIMARY after paired notification thaw. Sampling and user code
run at idle, including completion previews and PRIMARY loss, never as synchronous
selection decisions. Same-coordinate text changes are deliberately not events.

Per-native-closure and per-source data pins are independent of widget ownership;
weak widget pointers are invalidated on destroy/closure teardown. Retained tokens
or queued sources do not retain unparented entries. Explicit disconnect pins native
teardown, removes hooks/bookkeeping and promptly releases captures. Closure-finalize
cleanup never refs a finalizing widget. Reentrant edits schedule later snapshots,
self-disconnect/destroy is safe, exceptions are contained and pure model functions
cannot register/disconnect. Payloads never copy selected/password text.

Expanded inputs, unrealized ARC/ORC lifecycle tests, native notify/closure ABI and
isolated PRIMARY/keyboard/completion-emitter regressions accompany the contract.
No selection requests, realization or ownership changes are caused by observation.

### Entry Unicode cursor/selection

EntrySelection copies ordered bounds and directed anchor/cursor in Unicode code
points. Public GtkEditable APIs supply native gint/gboolean offsets and allocated
get_chars strings; selectedText copies/frees the latter and rejects password text.
Both range endpoints validate before side effects; explicit collapse/range helpers
use select_region, preserving native PRIMARY ownership updates. Read-only selection
is supported, including protected combo children and inherited SpinButton text.

Entry.focus now restores selection direction, with native/state pins and destruction/
bounds checks. Valid moves cancel queued SDK completion work without rewriting native
preview/history or simulating input. Getters and mutators share the synchronous-model
handle guard; copied snapshots remain ordinary values. Copied selection observers
are described above.

Realized-but-unmapped entries can claim PRIMARY; unrealized ones cannot. Hidden
ARC/ORC tests assert unrealized state throughout (including focus/draining), while
explicit isolated tests own/request PRIMARY and use Shift-Left/focus/preview input.
C probes cover pointer/signed offset/gboolean and get_chars/cursor/range prototypes.
The expanded inputs example deliberately labels native selection ownership effects.

### Completion action rows

Native insert_action_text/delete_action and action-activated use native signed gint,
pointer and cdecl ABI. The ergonomic wrapper owns literal labels, only deletes known
in-range rows, and rejects structural changes while attached: GTK's combined popup
navigation index has no public reset/query. It never accesses private popup fields,
rebinds models or implicitly detaches to fake a reset.

Action payloads copy action-list index/label and emission-time entry text. A separate
pinned idle bridge delivers each emission only to then-existing active listeners,
rechecking staleness before each callback. Native mouse popdown and keyboard prefix
cleanup finish before application code can edit/close/destroy. Edits/policy/model/
attachment changes cancel stale work; disconnect promptly releases captures.

Configuration survives detach; listeners do not. Close/native finalization release
captures, and detach pins the native completion against capture destructors dropping
its final public alias. Matching predicates filter suggestions, not action rows.
Hidden ARC/ORC tests, signed callback/prototype C probes and isolated XTEST mouse/key
regressions accompany the expanded inputs example. See docs/gtk2.md for the detached
replacement/session policy and unchanged native prefix/history behavior.

### Custom completion predicates

The public raw GtkEntryCompletionMatchFunc/set_match_func declarations use native
pointer/cstring/gboolean/cdecl and destroy-notify ABI. The ergonomic setMatch sees
only copied normalized key, literal suggestion and source index from the fixed
owned string model; no native iterator/filter position enters user code.

The shared model-function depth guard rejects live SDK handle access and controller
teardown during matching, contains exceptions with no-match fallback, and defers
last ordinary native releases until idle. Separate per-install callback-data pins
and a pinned/reentrancy-guarded native setter handle GTK's destroy-old-before-assign
semantics. Non-owning tokens deactivate captures; explicit clearMatch installs NULL
to restore GTK itself. Caller-requested refilter is required for cached rows.

Matcher lifetime is controller-wide, not attachment-wide. Model replacement updates
the callback's retained fixed model before native filtering. Close/finalization
invalidates tokens; checked access notices raw replacement. Inline prefix/preview
algorithms are unchanged, and filtering is not authorization. Expanded inputs,
hidden ARC/ORC lifecycle/purity tests, C probes and isolated real-popup tests cover
the contract; see docs/gtk2.md and TODO.md for remaining provider/model/IME work.

### Entry completion and editable text input

EntryCompletion is an opaque non-floating GObject. Core setters/getters retain
native gint/gboolean/pointer/cdecl signatures; C probes verify match-selected's
completion/model/iter/data pointers and handled gboolean return. ComboBox's missing
public get_type declaration was added without copying native private layouts.

The SDK owns a fixed text model with a popup-only default policy. It handles native
match-selected before its true-handled default, copies the match and commits at
UI idle so native popup code cannot continue after an application callback tears
its state down. Native objects are retained across the text setter; pending work
is generation/attachment checked and canceled on edits/replacement/detach/destroy.
Native matching and popup navigation remain GTK's implementation. No private
handler IDs or renderer/popup fields are inspected.

Editable ComboBoxText adds a retained public entry view, private-child removal/
destruction guards and copied/coalesced text observations. Existing text mutations
now validate UTF-8 before GTK. This is not arbitrary model/renderer rebinding or
arbitrary custom-provider/model completion.

Inline common prefix and popup selection are now opt-in on this same model. Native
insert-prefix/cursor-on-match defaults retain GTK matching, suffix selection and
accept/reject navigation; copied provisional observations are collected/delivered
at idle. While either inline policy is configured, SDK entry changed/activate and
its combo changed callbacks defer dynamically, even for older connections. This
prevents application teardown while native defaults keep using entry state.

Readonly changes suspend effective native flags but preserve requested policy;
password/lifetime teardown detaches and cancels observers. The public prefix getter
copies GTK's nullable historical key. No private history reset is emulated. Native
Unicode popup previews use a byte offset on GTK 2.24.33; the optional source patch
fixes that in GTK, while SDK snapshots continue reporting actual native offsets.
Hidden/mapped ARC/ORC tests and signal/getter C probes cover timing and ownership;
see docs/gtk2.md for the changed callback contract and remaining custom/IME scope.

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
