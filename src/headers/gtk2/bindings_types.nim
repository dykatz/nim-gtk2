# Included by headers/gtk2.nim; do not import directly.
type
  TBindingArg*{.final, pure.} = object
    arg_type*: TType
    d*: gdouble

  PBindingArg* = ptr TBindingArg
  PBindingSignal* = ptr TBindingSignal
  TBindingSignal*{.final, pure.} = object
    next*: PBindingSignal
    signal_name*: cstring
    n_args*: guint
    args*: PBindingArg

  PBindingEntry* = ptr TBindingEntry
  PBindingSet* = ptr TBindingSet
  TBindingSet*{.final, pure.} = object
    set_name*: cstring
    priority*: gint
    widget_path_pspecs*: PGSList
    widget_class_pspecs*: PGSList
    class_branch_pspecs*: PGSList
    entries*: PBindingEntry
    current*: PBindingEntry
    flag0*: guint16

  TBindingEntry*{.final, pure.} = object
    keyval*: guint
    modifiers*: gdk2.TModifierType
    binding_set*: PBindingSet
    flag0*: guint16
    set_next*: PBindingEntry
    hash_next*: PBindingEntry
    signals*: PBindingSignal

