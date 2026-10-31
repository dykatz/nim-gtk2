# Included by gtk2.nim. GTK2's modern ToolItem-based toolbar API only.
type
  Toolbar* = object of Container
  ToolItem* = object of Bin
  ToolButton* = object of ToolItem
  ToggleToolButton* = object of ToolButton
  RadioToolButton* = object of ToggleToolButton
  MenuToolButton* = object of ToolButton
  SeparatorToolItem* = object of ToolItem
  ToolPalette* = object of Container
  ToolItemGroup* = object of Container
  Orientation* = enum horizontal, vertical
  ToolbarStyle* = enum toolbarIcons, toolbarText, toolbarBoth, toolbarBothHorizontal
  ReliefStyle* = enum reliefNormal, reliefHalf, reliefNone
  EllipsizeMode* = enum ellipsizeNone, ellipsizeStart, ellipsizeMiddle, ellipsizeEnd
  ToolItemPacking* = object
    homogeneous*, expand*, fill*, newRow*: bool

proc raw*(w: Toolbar): rawGtk.PToolbar = cast[rawGtk.PToolbar](raw(Widget(w)))
proc raw*(w: ToolItem): ptr rawGtk.ToolItem = cast[ptr rawGtk.ToolItem](raw(Widget(w)))
proc raw*(w: ToolButton): ptr rawGtk.ToolButton = cast[ptr rawGtk.ToolButton](raw(Widget(w)))
proc raw*(w: ToggleToolButton): ptr rawGtk.ToggleToolButton = cast[ptr rawGtk.ToggleToolButton](raw(Widget(w)))
proc raw*(w: RadioToolButton): ptr rawGtk.RadioToolButton = cast[ptr rawGtk.RadioToolButton](raw(Widget(w)))
proc raw*(w: MenuToolButton): ptr rawGtk.MenuToolButton = cast[ptr rawGtk.MenuToolButton](raw(Widget(w)))
proc raw*(w: SeparatorToolItem): ptr rawGtk.SeparatorToolItem = cast[ptr rawGtk.SeparatorToolItem](raw(Widget(w)))
proc raw*(w: ToolPalette): ptr rawGtk.ToolPalette = cast[ptr rawGtk.ToolPalette](raw(Widget(w)))
proc raw*(w: ToolItemGroup): ptr rawGtk.ToolItemGroup = cast[ptr rawGtk.ToolItemGroup](raw(Widget(w)))

proc newToolbar*(): Toolbar = result.state = adoptWidget(rawGtk.toolbar_new())
proc newToolItem*(): ToolItem = result.state = adoptWidget(rawGtk.tool_item_new())
proc newToolButton*(text = "", mnemonic = false): ToolButton =
  let label = checkedUtf8Text(text)
  result.state = adoptWidget(rawGtk.tool_button_new(nil, label))
  rawGtk.tool_button_set_use_underline(result.raw, g.gbool(mnemonic))
proc newToggleToolButton*(text = "", mnemonic = false): ToggleToolButton =
  let label = checkedUtf8Text(text)
  result.state = adoptWidget(rawGtk.toggle_tool_button_new())
  rawGtk.tool_button_set_label(cast[ptr rawGtk.ToolButton](result.raw), label)
  rawGtk.tool_button_set_use_underline(cast[ptr rawGtk.ToolButton](result.raw), g.gbool(mnemonic))
proc makeRadioToolButton(group: ptr rawGtk.RadioToolButton, text: string, mnemonic: bool): RadioToolButton =
  let label = checkedUtf8Text(text)
  result.state = adoptWidget(if group == nil: rawGtk.radio_tool_button_new(nil)
    else: rawGtk.radio_tool_button_new_from_widget(group))
  rawGtk.tool_button_set_label(cast[ptr rawGtk.ToolButton](result.raw), label)
  rawGtk.tool_button_set_use_underline(cast[ptr rawGtk.ToolButton](result.raw), g.gbool(mnemonic))
