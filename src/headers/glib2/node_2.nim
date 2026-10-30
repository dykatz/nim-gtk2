# Included by headers/glib2.nim; do not import directly.
proc IS_ROOT*(node: PGNode): bool =
  result = (node.parent == nil) and (node.next == nil) and (node.prev == nil)

proc IS_LEAF*(node: PGNode): bool =
  result = node.children == nil

proc append*(parent: PGNode, node: PGNode): PGNode =
  result = insert_before(parent, nil, node)

proc insert_data*(parent: PGNode, position: gint, data: gpointer): PGNode =
  result = insert(parent, position, g_node_new(data))

proc insert_data_before*(parent: PGNode, sibling: PGNode,
                         data: gpointer): PGNode =
  result = insert_before(parent, sibling, g_node_new(data))

proc prepend_data*(parent: PGNode, data: gpointer): PGNode =
  result = prepend(parent, g_node_new(data))

proc append_data*(parent: PGNode, data: gpointer): PGNode =
  result = insert_before(parent, nil, g_node_new(data))

proc prev_sibling*(node: PGNode): PGNode =
  if node != nil:
    result = node.prev
  else:
    result = nil

proc next_sibling*(node: PGNode): PGNode =
  if node != nil:
    result = node.next
  else:
    result = nil

proc first_child*(node: PGNode): PGNode =
  if node != nil:
    result = node.children
  else:
    result = nil

