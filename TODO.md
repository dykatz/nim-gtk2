# Ergonomic GTK2 API work

Keep this file updated as batches are planned and completed: mark delivered work,
record deliberate scope boundaries, and add newly discovered gaps. Update it with
each future implementation batch alongside the relevant documentation and tests.

All audited, non-deprecated concrete core GTK2 widgets currently have an ergonomic
entry point. Remaining work primarily deepens functionality. The public API is
`import gtk2`; raw bindings remain available under `headers/`.

## Next proposed functionality batch: copied Pixbuf RGBA pixel values

- [ ] Add pure owning tightly-packed RGBA8 image values and checked copied Pixbuf pixel
      snapshots/construction, including RGB-to-RGBA alpha normalization and native
      rowstride/channel/size semantics. No borrowed writable native pixel pointers.
- [ ] Validate dimensions/byte count/overflow before construction or copying; keep
      native ownership/final release/pure GUI guards intact. No codec, file parser,
      automatic untrusted decode, private layout or mutable-storage alias shim.
- [ ] Extend existing examples/docs and hidden ARC/ORC/ABI/cross-target plus isolated
      actual pixel/rendering/lifetime regressions. Image codecs/persistence/private
      audits remain separate.

## Completed functionality batch: explicitly trusted COPY-only image drag/drop pads

- [x] Added enableImageDrag/setImage with private copied payloads/actual begin snapshots,
      ImageDragSource and trust-required onImageDrop/ImageDropSite connected/disconnect/
      draining. Native readable/writable image target discovery/table cleanup, exact
      target/type/format-8/positive envelope and COPY before decode; no payload getter.
- [x] Shared bounded post-decode Pixbuf copy; metadata-only ImageDropInfo predicate
      before native finish and ImageDrop owning image/info idle observations afterward.
      Pure guards/fixed closure identity/error containment; no policy for invalid/
      non-COPY/canceled/over-bound data. No codec sandbox/authentication/fallback/MOVE/
      DELETE/early finish or source-success/application-acknowledgment fabrication.
- [x] Independent pad/context/unrealized same-screen receiver/cleanup pins survive
      disconnect/destruction. Captures/config release promptly; inactive pads block
      image/text/URI/binary replacement while real replies drain. Late canceled data
      skips SDK decoding/copy, without claiming to stop already-entered/native work.
      Callback/encoding pixel pins preserve reentrancy; weak pad ownership remains.
- [x] Image sources support copied icon APIs; real cursor/popup tests extend to the
      fourth family. Added hidden trust/copy/weak-pad/atomic update/conflict/purity,
      seven target/codec plus shared seven native DnD prototype/four signal callback
      ABI and source guards. Genuine local/foreign tiny trusted PNG XTEST tests cover
      exact pixel/alpha/snapshots/update/bounds/zero/metadata copies/identity/guards/
      false/error/source-cancel/wrong-envelope/text/MOVE/no-DELETE/retained/reentrant/
      queued-cancel/pending disconnect/destroy/drain/reserved replacement. Desktop's
      source preview/separate initially-off drop trust control and all guides updated.
- [x] Validated ARC/ORC hidden/mapped image pads and four-family icon pixels with fatal
      native warnings, full hidden/calculator/bindings/raw/layout/ABI suites, Windows
      amd64/i386/macOS amd64 semantic checks, all examples, generator/package/diff,
      every isolated mapped task and missing-opt-in guard. Installed GTK unchanged;
      untrusted decoding/persistence/private audits remain deferred.

## Completed functionality batch: explicitly trusted copied image clipboard requests

- [x] Added required trust-gated requestImage with owner/non-owner overloads, ImageRequest
      pending/cancel and idle ClipboardImage owned Pixbuf/kind/error results. False trust
      refuses before request; native NULL remains unavailable without invented decoder
      diagnostics, no zero-size images/partial results or text/URI/rich fallback.
- [x] Borrowed decoded images copied before native callback returns. int64 dimension
      product checked against 0..gint-div-4 maxPixels before application pixel allocation;
      zero rejects any image. Limits/cancel do not constrain native decoding/receipt/
      INCR/codec work or authenticate owners. Native format retries and autodetecting
      installed loaders are preserved, not represented as a four-codec security allowlist.
- [x] Weak native owner/destroy/closure pins avoid public Connection retention and
      finalizing-widget refs. Independent wire/idle pins survive real receipt/timeout;
      cancel releases captures/queued images promptly and skips late SDK copying, not
      native decoding. Observers detach first, may retain handles/reenter/destroy/throw.
