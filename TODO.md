# Ergonomic GTK2 API work

Keep this file updated as batches are planned and completed: mark delivered work,
record deliberate scope boundaries, and add newly discovered gaps. Update it with
each future implementation batch alongside the relevant documentation and tests.

All audited, non-deprecated concrete core GTK2 widgets currently have an ergonomic
entry point. Remaining work primarily deepens functionality. The public API is
`import gtk2`; raw bindings remain available under `headers/`.

## Next proposed batch: Entry icons and icon activation

- [ ] Audit GTK2.24 primary/secondary icon ownership, storage replacement, enum/event
      ABI and native traversal after icon press/release signals.
- [ ] Add checked pixbuf/icon-name configuration, plain tooltips and per-icon
      sensitivity/activatability without exposing internal widgets or markup policy.
- [ ] Add copied deferred icon activation observations and safe cancellation/owner
      cleanup; preserve native input/default behavior, not simulated button clicks.
- [ ] Expand inputs example with hidden ARC/ORC/ABI and isolated pointer tests.

Icon drag sources/providers, custom renderers, undo and deeper IME work remain separate.

## Completed batch: Entry limits and presentation policy

- [x] Audited character max-length vs stock 65535-byte allocation ceiling; checked
      0..65535 maxLength, -1/nonnegative gint widthChars, finite 0..1 gfloat alignment
      and native gboolean activatesDefault. No unlimited/byte-limit fiction.
- [x] Corrected raw alignment receiver to PEntry and added getter; removed obsolete
      unsigned default-activation bitfield helpers without shims, preserving storage.
- [x] Native max setter truncates/emits before storing its limit: scoped native pins
      and deferral for SDK Entry/parent ComboBox observations ensure committed-state
      idle callbacks, including pre-existing connections and safe reconfigure/destroy.
- [x] Invalid policy is atomic; valid max policy cancels queued completion work even
      without truncation. Native partial edits/long choices remain GTK behavior, not
      simulated validation/rollback. Readonly/password/combo/SpinButton documented.
- [x] Expanded inputs and native-default dialog example; unrealized hidden ARC/ORC
      callbacks/lifetime/purity tests, eight native prototypes/gfloat/gboolean ABI,
      isolated typed limits/default sensitivity/partial completion and combo teardown.

## Completed batch: Entry cursor/selection observations

- [x] Audited paired notify thaw before native adjustment/recompute/PRIMARY cleanup;
      native handlers only schedule, with final public cursor/bounds sampled at idle.
- [x] Copied EntrySelection observations with coalescing/dedup, optional deferred
      initial delivery, no text/password payload and no events for text-only changes
      retaining the same coordinates. Per-connection, not global emission snapshots.
- [x] Non-owning connection/source/weak widget semantics with independent native
      closure/source pins, prompt capture release, explicit pinned disconnection,
      and owner destroy/finalization cancellation without finalizing-widget refs.
- [x] Reentrant edits schedule later callbacks; self-disconnect/destroy/throw contained.
      Native parent ownership survives public alias loss; combo/SpinButton and pure
      model-function guards work. Completion attachment lifetime stays independent.
- [x] Expanded inputs/docs, unrealized hidden ARC/ORC ownership/lifecycle tests,
      notify/GParamSpec/GClosure ABI, isolated PRIMARY loss/Shift-Left/focus and
      native preview observer-driven teardown. Observation issues no selection requests.

## Completed batch: Entry Unicode cursor and selection

- [x] Audited public GtkEditable bounds/direction and native PRIMARY updates:
      realized-but-unmapped entries can claim, unrealized entries return early,
      and realization can export a pre-existing selection.
- [x] Copied code-point EntrySelection with oriented anchor/cursor, ordered bounds,
      selectedText full-transfer copy/free, and checked cursor/range/all/clear helpers.
      Atomic validation, no byte conversion, sentinel or silent clamping.
- [x] Read-only navigation/copy allowed; password coordinate operations allowed but
      selectedText rejected. Protected combo entries and inherited SpinButton work.
- [x] Direction-preserving focus with native/state pins and destruction/bounds checks.
      Collapse uses native select_region ownership behavior, not clipboard emulation.
- [x] Valid mutations cancel stale queued SDK completion work without resetting native
      popup/prefix history; native GTK IM resets remain normal. Invalid ranges preserve
      pending work. Shared purity guard.
- [x] Expanded inputs/docs and hidden ARC/ORC tests asserting unrealized state, native
      cursor/bounds/get_chars ABI, isolated PRIMARY/password/combo and Shift-Left/focus/
      inline-preview keyboard regressions. Normal tests make no selection requests.

Completion markup/providers, arbitrary models/renderers and deeper IME integration
remain separate, as do undo/redo and richer text-buffer insertion/transfer work.

