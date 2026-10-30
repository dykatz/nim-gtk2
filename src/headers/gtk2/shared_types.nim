# Included by headers/gtk2.nim; do not import directly.
type
  TType* = GType
  PType* = ptr TType
  TTextBTreeNode = object
  PTextBTreeNode* = ptr TTextBTreeNode
  TFundamentalType* = GType
  PFundamentalType* = ptr TFundamentalType
  TFunction* = proc (data: gpointer): gboolean{.cdecl.}
  TDestroyNotify* = proc (data: gpointer){.cdecl.}
  TSignalFunc* = proc (para1: pointer){.cdecl, gcsafe.}
  TSignalMarshaller* = TGSignalCMarshaller
  PSignalMarshaller* = ptr TSignalMarshaller
  TArgSignalData*{.final, pure.} = object
    f*: TSignalFunc
    d*: gpointer

  TEnumValue* = TGEnumValue
  PEnumValue* = ptr TEnumValue
  TFlagValue* = TGFlagsValue
  PFlagValue* = ptr TFlagValue
  TAllocation* = gdk2.TRectangle
  PAllocation* = ptr TAllocation
  TAccelMapForeach* = proc (data: gpointer, accel_path: cstring,
                            accel_key: guint, accel_mods: gdk2.TModifierType,
                            changed: gboolean){.cdecl.}
  PGArray = pointer
  TColorSelectionChangePaletteFunc* = proc (colors: gdk2.PColor, n_colors: gint){.
      cdecl.}
  TColorSelectionChangePaletteWithScreenFunc* = proc (screen: gdk2.PScreen,
      colors: gdk2.PColor, n_colors: gint){.cdecl.}
  Tctlpoint* = array[0..1, gfloat]
  Pctlpoint* = ptr Tctlpoint
  TRcPropertyParser* = proc (pspec: PGParamSpec, rc_string: PGString,
                             property_value: PGValue): gboolean{.cdecl.}
  TPrintFunc* = proc (func_data: gpointer, str: cstring){.cdecl.}
  TTranslateFunc* = gchar
  PTranslateFunc* = ptr TTranslateFunc
  TItemFactoryCallback* = proc (){.cdecl.}
  TModuleInitFunc* = proc (argc: Pgint, argv: PPPgchar){.cdecl.}
  TTextCharPredicate* = proc (ch: gunichar, user_data: gpointer): gboolean{.
      cdecl.}
  TTextPixbuf*{.final, pure.} = object
    pixbuf*: gdk2pixbuf.PPixbuf

  PTextPixbuf* = ptr TTextPixbuf
  TRBNodeColor* = int32
  PRBNodeColor* = ptr TRBNodeColor
  PRBTree* = ptr TRBTree
  PRBNode* = ptr TRBNode
  TRBTree*{.final, pure.} = object
    root*: PRBNode
    `nil`*: PRBNode
    parent_tree*: PRBTree
    parent_node*: PRBNode

  TRBNode*{.final, pure.} = object
    flag0*: guint16
    left*: PRBNode
    right*: PRBNode
    parent*: PRBNode
    count*: gint
    offset*: gint
    children*: PRBTree

  TRBTreeTraverseFunc* = proc (tree: PRBTree, node: PRBNode, data: gpointer){.
      cdecl.}
  TTreeViewFlags* = int32
  PTreeViewFlags* = ptr TTreeViewFlags