- [x] Added hidden no-wire trust/bounds/callback/owner/purity validation, four public
      native request/copy/dimension prototypes plus nullable-image/destroy/closure ABI
      and source guards. Extended real local/foreign tiny trusted PNG pixel/alpha/
      dimensions/exact/zero/exceeded bound/idle/copy/retained token/drop/reentrant/error/
      PRIMARY/queued/delayed cancel/destruction/last-owner regressions, with second real
      replies draining canceled wires. Desktop initially-off trust/decode/preview/
      small-copy-limit controls and guides updated. Native decoding requires explicit trust.
- [x] Validated hidden/mapped ARC/ORC/fatal-warning, full hidden/calculator/bindings/raw/
      layout/ABI suites, Windows amd64/i386/macOS amd64 semantic checks, every example,
      generator/package/diff checks, every isolated mapped task and missing-opt-in
      guard. Installed GTK unchanged; image DnD/persistence/private audits deferred.

## Completed functionality batch: copied drag-source Pixbuf icons

- [x] Added setIcon(Pixbuf)/clearIcon to text/URI/binary source tokens with guarded,
      atomic copied configuration, disconnected-token rejection and no icon getter.
      Caller images may mutate/release; active drags retain their native pixel refs.
- [x] Apply copied images only during actual native drag-begin via public context API
      and GTK's native source hotspot (-2,-2). Clear leaves native default/global-icon
      selection alone for future drags, not a stock substitute, site rebuild, private
      cursor/cache reset or simulated gesture. No implicit user-widget realization.
- [x] Disconnect/destruction promptly releases source icon config; actual contexts keep
      their native references without an added widget/flight ownership cycle. Existing
      payload/COPY/finish/delete and destination-wire semantics remain unchanged.
- [x] Added unrealized copy/caller release/atomic failure/token replacement/weak pad/
      pure guard tests, two public native prototype/signed-hotspot callback ABI checks
      and source guards. Genuine XTEST tests observe public XFixes cursor pixels and
      native DND popup drawable pixels for all three source types, active/future/reset/
      caller mutation/release/failed updates/disconnect, including oversized fallback.
      Native cursor compositor rounding is observed with a one-channel-unit tolerance,
      never repaired. Updated controls/desktop examples, guides and isolated test task.
- [x] Added independent begin-callback/native-pixel pins for native reentrancy and an
      early public text-source disconnect guard so teardown cannot bypass pure icon
      configuration guards. All hidden/mapped ARC/ORC/fatal-warning, calculator,
      bindings/raw/layout/ABI, Windows amd64/i386/macOS amd64 semantic checks, every
      example, generator/package/diff and every isolated mapped task/opt-in guard
      passed. Installed GTK unchanged; custom contexts/decoding/private audits deferred.

## Completed functionality batch: COPY-only binary drag/drop pads

- [x] Added enableBinaryDrag value/byte overloads, fixed-MIME copied source data access/
      updates and actual begin snapshots; onBinaryDrop MIME/maxBytes/accept plus source/
      site connected/disconnect/draining. Exact ordinary pads and per-direction native
      target conflicts; no text/URI/image fallback, parser, MOVE/delete or auto-use.
- [x] Shared exact format-8/type/target/bounded application-copy validation with binary
      requests, including valid empty/zero bound. Optional fixed copied pure acceptance
      is fail-closed; exceptions contained/guard restored. Idle copied observation
      follows the sole native finish/delete=false; source success is not application ack.
- [x] Independent native context/pad/unrealized same-screen receiver pins preserve real
      replies after pad destruction. Disconnect promptly releases policy/observer/data;
      inactive native sites reserve against binary/text/URI replacement until draining
      and separate idle cleanup finish. No private state or implicit realization repair.
- [x] Added hidden copies/MIME/atomic updates/pad conflicts/weak-lifetime/purity tests,
      seven native function/four signal callback signed/full info/time/gboolean ABI
      probes and source guards; real XTEST local/foreign/all-byte INCR/snapshot/empty/
      bound/type/format/policy/error/guard/source-cancel/no-DELETE/queued-cancel/pending
      disconnect/destroy/replacement regressions. Updated desktop pads and all guides.
- [x] Validated hidden/mapped ARC/ORC with fatal native warnings, all hidden/calculator/
      bindings/raw/layout/ABI suites, Windows amd64/i386/macOS amd64 semantic checks,
      every example, generator/package/diff checks, every isolated mapped task and
      missing-opt-in guard. Installed GTK unchanged; private layout audits deferred.

## Completed functionality batch: copied binary clipboard requests

- [x] Added requestBinary with explicit MIME and optional owner/maxBytes, BinaryRequest
      pending/cancel, copied ClipboardBytes kinds/MIME/bytes/error and default 16 MiB
      application copy bound. Empty/unavailable/rejected distinct; exact target/type/
      format-8 validation, no parser/fallback or format-16/32 reinterpretation.