## Completed batch: EntryCompletion action rows

- [x] Audited native action model ownership, unchecked deletion, combined cached
      navigation indices and post-signal keyboard/mouse traversal.
- [x] Owned UTF-8 literal labels with separate action-list indices and atomic checked
      configuration. Structural replacement is detached-only; no implicit restart,
      private popup fields, model rebinding or fake-input navigation resets.
- [x] Copied per-emission deferred activation payloads and non-owning/disconnectable
      listeners, independent of suggestion commits and inline observations.
- [x] Staleness checked before each listener; edits, model/match/inline changes,
      readonly/password, detach/close/destruction cancel queued actions. Late
      subscriptions do not receive earlier activations; exceptions are contained.
- [x] Configuration survives detach while listeners end with their attachment
      session; prompt capture release and native/idle pins protect final cleanup,
      including destructors dropping the final public completion alias on detach.
- [x] Expanded inputs/docs and hidden ARC/ORC lifecycle/purity/reentrancy tests,
      signed callback/native prototype ABI and isolated action-only mouse/keyboard,
      inline-to-action and explicit replacement-session regressions.

## Completed batch: custom EntryCompletion matching

- [x] Audited native setter destroy-old-before-assignment and callback/model lifetime.
- [x] Pure predicate on copied normalized key/literal suggestion/source index from
      the existing fixed owned string model; no mutable GTK models/iters exposed.
- [x] Checked synchronous GUI-access/teardown/disconnection rejection, contained
      exceptions/no-match fallback and delayed ordinary final native releases.
- [x] Independent native slot pins, guarded/pinned replacement, non-owning tokens,
      prompt capture release and owner-finalization cleanup. Matcher survives detach.
- [x] Explicit refilter/captured-state refresh and exact native NULL default reset;
      disconnected bridges reject rows, and cached rows are not authorization.
- [x] Fixed-model replacement updates callback ownership before native iteration;
      native inline algorithms/history remain unchanged for custom visibility.
- [x] Expanded inputs example/docs and hidden ARC/ORC lifetime/purity/reentrancy,
      callback/setter ABI and isolated native popup/default-reset tests.

## Completed batch: EntryCompletion inline mode and selection

- [x] Audited native insert-prefix/cursor-on-match/accept/reject timing; preserve GTK
      matching, suffix selection and popup navigation on the fixed owned string model.
- [x] Checked inline policy, explicit prefix request, copied nullable native prefix
      and coalesced copied provisional observations separate from onSelected commits.
- [x] Dynamically defer SDK entry changed/activate and parent combo changed observers
      while inline is configured, including pre-existing connections. Ordinary and
      popup-only timing is unchanged; disconnect/destruction cancels source pins.
- [x] Readonly suspension/restoration of effective native flags, password detach,
      edit/model/refilter/policy/lifetime observation cancellation and combo support.
- [x] Expanded examples/inputs.nim and docs; hidden ARC/ORC ownership/reentrancy,
      native signal/getter ABI and isolated XTEST prefix/preview/accept/reject tests.
- [x] Document native historical prefix retention (no public reset) without private
      state/model-rebinding/fake-input workarounds. Cancellation does not undo text.
- [x] Diagnose GTK2's multibyte preview suffix byte-offset defect and provide an
      optional source patch; installed GTK unchanged, snapshots report native offsets.

## Completed batch: rich clipboard negotiation

- [x] Audited public native ownership/request callbacks; immutable serialized offers
      plus explicit validated plain fallback, independent of source buffer lifetime.
- [x] Required per-request trust and immutable native format/tag policy: false never
      requests/parses rich data; no automatic decoding of arbitrary desktop owners.
- [x] Copy borrowed typed binary replies before native return; detached decode and
      application observations run at idle, never inside selection callbacks.
- [x] Cancellable requests with immediate capture release and independent native/
      source/lifetime pins; owner edit/destruction cancellation and stale-buffer checks.
- [x] Explicit absent-target text fallback, empty/unavailable distinction, rejected
      rich replies without silent downgrade, fixed schema policy and PRIMARY support.
- [x] Expanded text example with document copy/import and initially-off trust checkbox;
      existing plain paste/native key bindings remain unchanged.
- [x] Hidden no-ownership/no-wire tests, ABI probes, isolated foreign-owner/ownership/
      malformed-reply and ARC/ORC lifecycle coverage.

Native parser safety still limits this to explicitly trusted document transfers;
owner identity is not authenticated and multi-target requests are not atomic.
Live rich-text insertion, richer clipboard protocols/custom codecs, undo/redo and
model drag-and-drop remain separate batches.

## Completed batch: native rich-text serialization

- [x] Audited native registration, callback signatures, atom/array/binary ownership,
      tag creation policy, error cleanup and synchronous import timing.
