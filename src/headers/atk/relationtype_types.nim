# Included by headers/atk.nim; do not import directly.
type
  TRelationType* = enum
    RELATION_NULL, RELATION_CONTROLLED_BY, RELATION_CONTROLLER_FOR,
    RELATION_LABEL_FOR, RELATION_LABELLED_BY, RELATION_MEMBER_OF,
    RELATION_NODE_CHILD_OF, RELATION_LAST_DEFINED
  PRelationType* = ptr TRelationType