- [x] Validate MIME/callback/owner/bounds before native request; bound before allocation/
      copy. Native receipt/INCR buffers and timeout remain native, not a security limit
      or fabricated wire cancellation. Pure guards reject checked request/cancel calls.
- [x] Native wire/idle/owner pins are independent. Cancel promptly clears captures/data;
      inactive wire replies skip copying. Non-owning native owner binding (not an owning
      public Connection) cancels on destroy/last owner release without finalizing-widget
      refs. Idle observers detach first, may reenter, retain values and contain errors.
- [x] Added hidden no-wire validation/purity and native six-prototype/received/destroy/
      closure-notify ABI/source guards; isolated exact/empty/bound/type/format/copy/
      local-queued/foreign-delayed/capture/weak-owner/drop/reentrant/error/PRIMARY/large
      INCR regressions. Desktop has explicit bounded window-owned byte inspection;
      updated guides/readme, incoming image decoding and private audits stay deferred.
- [x] Validated hidden/mapped ARC/ORC with fatal native warnings, all hidden/calculator/
      bindings/raw/layout/ABI suites, Windows amd64/i386/macOS amd64 semantic checks,
      every example, generator/package/diff checks, every isolated mapped task and
      missing-opt-in guard. Installed GTK unchanged; no native transport/timeout repair.

## Completed functionality batch: copied binary clipboard offers

- [x] Added newBinaryData, copied MIME/len/bytes access and offerBinary value/byte
      overloads with BinaryClipboardOffer.active/clear. NUL/all byte values preserved,
      valid empty distinct from default/invalid target; no parsing or fallback.
- [x] Defined conservative lowercase application MIME/subtype subset, known native
      protocol exclusions and gint-minus-one length bound for native length+1 arithmetic.
      Pure value helpers plus early guarded publication/clear; invalid data before claim.
- [x] Used native single application target/set_with_data/set format-8/type/count,
      callback-local storage roots, native offer pins and idempotent clear/failure
      release. Dropped tokens do not revoke; reentrant winners are not overwritten.
      No startup publication, set_can_store/persistence, incoming parsing or DnD.
- [x] Added hidden copies/MIME/bounds-source/purity tests, native setter/length/signed
      format/count/unsigned-byte probes and isolated all-byte/empty/exact type-format/
      repeat/drop/replacement/stale-clear/reentrant-failure/PRIMARY/no-fallback/foreign
      ownership regressions including a real large foreign X11 INCR transfer. Desktop
      has explicit byte-copy/clear buttons; API/migration/readme and scope docs updated.
- [x] Validated hidden/mapped ARC/ORC with fatal native warnings, all hidden/calculator/
      bindings/raw/layout/ABI suites, Windows amd64/i386/macOS amd64 semantic checks,
      every example, generator/package/diff checks, every isolated mapped task and
      missing-opt-in guard. Installed GTK unchanged; private audits remain deferred.

## Completed functionality batch: copied image clipboard offers

- [x] Added explicit offerImage(Pixbuf), ImageClipboardOffer.active/clear and private
      native pixel copies, isolating source mutation/release; dropped tokens do not
      revoke native ownership. Invalid/copy/target preparation errors precede claim.
- [x] Public writable-image target discovery/table allocation and native set_pixbuf
      encoding preserve codec semantics; temporary list/table cleanup, callback-local
      pixel pin and independent native offer pin/clear release. No set_can_store,
      persistence, automatic startup publication, decoding, fallback or private state.
- [x] Added early shared pure-function guards, native UI-thread/lifetime rules, six
      public prototype/pointer/full gboolean probes and source ownership/scope guards.
- [x] Added hidden no-claim/no-request/no-realization validation/purity tests and isolated
      local/foreign trusted PNG fixture pixel/alpha/dimension, mutation/source release,
      dropped-token/repeat/replacement/stale-clear/ownership-loss/reentrant-clear/
      failed-candidate-cleanup/PRIMARY/no-fallback
      regressions. Desktop has explicit copy-image/clear buttons; guides document
      encoder failures/loss/metadata boundaries and non-atomic ownership semantics.
- [x] Validated hidden/mapped ARC/ORC with fatal native warnings, all hidden/calculator/
      bindings/raw/layout/ABI suites, Windows amd64/i386/macOS amd64 semantic checks,
      every example, generator/package/diff checks, every isolated mapped task and
      missing-opt-in guard. Installed GTK unchanged; private audits remain deferred.

## Completed functionality batch: copied URI drop acceptance predicates

- [x] Added optional fixed UriDropPredicate to onUriDrop: copied synchronous input
      before native finish, nil/default transport policy, false/error rejection and
      no policy call for invalid/non-COPY/canceled data. Observers remain idle/post-
      finish, not async acceptance, application work completion or file authorization.