proc newRadioToolButton*(text = "", mnemonic = false): RadioToolButton = makeRadioToolButton(nil, text, mnemonic)
proc newRadioToolButton*(group: RadioToolButton, text = "", mnemonic = false): RadioToolButton =
  makeRadioToolButton(group.raw, text, mnemonic)
proc joinGroup*(w: RadioToolButton, group: RadioToolButton) =
  let p = w.raw
  let target = rawGtk.radio_tool_button_get_group(group.raw)
  if rawGtk.radio_tool_button_get_group(p) != target:
    rawGtk.radio_tool_button_set_group(p, target)
proc newMenuToolButton*(text = "", mnemonic = false): MenuToolButton =
  let label = checkedUtf8Text(text)
  result.state = adoptWidget(rawGtk.menu_tool_button_new(nil, label))
  rawGtk.tool_button_set_use_underline(cast[ptr rawGtk.ToolButton](result.raw), g.gbool(mnemonic))
proc newSeparatorToolItem*(draw = true): SeparatorToolItem =
  result.state = adoptWidget(rawGtk.separator_tool_item_new())
  rawGtk.separator_tool_item_set_draw(result.raw, g.gbool(draw))
proc destroyPaletteChildren(instance, data: pointer) {.cdecl, gcsafe.} =
  # GTK2's palette forall iterates a mutating GPtrArray during container destroy
  # and skips alternate groups. Retain a snapshot and destroy each exactly once.
  {.cast(gcsafe).}:
    let children = rawGtk.get_children(cast[rawGtk.PContainer](instance))
    var held: seq[pointer]
    var node = children
    while node != nil:
      held.add(g.g_object_ref(node.data))
      node = node.next
    g.free(children)
    for p in held:
      if rawGtk.get_parent(cast[rawGtk.PWidget](p)) == cast[rawGtk.PWidget](instance):
        rawGtk.tool_palette_set_exclusive(cast[ptr rawGtk.ToolPalette](instance),
          cast[ptr rawGtk.ToolItemGroup](p), g.gbool(false))
    for p in held:
      if rawGtk.get_parent(cast[rawGtk.PWidget](p)) == cast[rawGtk.PWidget](instance):
        rawGtk.destroy(cast[rawGtk.PWidget](p))
      g.g_object_unref(p)
proc newToolPalette*(): ToolPalette =
  result.state = adoptWidget(rawGtk.tool_palette_new())
  # No closure or borrowed Nim data; survives temporary handle release safely.
  discard g.g_signal_connect_data(result.raw, "destroy", cast[g.TGCallback](destroyPaletteChildren), nil, nil, g.G_CONNECT_AFTER)
proc stopToolGroupSources(instance, data: pointer) {.cdecl, gcsafe.} =
  # GTK2 animation timeouts borrow the group and are not cancelled by dispose.
  # Cancel native sources with this exact user-data pointer before it can die.
  var source = g.g_main_context_find_source_by_user_data(nil, instance)
  while source != nil:
    g.g_source_destroy(source)
    source = g.g_main_context_find_source_by_user_data(nil, instance)
proc newToolItemGroup*(text = ""): ToolItemGroup =
  result.state = adoptWidget(rawGtk.tool_item_group_new(checkedUtf8Text(text)))
  discard g.g_signal_connect_data(result.raw, "destroy", cast[g.TGCallback](stopToolGroupSources), nil, nil, g.G_CONNECT_AFTER)

proc itemCount*(w: Toolbar): int = rawGtk.toolbar_get_n_items(w.raw).int
proc itemCount*(w: ToolItemGroup): int = rawGtk.tool_item_group_get_n_items(w.raw).int
proc toolbarIndex(index, count: int, inserting = false): g.gint =
  if index < 0 or index > count or (not inserting and index == count):
    raise newException(ValueError, "toolbar/palette index out of bounds")
  checkedInt(index)
