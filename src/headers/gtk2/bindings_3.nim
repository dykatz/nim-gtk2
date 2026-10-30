# Included by headers/gtk2.nim; do not import directly.
proc entry_add_signal*(binding_set: PBindingSet, keyval: guint,
                               modifiers: gdk2.TModifierType,
                               signal_name: cstring, n_args: guint){.varargs,
    importc: "gtk_binding_entry_add_signal", cdecl, dynlib: lib.}