- [x] Private owned TextFormat registration buffers, copied SerializedText data and
      native MIME identity; no application buffer's clipboard formats are modified.
- [x] Exact range snapshots through public insert_range avoid GTK2 past-end scanning;
      selected anchors/literal U+FFFC are rejected before its native progress bug.
- [x] Fresh detached imports prevent changed observers invalidating native iterators;
      false tag policy can share a fixed schema, while true requires a fresh table.
- [x] Audited native framing validation rejects unsafe outer lengths/unknown headers;
      native XML/pixdata remain trusted data, not a security boundary or guessed codec.
- [x] Explicit file save/load in examples/text.nim, Unicode/tag/image/range/error and
      weak source lifetime tests, raw registration/array checks and ABI probes.
- [x] Hidden ARC/ORC and isolated mapped layout/two-view replacement coverage.
- [x] Native defect diagnostic and optional source patch; installed GTK unchanged.

Discovered native gaps: serializer hangs on non-pixbuf U+FFFC, scans beyond a range
end, and the unknown-first-header fallback uses an invalid GError domain. Native
imports also leak an anonymous-tag hash table, and decoded pixbuf spans on later
parse errors. The SDK guards known framing/progress/range paths; the optional patch
fixes progress and parser cleanup, not full native parser safety or range scanning.
Widgets/anchors, marks/history/view settings and application callbacks have no
implicit serialized representation.

## Completed batch: TextView child anchors and embedded widgets

- [x] Owned buffer-bound anchors, weak buffer identity, checked lookup/deletion and
      retained deleted-handle behavior without private segment access.
- [x] Own new() before insert() so immediate deletion by a changed observer cannot
      invalidate a borrowed constructor return; pin the native buffer across helpers.
- [x] Checked inline widget parenting, one widget per anchor per view, shared-buffer
      views, ordinary detach/reparent and native destruction/replacement cleanup.
- [x] Unicode offsets, plain text versus object-preserving slices, bounded search
      behavior and explicit non-serialization of embedded widgets.
- [x] One-shot idle deletion observations with disconnection, capture release and
      buffer-finalization support; ordinary native changed/destroy callbacks retain
      their synchronous reentrancy restrictions.
- [x] Expanded examples/text.nim, documentation, hidden ARC/ORC ownership/reentrancy
      tests, C ABI probes and isolated real two-view inline layout tests.

## Completed batch: multiple IconView selection

- [x] Checked shared selection modes, validated multi-selection operations and
      ascending copied paths/indices without changing fixed model/layout ownership.
- [x] Coalesced idle selection observations with copied final-state payloads and
      stable references in displayed-model coordinates.
- [x] Per-emission deferred activation with copied historical paths/stable rows;
      existing positional activation conveniences also use safe idle delivery.
- [x] Clear selected items on mode changes, explicitly leaving BROWSE before NONE.
      Native cursor/range anchors are intentionally preserved: GTK2 has no public
      anchor reset, and no private-field/model-rebinding/fake-input workaround is used.
- [x] Public checked cursor paths independent of selection, proxy/source deletion
      example, documentation and hidden ARC/ORC lifecycle tests.
- [x] Native cursor ABI probe and isolated XTEST Shift/Ctrl+A/Return validation.

Model replacement, custom/editable IconView renderers and model drag-and-drop remain
separate work.

## Completed batch: richer model sorting, filtering and cell presentation

- [x] Checked custom comparison callbacks and explicit resorting.
- [x] Checked visibility predicates, safe replacement of GTK's set-once bridge and
      explicit refiltering.
- [x] Copied-row text cell functions with validated/reset styling and explicit
      refresh/clear operations; fixed owned pixbuf columns.
- [x] Synchronous pure-function contract, checked ObjectHandle access rejection,
      contained exception fallbacks and explicit function connections/disconnection.
- [x] UI-idle native release protection for last ordinary handles dropped inside a
      function; no permission to reenter GTK or release custom controller owners.
- [x] Immediate-child/view-model path semantics, stable source reference coverage
      and documented cache refresh requirements.
- [x] Expanded examples/proxies.nim and API/ABI documentation.
- [x] Hidden ARC/ORC lifecycle/reentrancy tests, native callback ABI probes and
      isolated native TreeView sizing/painting tests.

This delivers audited text/pixbuf presentation, not arbitrary custom model/renderer
implementations, toggle-cell functions, multi-renderer layouts or subclassing.
Callbacks must not call raw GTK, pump events, change GUI ownership or invoke arbitrary
user/controller teardown; checked handle access is a guard, not a sandbox.

## Remaining backlog

### Models and views

- [ ] Model drag-and-drop.
- [ ] Arbitrary/custom cell renderers beyond the audited presentation batch.

