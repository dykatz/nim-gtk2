# Included by headers/gtk2.nim; do not import directly.
proc menu_bar_append*(menu, child: PWidget) =
  append(cast[PMenuShell](menu), child)

proc menu_bar_prepend*(menu, child: PWidget) =
  prepend(cast[PMenuShell](menu), child)

proc menu_bar_insert*(menu, child: PWidget, pos: gint) =
  insert(cast[PMenuShell](menu), child, pos)