- [x] Used shared pure-function guards with exception-safe restoration and deferred
      final releases. Clipboard lookup now rejects before native atom/get calls,
      and init/quit reject before GTK runtime/main-loop access.
      Independent policy input storage and rooted closure; disconnect/destruction
      promptly clears policy captures while wire/receiver pins drain without calling it.
- [x] Added public raw gdk_drag_drop_succeeded plus native prototype/full gboolean
      probe and actual X11 acceptance-bit checks; GTK2 source-success reporting is
      unchanged, not repaired. Single finish/delete=false and other ABI preserved.
- [x] Extended hidden closure/configuration/purity and isolated true/false/empty/error/
      guard/copy/fixed-identity/deferred-release/pre-finish/foreign/cancellation tests.
      Existing desktop pads demonstrate an explicit nonempty namespace predicate;
      updated guides/source guards, no implicit realization, file opening or raw state.
- [x] Validated hidden/mapped ARC/ORC with fatal native warnings, full hidden/calculator/
      bindings/raw/layout/ABI suites, Windows amd64/i386/macOS amd64 semantic checks,
      every example, generator/package/diff checks, every isolated mapped task and
      missing-opt-in guard. Native GTK unchanged; private audits remain deferred.

## Completed functionality batch: URI COPY-only drag-and-drop pads

- [x] Added URI-only ordinary DrawingArea/EventBox source/drop sites, copied values,
      drag-begin snapshots/atomic updates and per-drop copied idle observations.
      COPY checked at drop/receipt, valid empty supported, malformed/text/MOVE/source-
      disconnected replies rejected, no DELETE, implicit text fallback or file opening.
- [x] Defined post-finish observation (not authorization/acceptance), prompt capture/
      queue cancellation and independent wire/context/widget/receiver pins. Unrealized
      same-screen receiver survives original pad destruction; native selection drains
      before failure finish and cleanup, blocking replacement until draining=false.
      No private state, implicit realization/reparenting, cache repair or native patch.
- [x] Added five native function/three widget callback signature checks plus full signed
      coordinate/gboolean and unsigned info/time probes. Recorded native GTK2 XDND
      source-success reporting limitation; no duplicate finish/source-success repair.
- [x] Added unrealized value/conflict/lifetime/purity tests and actual isolated XTEST
      local/foreign/empty/malformed/text/MOVE/source-cancel/queued-cancel/teardown tests,
      including delayed foreign replies and blocked replacement after disconnect/destroy.
      Updated desktop example, API/migration guides and tasks; audits remain deferred.
- [x] Validated hidden/mapped ARC/ORC with fatal native warnings, full hidden/calculator/
      bindings/raw/layout/native ABI suites, Windows amd64/i386/macOS amd64 semantic
      checks, all examples, generator/package/diff checks, all isolated mapped tasks
      and the missing-opt-in guard. No installed GTK/source patch changes.

## Completed functionality batch: URI clipboard transfers

- [x] Added copied UriList construction/access with absolute ASCII scheme/character/
      percent-token checks (not scheme/host/path authorization or full URI parsing).
      Order/duplicates/escapes preserved; no decoding, file I/O, launch or text fallback.
- [x] Added URI-only native offers and idle/cancelable/owner-bound requestUris, distinct
      available-empty/unavailable/rejected results, atomic malformed rejection and
      independent offer/wire/idle pins. Dropped tokens do not cancel native ownership/
      delivery; cancel promptly frees captures while native callback data stays valid.
- [x] Bound public selection set/get_uris and audited GTK2.24.33 native ASCII/CRLF,
      comment/line parsing and transfer-full gchar**/g_strfreev semantics. Two native
      prototype checks plus char**/signed-gboolean callback probes; no native changes.
- [x] Added hidden copied/invalid-input/pure-guard tests and isolated local/foreign/
      empty/malformed/replacement/token/cancellation/owner/reentrant callback tests;
      desktop example explicit URI copy/inspect buttons and migration/API docs.
- [x] Validated ARC/ORC hidden and isolated fatal-warning regressions, all hidden/
      calculator/bindings/raw/layout/ABI suites, Windows amd64/i386 and macOS amd64
      semantic checks, every example, generator/package/diff checks, every isolated
      mapped task and missing-opt-in guard. Native ownership/event races remain
      documented native semantics, not a cross-process ownership lock.

## Deferred audit: Raw GtkTextLayout/display/cursor private API audit

- [ ] Inventory remaining private layout imports, flag helpers and concrete layout/
      display/cursor/appearance types against public TextView/iterator/Pango APIs.
- [ ] Remove unsupported private APIs/types without aliases, preedit/layout/cache
      repair or subclass substitutes; retain only opaque pointer storage required
      by public native instance/class ABI. Do not guess private layouts.
