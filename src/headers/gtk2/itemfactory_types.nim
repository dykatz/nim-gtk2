# Included by headers/gtk2.nim; do not import directly.
type
  TItemFactory* = object of TObject
    path*: cstring
    accel_group*: PAccelGroup
    widget*: PWidget
    items*: PGSList
    translate_func*: TTranslateFunc
    translate_data*: gpointer
    translate_notify*: TDestroyNotify

  PItemFactory* = ptr TItemFactory
  TItemFactoryClass* = object of TObjectClass
    item_ht*: PGHashTable
    reserved471: proc (){.cdecl.}
    reserved472: proc (){.cdecl.}
    reserved473: proc (){.cdecl.}
    reserved474: proc (){.cdecl.}

  PItemFactoryClass* = ptr TItemFactoryClass
  TItemFactoryEntry*{.final, pure.} = object
    path*: cstring
    accelerator*: cstring
    callback*: TItemFactoryCallback
    callback_action*: guint
    item_type*: cstring
    extra_data*: gconstpointer

  PItemFactoryEntry* = ptr TItemFactoryEntry
  TItemFactoryItem*{.final, pure.} = object
    path*: cstring
    widgets*: PGSList

  PItemFactoryItem* = ptr TItemFactoryItem
