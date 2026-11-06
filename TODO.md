# Ergonomic GTK2 API work

Keep this file updated as batches are planned and completed: mark delivered work,
record deliberate scope boundaries, and add newly discovered gaps. Update it with
each future implementation batch alongside the relevant documentation and tests.

All audited, non-deprecated concrete core GTK2 widgets currently have an ergonomic
entry point. Remaining work primarily deepens functionality. The public API is
`import gtk2`; raw bindings remain available under `headers/`.

## Next proposed batch: rich-text serialization

- [ ] Audit GTK2's serialization/deserialization format registration, copied binary
      data ownership, tag creation policy and error cleanup.
- [ ] Add an explicit checked format/serialization surface for trusted application
      data, preserving native format identity rather than guessing byte layouts.
- [ ] Define behavior for tags, pixbufs, object replacement characters and unsupported
      embedded widget reconstruction. Anchors/widgets have no implicit save/load form.
- [ ] Expand the text example with explicit save/load choices and add hidden ARC/ORC
      round-trip/error tests, ABI probes and isolated layout checks as needed.

Rich clipboard negotiation, undo/redo and model drag-and-drop remain separate batches.

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

- [ ] Rich-text serialization (next proposed batch above).
- [ ] Rich clipboard formats and negotiation.
- [ ] Undo/redo support with an explicit application-facing history contract.

### Completion and input

- [ ] Inline completion and inline selection.
- [ ] Custom completion match functions and arbitrary completion models/columns.
- [ ] Completion action rows and richer presentation/providers.
- [ ] Deeper IME integration.

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