- [ ] Extend compile/source/ABI guards, migration docs and existing text example where
      relevant, with hidden ARC/ORC/cross-target and isolated public-path regressions.

## Completed batch: Raw GtkTextLine/private segment entry-point audit

- [x] Removed 39 private imports, four line-data flag helpers/four constants, including
      unprefixed private line_segment_split and widget-segment/layout metadata hooks.
      No aliases, segment/cache repair, refcount substitute or native changes.
- [x] Removed guessed segment union/vtable/callback bodies and unused node/tag-info/
      toggle types. Remaining needed line/line-data pointers are opaque only; public
      instance/class ABI unchanged. Six fragments/includes removed; public table
      foreach callback declaration relocated intact, not wrapped or deleted.
- [x] Added import/helper/mask/type/field/source guards, fourteen native public signature
      checks, public iterator/anchor size/alignment/storage and full gunichar probes.
- [x] Added unrealized CRLF/Unicode/boxed iterator/weak buffer ownership/borrowed lists/
      anchor regressions; extended isolated public display-line motion and genuine
      wrap-mode tests, and text example native Wrap display control for both views.
      Remaining private TextLayout/display/cursor APIs/types are the next audit.
- [x] Validated new hidden/mapped ARC/ORC/fatal-warning tests, full hidden/calculator/
      bindings/raw/layout/ABI suites, Windows amd64/i386 and macOS amd64 semantic
      checks, every example, generator/package/diff and all isolated tasks/guard.

## Completed batch: Raw GtkTextBTree private entry-point audit

- [x] Removed all 57 private BTree imports plus four adjacent buffer/debug hooks and
      mark_segment_new (62 entry points), without aliases; deleted twelve empty
      fragments/includes. Preserved opaque ABI pointer storage, no SDK tree usage.
- [x] Audited GTK2.24.33 private header/public source paths; documented public buffer/
      iterator/tag/mark/object/geometry alternatives and absent stamp/validation/debug
      equivalents. No cache repair, registration mirror, rebinding or native changes.
- [x] Corrected PIconSet to typed opaque pointer so removed tree refs cannot silently
      resolve to unrelated IconSet overloads; corrected TextWindowType native cint
      width discovered by public geometry ABI audit, preserving instance/class ABI.
- [x] Added 62 removed-signature guards, source/storage guards, seventeen public native
      signature checks, enum-size/signed-coordinate/out-pointer probes, and unrealized
      Unicode line char/byte/tag-list/toggle/mark-reacquisition/image/anchor coverage.
- [x] Added opt-in actual wrapped view geometry/transform/post-edit-mark tests and
      updated docs/text example public logical counts/clean flag/stable navigation.
      Private line/segment/layout APIs/types remain separate; four existing line-data
      masks moved alongside their helpers, not newly added or interpreted.
- [x] Validated new hidden/mapped ARC/ORC/fatal-warning tests, full hidden/calculator/
      bindings/raw/layout/ABI suites, Windows amd64/i386 and macOS amd64 semantic
      checks, every example, generator/package/diff and all isolated tasks/guard.

## Completed batch: Raw GtkTextBuffer flag/public-state audit

- [x] Removed both modified-bit helpers and two constants without aliases; retained
      public gboolean get/set_modified. Opaque flag allocation now uses native guint;
      corrected missing paste_done class slot/five true reserved slots, sizes intact.
- [x] Audited dirty/cursor/selection properties, synchronous native signals and actual
      deleteSelection return (nonempty selection, not deletion success). No modified
      GObject property, synthetic final-state observer, undo/history/reset or BTree fix.
- [x] Pinned basic text/insert/delete/dirty/selection operations and removeAllTags;
      user actions retain/pin original target, balance nested/exceptional/reassigned
      lifetimes and preserve immediate native changes, never rollback transactions.
- [x] Added sixteen signature checks, full native instance/class offsets and signed
      insert/mark/paste callback probes plus compile/source removal/storage guards.
- [x] Added unrealized dirty/order/Unicode/metadata/permissions/alias-drop/action/purity
      regressions and opt-in shared-view selection/paint/readonly return tests; updated
      docs and text example's explicit clean-not-save and readonly-default controls.
- [x] Validated new hidden/mapped ARC/ORC/fatal-warning tests, full hidden/calculator/
      bindings/raw/layout/ABI suites, Windows amd64/i386 and macOS amd64 semantic
      checks, every example, generator/package/diff and all isolated tasks/guard.

## Completed batch: Raw GtkTextTagTable private-hook/traversal audit

- [x] Removed both private buffer-registration bindings without aliases, shadow
      bookkeeping or private list access; native public constructors/final releases
      remain the only buffer registration path. Native ABI storage retained.
