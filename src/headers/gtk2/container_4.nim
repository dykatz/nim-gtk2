# Included by headers/gtk2.nim; do not import directly.
proc reallocate_redraws*(a: PContainer): guint =
  result = (a.Containerflag0 and bm_TGtkContainer_reallocate_redraws) shr
      bp_TGtkContainer_reallocate_redraws

proc set_reallocate_redraws*(a: PContainer, `reallocate_redraws`: guint) =
  a.Containerflag0 = a.Containerflag0 or
      ((`reallocate_redraws` shl bp_TGtkContainer_reallocate_redraws) and
      bm_TGtkContainer_reallocate_redraws)

proc has_focus_chain*(a: PContainer): guint =
  result = (a.Containerflag0 and bm_TGtkContainer_has_focus_chain) shr
      bp_TGtkContainer_has_focus_chain

proc set_has_focus_chain*(a: PContainer, `has_focus_chain`: guint) =
  a.Containerflag0 = a.Containerflag0 or
      ((`has_focus_chain` shl bp_TGtkContainer_has_focus_chain) and
      bm_TGtkContainer_has_focus_chain)

proc CONTAINER_WARN_INVALID_CHILD_PROPERTY_ID*(anObject: pointer,
    property_id: guint, pspec: pointer) =
  write(stdout, "WARNING: invalid child property id\x0A")