proc checkToolChild(parent: Container, child: Widget) =
  checkChild(parent, child)
  if menuAncestorContains(parent.raw, child.raw):
    raise newException(ValueError, "toolbar/palette insertion would contain an ownership cycle")
proc insert*(w: Toolbar, item: ToolItem, index: int) =
  checkToolChild(w, item)
  let position = toolbarIndex(index, w.itemCount, true)
  rawGtk.toolbar_insert(w.raw, item.raw, position)
proc insert*(w: ToolItemGroup, item: ToolItem, index: int) =
  checkToolChild(w, item)
  let position = toolbarIndex(index, w.itemCount, true)
  rawGtk.tool_item_group_insert(w.raw, item.raw, position)
proc append*(w: Toolbar, item: ToolItem) = w.insert(item, w.itemCount)
proc prepend*(w: Toolbar, item: ToolItem) = w.insert(item, 0)
proc append*(w: ToolItemGroup, item: ToolItem) = w.insert(item, w.itemCount)
proc prepend*(w: ToolItemGroup, item: ToolItem) = w.insert(item, 0)
proc itemAt*(w: Toolbar, index: int): ToolItem =
  let p = rawGtk.toolbar_get_nth_item(w.raw, toolbarIndex(index, w.itemCount))
  result.state = adoptObject(p, borrowed = true, cache = true)
proc itemAt*(w: ToolItemGroup, index: int): ToolItem =
  discard toolbarIndex(index, w.itemCount)
  result.state = adoptObject(rawGtk.tool_item_group_get_nth_item(w.raw, g.guint(index)), borrowed = true, cache = true)
proc itemIndex*(w: Toolbar, item: ToolItem): int =
  checkMember(w, item)
  rawGtk.toolbar_get_item_index(w.raw, item.raw).int
proc itemIndex*(w: ToolItemGroup, item: ToolItem): int =
  checkMember(w, item)
  rawGtk.tool_item_group_get_item_position(w.raw, item.raw).int
proc moveItem*(w: ToolItemGroup, item: ToolItem, index: int) =
  checkMember(w, item)
  rawGtk.tool_item_group_set_item_position(w.raw, item.raw, toolbarIndex(index, w.itemCount))

proc groupCount*(w: ToolPalette): int =
  let children = rawGtk.get_children(cast[rawGtk.PContainer](w.raw))
  defer: g.free(children)
  var node = children
  while node != nil:
    inc result
    node = node.next
proc add*(w: ToolPalette, group: ToolItemGroup) =
  checkToolChild(w, group)
  rawGtk.add(cast[rawGtk.PContainer](w.raw), cast[rawGtk.PWidget](group.raw))
proc groupAt*(w: ToolPalette, index: int): ToolItemGroup =
  discard toolbarIndex(index, w.groupCount)
  let children = rawGtk.get_children(cast[rawGtk.PContainer](w.raw))
  defer: g.free(children)
  var node = children
  for i in 0..<index: node = node.next
  result.state = adoptObject(node.data, borrowed = true, cache = true)
proc groupIndex*(w: ToolPalette, group: ToolItemGroup): int =
  checkMember(w, group)
  rawGtk.tool_palette_get_group_position(w.raw, group.raw).int
proc exclusive*(w: ToolPalette, group: ToolItemGroup): bool =
  checkMember(w, group)
  g.toBool(rawGtk.tool_palette_get_exclusive(w.raw, group.raw))
proc setExclusive*(w: ToolPalette, group: ToolItemGroup, value = true) =
  checkMember(w, group)
  rawGtk.tool_palette_set_exclusive(w.raw, group.raw, g.gbool(value))
proc groupExpand*(w: ToolPalette, group: ToolItemGroup): bool =
  checkMember(w, group)
  g.toBool(rawGtk.tool_palette_get_expand(w.raw, group.raw))
proc setGroupExpand*(w: ToolPalette, group: ToolItemGroup, value = true) =
  checkMember(w, group)
  rawGtk.tool_palette_set_expand(w.raw, group.raw, g.gbool(value))