- [x] Audited transfer-full/nonfloating constructors, borrowed lookup/getter/table refs,
      silent table finalization versus explicit removal, shared definitions versus
      separate documents, anonymous/name reuse and SDK retained-table ownership.
- [x] Documented synchronous/unordered/borrowed foreach, no membership mutation or
      nested event pumping, owned collection before later changes, and destructive
      peer teardown restrictions. No native cache reset, registry mirror or wrapper.
- [x] Added seven native signature/class callback checks, full table field offsets,
      cdecl/signed-gboolean/foreach callback probes and removed-hook/source guards.
- [x] Added unrealized ownership/traversal/shared-buffer cleanup tests, extended
      isolated separate-buffer paint/removal/peer-finalization coverage, and updated
      docs/text example with a genuine anonymous highlight table-wide deletion toggle.
- [x] Validated hidden ARC/ORC/fatal-warning, calculator, bindings/raw/layout/ABI,
      Windows amd64/i386 and macOS amd64 semantic checks, every example, generator/
      package/diff checks, plus all isolated mapped regressions and opt-in guard.

## Completed batch: Raw GtkTextTag flag/public-property audit

- [x] Removed 48 flag/padding helpers and 48 masks without aliases; preserved native
      tag/table instance/class ABI. Old pad masks addressed real paragraph/margin bits.
- [x] Audited real override properties/spellings and false-vs-unset semantics; added
      clearBold/Italic/Underline/Invisible/Editable alongside color clears, plus checked
      native priority with actual table membership/range validation.
- [x] Pinned property/color/range/table operations and shared property emitters through
      native callbacks. Creation owns its table before native construction; detached
      tags remain valid without pretending membership or retaining document buffers.
- [x] Recorded native priority's lack of tag-changed/repaint notification; no synthetic
      refresh, detach/reapply, buffer rebinding, private cache or authorization promise.
- [x] Expanded text example/docs, removal/source/property/priority/pin/purity tests,
      ten native signature/cdecl/layout probes and isolated inheritance/removal pixel
      and fresh priority-query tests with opt-in guard.

## Completed batch: Raw GtkTextAttributes bitfield/ownership audit

- [x] Removed 33 TextAttributes/Appearance helpers and 34 masks without aliases;
      preserved native storage/layout. No render/padding/realized-state substitutes.
- [x] Corrected text_attributes_ref/reference return to native PTextAttributes.
      Audited boxed aliasing vs explicit deep copies, native unref/default snapshot
      ownership and ref-preserving/self copy_values behavior.
- [x] Documented default-plus-tag style overlays versus live tag mutation; snapshots
      are not authorization or live state. Expanded example public underline control.
- [x] Recorded native 2.24.33 copy_values destination tabs/paragraph-color leak from
      source audit; optional patch dry-run only, no runtime repair/installed change.
- [x] Added eight prototype/pointer-return/layout checks, compile/source guards,
      unrealized ARC/ORC copy/ref/default/property tests and isolated native pixels/
      snapshot-lifetime coverage with opt-in guard.

## Completed batch: Raw GtkTextMark private-body audit

- [x] Removed four helpers/four mask constants and guessed TTextMarkBody/PTextMarkBody
      types; no aliases. Public mark opaque segment/class storage unchanged and
      native ABI checked. No not_deleteable flag replacement invented.
- [x] Bound text_mark_new/add_mark and fixed createMark ownership before insertion:
      synchronous native mark-set deletion can no longer leave an adopted dangling
      convenience return. Creation/move/delete/visibility pin native lifetimes.
- [x] Added explicit owning TextMark.buffer getter; marks alone do not retain buffers.
      Native deletion/gravity/visibility preserved, protected builtins checked through
      public identities; no reinsertion, mutable gravity, fake deletion or undo.
- [x] Expanded text example bookmark visibility/docs, unrealized ARC/ORC removal/
      clearing/gravity/ownership/purity/immediate-deletion/dropped-alias tests, eight
      native prototypes/cdecl/layout probes and isolated cursor-pixel/shared-view
      gravity regressions with opt-in guard.

## Completed batch: Raw GtkTextView bitfield/public-policy audit

- [x] Removed 16 helpers/16 masks without aliases. Two obsolete bit names actually
      addressed accepts_tab/width_changed in GTK2.24; no guessed replacements.
- [x] Bound public get/set_overwrite and ergonomic overwriteMode; pinned native
      editable/cursorVisible/acceptsTab/overwrite mutations. Preserved shared buffer,
      readonly/tag permissions, native typing/IME/Insert/selection/Tab behavior.
- [x] Preserved instance storage; corrected missing class backspace and shifted
      clipboard/toggle/move_focus slots with class size/seven reserved slots intact.
      Added native size/offset, eight boolean prototypes and callback/cdecl probes.
