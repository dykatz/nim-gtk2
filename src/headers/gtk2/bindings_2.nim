# Included by headers/gtk2.nim; do not import directly.
proc parsed*(a: PBindingSet): guint =
  result = (a.flag0 and bm_TGtkBindingSet_parsed) shr
      bp_TGtkBindingSet_parsed

proc set_parsed*(a: PBindingSet, `parsed`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`parsed` shl bp_TGtkBindingSet_parsed) and
      bm_TGtkBindingSet_parsed)

proc destroyed*(a: PBindingEntry): guint =
  result = (a.flag0 and bm_TGtkBindingEntry_destroyed) shr
      bp_TGtkBindingEntry_destroyed

proc set_destroyed*(a: PBindingEntry, `destroyed`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`destroyed` shl bp_TGtkBindingEntry_destroyed) and
      bm_TGtkBindingEntry_destroyed)

proc in_emission*(a: PBindingEntry): guint =
  result = ((a.flag0 and bm_TGtkBindingEntry_in_emission) shr
      bp_TGtkBindingEntry_in_emission).guint

proc set_in_emission*(a: PBindingEntry, `in_emission`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`in_emission` shl bp_TGtkBindingEntry_in_emission) and
      bm_TGtkBindingEntry_in_emission)

proc entry_add*(binding_set: PBindingSet, keyval: guint,
                        modifiers: gdk2.TModifierType) =
  entry_clear(binding_set, keyval, modifiers)