proc horizontalAdjustment*(w: ToolPalette): Adjustment = ownedAdjustment(rawGtk.tool_palette_get_hadjustment(w.raw))
proc verticalAdjustment*(w: ToolPalette): Adjustment = ownedAdjustment(rawGtk.tool_palette_get_vadjustment(w.raw))

proc orientation*(w: Toolbar): Orientation = Orientation(rawGtk.get_orientation(w.raw))
proc `orientation=`*(w: Toolbar, value: Orientation) = rawGtk.set_orientation(w.raw, rawGtk.TOrientation(ord(value)))
proc orientation*(w: ToolPalette): Orientation = Orientation(rawGtk.orientable_get_orientation(cast[ptr rawGtk.Orientable](w.raw)))
proc `orientation=`*(w: ToolPalette, value: Orientation) = rawGtk.orientable_set_orientation(cast[ptr rawGtk.Orientable](w.raw), rawGtk.TOrientation(ord(value)))
proc orientation*(w: ToolItem): Orientation = Orientation(rawGtk.tool_item_get_orientation(w.raw))
proc toolbarStyle*(w: Toolbar): ToolbarStyle = ToolbarStyle(rawGtk.toolbar_get_style(w.raw))
proc `toolbarStyle=`*(w: Toolbar, value: ToolbarStyle) = rawGtk.toolbar_set_style(w.raw, rawGtk.TToolbarStyle(ord(value)))
proc resetToolbarStyle*(w: Toolbar) = rawGtk.toolbar_unset_style(w.raw)
proc toolbarStyle*(w: ToolPalette): ToolbarStyle = ToolbarStyle(rawGtk.tool_palette_get_style(w.raw))
proc `toolbarStyle=`*(w: ToolPalette, value: ToolbarStyle) = rawGtk.tool_palette_set_style(w.raw, rawGtk.TToolbarStyle(ord(value)))
proc resetToolbarStyle*(w: ToolPalette) = rawGtk.tool_palette_unset_style(w.raw)
proc toolbarStyle*(w: ToolItem): ToolbarStyle = ToolbarStyle(rawGtk.tool_item_get_toolbar_style(w.raw))
proc iconSize*(w: Toolbar): IconSize = IconSize(rawGtk.toolbar_get_icon_size(w.raw))
proc `iconSize=`*(w: Toolbar, value: IconSize) = rawGtk.toolbar_set_icon_size(w.raw, rawGtk.TIconSize(ord(value)))
proc resetIconSize*(w: Toolbar) = rawGtk.toolbar_unset_icon_size(w.raw)
proc iconSize*(w: ToolPalette): IconSize = IconSize(rawGtk.tool_palette_get_icon_size(w.raw))
proc `iconSize=`*(w: ToolPalette, value: IconSize) = rawGtk.tool_palette_set_icon_size(w.raw, rawGtk.TIconSize(ord(value)))
proc resetIconSize*(w: ToolPalette) = rawGtk.tool_palette_unset_icon_size(w.raw)
proc iconSize*(w: ToolItem): IconSize = IconSize(rawGtk.tool_item_get_icon_size(w.raw))
proc reliefStyle*(w: Toolbar): ReliefStyle = ReliefStyle(rawGtk.toolbar_get_relief_style(w.raw))
proc reliefStyle*(w: ToolItem): ReliefStyle = ReliefStyle(rawGtk.tool_item_get_relief_style(w.raw))
proc showArrow*(w: Toolbar): bool = g.toBool(rawGtk.toolbar_get_show_arrow(w.raw))
proc `showArrow=`*(w: Toolbar, value: bool) = rawGtk.toolbar_set_show_arrow(w.raw, g.gbool(value))