- [x] Documented native unrealized-overwrite invalidation defect. Checked changing
      overwrite requires realization, never realizes implicitly; same-value no-op
      allowed. Native diagnostic/source-only optional patch, no installed GTK change.
- [x] Expanded text example/docs, compile/source guards and unrealized ARC/ORC
      shared-buffer/boolean/pin/purity/lifetime tests; isolated native overwrite/
      Insert/selection/readonly/hidden-caret Tab/focus tests and opt-in guard.

## Completed batch: Remaining raw GtkEntry bitfield audit

- [x] Removed all 20 remaining Entry bitfield helpers and 26 Entry mask/shift constants
      (including earlier overwrite/frame/default masks misplaced in menu_2.nim).
      No aliases; Entry instance storage unchanged. Source guards prevent regression.
- [x] Audited public GtkEditable boolean and Entry text-visibility replacements;
      editing-canceled remains a typed public GtkCellEditable property only within
      its lifecycle. No invented private-state getter/reset, undo or model rebinding.
- [x] Fixed existing GtkEntryClass backspace/clipboard/toggle/text-area slot names,
      keeping class size/two native reserved slots. Added native instance/class
      size/offset, boolean prototype and cdecl signed text-area callback probes.
- [x] Pinned ergonomic editable setter through raw notify, expanded inputs readonly
      control/docs and unrealized ARC/ORC compile-rejection/public clearing/property/
      lifetime/combo/SpinButton tests. Existing mapped editing covers readonly input.

## Completed batch: Entry progress feedback

- [x] Audited public fraction/pulse-step/pulse, native geometry, notifications and
      activity transitions. First pulse clears fraction without notify; zero getter
      is not an activity query; explicit fraction assignment ends activity.
- [x] Added finite 0..1 progressFraction/progressPulseStep gdouble policy and explicit
      progressPulse with native lifetime pins. No timer/source, event pump, shadow
      mode, private fields, model rebinding or simulated text progress.
- [x] Preserved text/selection/icons/completion/readonly/password/combo/SpinButton
      state, step endpoints, native theme/RTL/bounce and hide/show policy.
- [x] Expanded inputs/docs, unrealized ARC/ORC transition/atomicity/purity/lifetime
      tests, five native prototypes/precise gdouble and pulse callback ABI, isolated
      native pixel and icon-geometry rendering regressions plus opt-in guard.

Icon drag sources/providers, custom renderers, undo and deeper IME remain separate.

## Completed batch: Entry editing and concealed-text presentation

- [x] Audited native typing overwrite/Insert/selection, frame, explicit/default/blank
      glyph policies and dynamic password PRIMARY display (including hint caveat).
- [x] Checked overwriteMode/hasFrame and uint32 invisibleChar scalars, public-property
      invisibleCharSet and native unset; removed corresponding raw uint bitfield
      helpers without shims, preserving ABI storage. No private flag workaround.
- [x] Native pins cover setters/unset and existing visibility setter, including raw
      notifications dropping final aliases. Invalid scalars are atomic; policies do
      not pretend to mutate storage, validate numbers, reset history or synthesize typing.
- [x] Programmatic insertion/readonly/password safeguards, protected combo and inherited
      SpinButton behavior retained. Masking is not clipboard security: native blank
      PRIMARY uses spaces and password hints may reveal a recently typed character.
- [x] Expanded inputs/docs with non-secret sample, hidden unrealized ARC/ORC lifetime/
      scalar/purity tests, nine native prototypes/gunichar ABI and isolated native
      overwrite/Insert-key/selection and programmatic password PRIMARY regressions.

## Completed batch: Entry icons and icon activation

- [x] Audited public icon storage/ownership, allocated tooltip vs borrowed name/pixbuf,
      native C-width positions and post-signal icon-state/window traversal.
- [x] Checked pixbuf/named-icon configuration, owning rendered pixbuf getter, plain
      escaped tooltips and native sensitivity/activatability. Clear preserves native
      policies; no private structs, internal widgets, markup or simulated icon clicks.
- [x] Copied deferred per-emission EntryIconEvent/ButtonEvent observations, listener
      snapshots, non-owning tokens and independent metadata/native/source pins.
- [x] Per-position generation cancellation, per-listener sensitivity/storage checks,
      hide/unmap/destruction cleanup, prompt captures, reentrant replacement/self-close
      and pure model-function guards. Password/readonly events never copy text.
- [x] Expanded inputs/docs, unrealized hidden ARC/ORC ownership/lifetime tests, twelve
      public icon prototypes/native enum/GdkEvent ABI and isolated real pointer input,
      inert flags, press-time replacement and release-time combo teardown.

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

