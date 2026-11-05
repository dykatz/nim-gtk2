# Ergonomic GTK2 API work

Keep this file updated as batches are planned and completed: mark delivered work,
record deliberate scope boundaries, and add newly discovered gaps. Update it with
each future implementation batch alongside the relevant documentation and tests.

All audited, non-deprecated concrete core GTK2 widgets currently have an ergonomic
entry point. Remaining work primarily deepens functionality. The public API is
`import gtk2`; raw bindings remain available under `headers/`.

## Next proposed batch: multiple IconView selection

- [ ] Add checked selection modes and multi-selection operations without changing
      the fixed model/layout ownership contract.
- [ ] Provide copied/coalesced selection observations and unambiguous path/index
      access, with stable references where needed for delayed application work.
- [ ] Preserve source/proxy coordinate semantics and clear stale selection anchors
      when changing modes, according to audited native GTK2 behavior.
- [ ] Expand the existing icon example, documentation and hidden lifecycle tests;
      add isolated mapped tests for native selection/input behavior.

Model drag-and-drop remains a separate transfer/protocol batch.

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

- [ ] Multiple IconView selection (next proposed batch above).
- [ ] Model drag-and-drop.
- [ ] Arbitrary/custom cell renderers beyond the audited presentation batch.

### Text editing

- [ ] TextView child anchors and embedded widgets.
- [ ] Rich-text serialization and rich clipboard formats.
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

- [x] Custom sort/filter functions, copied-row text presentation, pixbuf columns,
      explicit refresh/disconnection and synchronous traversal protection (above).
- [x] Popup-only EntryCompletion with owned UTF-8 suggestions, checked attachment,
      deferred cancellable commits and copied selection observations.
- [x] Editable ComboBoxText public entry access, protected child ownership and
      copied/coalesced text observations.

See `docs/gtk2.md` for the complete delivered API and its ownership/scope contracts.