### Text editing

- [ ] Additional rich clipboard protocols and application acceptance policies.
- [ ] Live rich-text insertion with a safe native reentrancy/commit contract.
- [ ] Custom ergonomic codecs and any explicit widget save/load representation.
- [ ] Undo/redo support with an explicit application-facing history contract.

### Completion and input

- [ ] Entry icons and icon activation (next proposed batch above).
- [ ] Arbitrary completion models/columns.
- [ ] Richer completion presentation/providers.
- [ ] Deeper IME integration.
- [ ] Audit/remove remaining legacy raw GtkEntry bitfield helpers separately before
      exposing corresponding policies; new SDK policies must use public native APIs.

### Clipboard and drag-and-drop

- [ ] URI, image and binary transfers.
- [ ] MOVE semantics with explicit source-deletion/ownership rules.
- [ ] Custom drag icons.
- [ ] Application-controlled drop acceptance and asynchronous acceptance protocols.

### Printing

- [ ] Page rendering and pagination.
- [ ] Print previews.
- [ ] Print-job submission and lifecycle management.

Current printing support configures choices only; it does not render or submit jobs.

### Drawing, desktop and appearance

- [ ] Broader copied event payloads and audited synchronous return-value callbacks.
- [ ] Standalone popup positioning.
- [ ] Broader GDK window/device abstractions.
- [ ] Broader Pango layout/font abstractions.
- [ ] Theme, style and resource APIs.
- [ ] Ergonomic ATK/accessibility APIs.

### Actions, builders and extensibility

- [ ] Persistent/editable accelerator maps and arbitrary accelerator closures.
- [ ] Custom action proxy factories.
- [ ] Mutable/shadowing UIManager action-group schemas, if a safe contract is viable.
- [ ] Additional audited GtkBuilder typed lookups and signal signatures.
- [ ] Arbitrary GObject property and signal access with checked types/ownership.
- [ ] Custom widget subclasses and virtual methods.
- [ ] Optional integrations such as HtmlView, separately from core GTK2 support.

## Delivery constraints

- Preserve native ABI, ownership, pointer representations and calling conventions.
- ARC/ORC only; GTK calls, callbacks and final releases stay on the UI thread.
- Audit synchronous callbacks individually; contain exceptions and prevent unsafe
  native reentrancy rather than assuming every callback can be deferred.
- Normal tests must not map windows or claim desktop clipboard/input state.
- Mapped/input tests require an explicitly opted-in isolated virtual display:
  `GTK2_TEST_VIRTUAL_DISPLAY=1`.
- Never suppress native warnings, inspect private GTK structures as workarounds, or
  automatically modify installed native libraries. Preserve accepted native behavior.
- Continue hidden/fatal-warning tests, ARC/ORC, ABI and cross-target checks, calculator
  regression tests, example builds, generator/package checks and isolated mapped
  regressions as relevant to each batch.

## Recently completed

- [x] Checked Entry native length/width/alignment/default policies, pinned/deferred
      truncation observations and actual default-response keyboard regression (above).
- [x] Idle-coalesced copied Entry selection observations with independent native/source
      pins, non-owning tokens and isolated native ownership/keyboard tests (above).
- [x] Checked Unicode Entry cursor/selection snapshots/helpers, native PRIMARY policy,
      reverse-selection focus preservation and isolated keyboard tests (above).
- [x] Literal EntryCompletion action rows, detached configuration and copied deferred
      native activations with independent session/cancellation ownership (above).
- [x] Pure copied-input custom EntryCompletion predicates, guarded replacement,
      explicit default reset/refilter and independent callback ownership (above).
- [x] Native inline EntryCompletion prefix/preview policy, safe deferred entry/combo
      observers, copied provisional snapshots and readonly/lifetime rules (above).
- [x] Explicit trusted rich clipboard document negotiation, immutable offers,
      cancellable detached requests and plain fallback (above).
- [x] Native rich-text serialization with copied data, private formats, detached
      imports, tag policy, exact ranges and explicit file save/load (above).
- [x] TextView child anchors, shared-view inline widgets, weak buffer ownership and
      one-shot idle deletion observations (above).
- [x] Multiple IconView selection, copied idle observations, stable activation
      references and native keyboard selection tests (above).
- [x] Custom sort/filter functions, copied-row text presentation, pixbuf columns,
      explicit refresh/disconnection and synchronous traversal protection (above).
- [x] Popup-only EntryCompletion with owned UTF-8 suggestions, checked attachment,
      deferred cancellable commits and copied selection observations.
- [x] Editable ComboBoxText public entry access, protected child ownership and
      copied/coalesced text observations.

See `docs/gtk2.md` for the complete delivered API and its ownership/scope contracts.