proc homogeneous*(w: ToolItem): bool = g.toBool(rawGtk.tool_item_get_homogeneous(w.raw))
proc `homogeneous=`*(w: ToolItem, value: bool) = rawGtk.tool_item_set_homogeneous(w.raw, g.gbool(value))
proc expand*(w: ToolItem): bool = g.toBool(rawGtk.tool_item_get_expand(w.raw))
proc `expand=`*(w: ToolItem, value: bool) = rawGtk.tool_item_set_expand(w.raw, g.gbool(value))
proc visibleHorizontal*(w: ToolItem): bool = g.toBool(rawGtk.tool_item_get_visible_horizontal(w.raw))
proc `visibleHorizontal=`*(w: ToolItem, value: bool) = rawGtk.tool_item_set_visible_horizontal(w.raw, g.gbool(value))
proc visibleVertical*(w: ToolItem): bool = g.toBool(rawGtk.tool_item_get_visible_vertical(w.raw))
proc `visibleVertical=`*(w: ToolItem, value: bool) = rawGtk.tool_item_set_visible_vertical(w.raw, g.gbool(value))
proc important*(w: ToolItem): bool = g.toBool(rawGtk.tool_item_get_is_important(w.raw))
proc `important=`*(w: ToolItem, value: bool) = rawGtk.tool_item_set_is_important(w.raw, g.gbool(value))
proc `tooltipText=`*(w: ToolItem, value: string) = rawGtk.tool_item_set_tooltip_text(w.raw, checkedUtf8Text(value))
proc text*(w: ToolButton): string = $rawGtk.tool_button_get_label(w.raw)
proc `text=`*(w: ToolButton, value: string) = rawGtk.tool_button_set_label(w.raw, checkedUtf8Text(value))
proc useUnderline*(w: ToolButton): bool = g.toBool(rawGtk.tool_button_get_use_underline(w.raw))
proc `useUnderline=`*(w: ToolButton, value: bool) = rawGtk.tool_button_set_use_underline(w.raw, g.gbool(value))
proc stockId*(w: ToolButton): string = $rawGtk.tool_button_get_stock_id(w.raw)
proc `stockId=`*(w: ToolButton, value: string) =
  let text = checkedUtf8Text(value)
  rawGtk.tool_button_set_stock_id(w.raw, if value.len == 0: nil else: text)
proc iconName*(w: ToolButton): string = $rawGtk.tool_button_get_icon_name(w.raw)
proc `iconName=`*(w: ToolButton, value: string) =
  let text = checkedUtf8Text(value)
  rawGtk.tool_button_set_icon_name(w.raw, if value.len == 0: nil else: text)
proc image*(w: ToolButton): Image =
  let p = rawGtk.tool_button_get_icon_widget(w.raw)
  if p != nil: result.state = adoptObject(p, borrowed = true, cache = true)
proc `image=`*(w: ToolButton, value: Image) =
  let p = w.raw
  if rawGtk.tool_button_get_icon_widget(p) == cast[rawGtk.PWidget](value.raw): return
  checkToolChild(w, value)
  rawGtk.tool_button_set_icon_widget(p, cast[rawGtk.PWidget](value.raw))
proc clearImage*(w: ToolButton) = rawGtk.tool_button_set_icon_widget(w.raw, nil)
proc active*(w: ToggleToolButton): bool = g.toBool(rawGtk.toggle_tool_button_get_active(w.raw))
proc `active=`*(w: ToggleToolButton, value: bool) = rawGtk.toggle_tool_button_set_active(w.raw, g.gbool(value))
proc draw*(w: SeparatorToolItem): bool = g.toBool(rawGtk.separator_tool_item_get_draw(w.raw))
proc `draw=`*(w: SeparatorToolItem, value: bool) = rawGtk.separator_tool_item_set_draw(w.raw, g.gbool(value))

proc menu*(w: MenuToolButton): Menu =
  let p = rawGtk.menu_tool_button_get_menu(w.raw)
  if p != nil: result.state = adoptObject(p, borrowed = true, cache = true)