- [ ] Arbitrary completion models/columns.
- [ ] Richer completion presentation/providers.
- [ ] Deeper IME integration.
- [ ] Audit/remove remaining legacy raw widget bitfield helpers before exposing
      corresponding policies; TextLayout/display/cursor audit is deferred (Entry/TextView/Mark/Attributes/Tag/Table/Buffer/BTree/Line complete).

### Clipboard and drag-and-drop

- [x] URI clipboard offers/requests with copied tokens (functionality batch above).
- [x] URI COPY-only drag/drop pads with independent wire teardown (batch above).
- [x] Copied synchronous URI drop acceptance (functionality batch above).
- [x] Copied outgoing image clipboard snapshots (functionality batch above).
- [x] Explicitly trusted copied incoming image requests (functionality batch above).
- [x] Explicitly trusted COPY-only image drag/drop pads (functionality batch above).
- [ ] Copied Pixbuf RGBA pixel values (proposed next).
- [ ] Clipboard-manager persistence.
- [x] Copied outgoing binary clipboard offers (functionality batch above).
- [x] Copied binary clipboard requests (functionality batch above).
- [x] COPY-only binary drag/drop pads (functionality batch above).
- [ ] MOVE semantics with explicit source-deletion/ownership rules.
- [x] Copied drag-source Pixbuf icons (functionality batch above).
- [ ] Broader custom drag icons/widgets/hotspots and public context affordances.
- [x] Copied synchronous application URI drop acceptance (batch above).
- [ ] Broader application-controlled drop acceptance and asynchronous protocols.

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

- [x] Trusted image COPY pads with actual begin snapshots, metadata-only acceptance,
      idle owned pixels and independent real reply drains/XTEST regressions (above).
- [x] Explicitly trusted image requests with post-decode copy bounds, owned idle results,
      non-retaining owner cancellation and actual trusted-fixture regressions (above).
- [x] Copied drag-source Pixbuf icons with actual native defaults, active-context
      lifetime and XTEST cursor/popup pixel/source-update regressions (above).
- [x] COPY-only binary pads with begin snapshots, guarded acceptance, independent
      draining receivers and actual XTEST/INCR/lifecycle/type/bound regressions (above).
- [x] Bounded opaque binary requests with idle copied result kinds, independent wire/
      idle/weak-owner pins and actual delayed/large/cancellation regressions (above).
- [x] Opaque binary clipboard offers, conservative MIME/size boundaries, exact native
      byte/type/format publication and isolated foreign large transfer/clear regressions.
- [x] Copied image clipboard offers, native writable encoding/clear pins and actual
      local/foreign trusted PNG mutation/ownership regressions (above).
- [x] Copied pre-finish URI acceptance with pure guards, capture lifetimes and actual
      X11 outcome-bit/copy/error/deferred-release/foreign cancellation regressions (above).
- [x] URI COPY-only pad snapshots/observations, draining reply/receiver lifetimes and
      isolated real local/foreign cancellation/destruction regressions (above).
- [x] URI clipboard offers/async requests with copied values, explicit failure modes,
      independent native pins and isolated local/foreign transfer regressions (above).
- [x] Private line/segment APIs/guessed types removed, opaque pointer boundaries and
      public iterator/list/anchor/wrapped-display regressions (above).
- [x] Private tree entry-point removal, typed opaque IconSet/native window enum fixes
      and public Unicode/object/mark/geometry regression paths (above).
- [x] Raw buffer flag removal/native class/storage fixes, public state/return semantics
      and pinned mutation/user-action lifetime coverage (above).
- [x] Raw table private-hook removal, public ownership/traversal contracts and native
      shared-buffer finalization/table-wide removal coverage (above).
- [x] Raw tag flag removal, native property/priority/membership audit and pinned
      override/range lifetimes, with native inheritance/removal rendering (above).
- [x] Attributes/Appearance helper removal, ref-return ABI and boxed/style ownership
      audit with native snapshot rendering and source-only leak patch (above).
- [x] Raw mark private-body removal, own-before-insert creation, explicit buffer
      ownership and native lifetime/gravity/cursor rendering coverage (above).
- [x] Raw TextView flag cleanup, native class-slot/boolean audit, pinned view policy,
      unrealized overwrite precondition and isolated edit/focus coverage (above).
- [x] Removed remaining raw Entry private-bitfield helpers/masks, corrected native
      class slots, documented public replacements and added ABI/compile guards (above).
- [x] Native Entry progress fraction/step and explicit pulse, no shadow mode/timer,
      notification/lifetime/atomicity and isolated native rendering coverage (above).
- [x] Native Entry overwrite/frame and checked mask/default policies, pinned visibility,
      native keyboard/PRIMARY behavior and password-security caveats (above).
- [x] Native Entry icons, owning image/tooltips and deferred copied pointer events,
      independent per-position policy/cancellation and isolated pointer tests (above).
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