proc hasMenu*(w: MenuToolButton): bool = rawGtk.menu_tool_button_get_menu(w.raw) != nil
proc `menu=`*(w: MenuToolButton, value: Menu) =
  let p = w.raw
  let m = value.raw
  if rawGtk.menu_tool_button_get_menu(p) == cast[rawGtk.PWidget](m): return
  if rawGtk.get_attach_widget(m) != nil:
    raise newException(ValueError, "menu is already attached; clear its existing owner first")
  if menuAncestorContains(cast[rawGtk.PWidget](p), cast[rawGtk.PWidget](m)):
    raise newException(ValueError, "menu attachment would contain an ownership cycle")
  rawGtk.menu_tool_button_set_menu(p, cast[rawGtk.PWidget](m))
proc clearMenu*(w: MenuToolButton) = rawGtk.menu_tool_button_set_menu(w.raw, nil)
proc `arrowTooltipText=`*(w: MenuToolButton, value: string) =
  rawGtk.menu_tool_button_set_arrow_tooltip_text(w.raw, checkedUtf8Text(value))
proc text*(w: ToolItemGroup): string = $rawGtk.tool_item_group_get_label(w.raw)
proc `text=`*(w: ToolItemGroup, value: string) = rawGtk.tool_item_group_set_label(w.raw, checkedUtf8Text(value))
proc collapsed*(w: ToolItemGroup): bool = g.toBool(rawGtk.tool_item_group_get_collapsed(w.raw))
proc `collapsed=`*(w: ToolItemGroup, value: bool) = rawGtk.tool_item_group_set_collapsed(w.raw, g.gbool(value))
proc ellipsize*(w: ToolItemGroup): EllipsizeMode = EllipsizeMode(cint(rawGtk.tool_item_group_get_ellipsize(w.raw)))
proc `ellipsize=`*(w: ToolItemGroup, value: EllipsizeMode) = rawGtk.tool_item_group_set_ellipsize(w.raw, rawGtk.EllipsizeMode(ord(value)))
proc headerRelief*(w: ToolItemGroup): ReliefStyle = ReliefStyle(rawGtk.tool_item_group_get_header_relief(w.raw))
proc `headerRelief=`*(w: ToolItemGroup, value: ReliefStyle) = rawGtk.tool_item_group_set_header_relief(w.raw, rawGtk.TReliefStyle(ord(value)))
proc groupChildBool(w: ToolItemGroup, item: ToolItem, name: cstring): bool =
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_BOOLEAN)
  defer: g.unset(addr value)
  rawGtk.child_get_property(cast[rawGtk.PContainer](w.raw), cast[rawGtk.PWidget](item.raw), name, addr value)
  g.toBool(g.get_boolean(addr value))
proc itemPacking*(w: ToolItemGroup, item: ToolItem): ToolItemPacking =
  checkMember(w, item)
  ToolItemPacking(homogeneous: groupChildBool(w, item, "homogeneous"), expand: groupChildBool(w, item, "expand"),
    fill: groupChildBool(w, item, "fill"), newRow: groupChildBool(w, item, "new-row"))
proc setItemPacking*(w: ToolItemGroup, item: ToolItem, homogeneous = true, expand = false, fill = true, newRow = false) =
  checkMember(w, item)
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_BOOLEAN)
  defer: g.unset(addr value)
  for entry in [("homogeneous", homogeneous), ("expand", expand), ("fill", fill), ("new-row", newRow)]:
    g.set_boolean(addr value, g.gbool(entry[1]))
    rawGtk.child_set_property(cast[rawGtk.PContainer](w.raw), cast[rawGtk.PWidget](item.raw), entry[0].cstring, addr value)

proc onClicked*(w: ToolButton, fn: proc () {.closure.}): Connection {.discardable.} = connect(w, "clicked", fn, after = true)
proc onToggled*(w: ToggleToolButton, fn: proc () {.closure.}): Connection {.discardable.} = connect(w, "toggled", fn, after = true)
proc onShowMenu*(w: MenuToolButton, fn: proc () {.closure.}): Connection {.discardable.} = connect(w, "show-menu", fn, after = true)
