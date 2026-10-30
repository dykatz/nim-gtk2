# Included by headers/gtk2.nim; do not import directly.
type
  TAccelGroupActivate* = proc (accel_group: PAccelGroup,
                               acceleratable: PGObject, keyval: guint,
                               modifier: gdk2.TModifierType): gboolean{.cdecl.}
  Taccel_group_find_func* = proc (key: PAccelKey, closure: PGClosure,
                                  data: gpointer): gboolean{.cdecl.}
  TClipboardTextReceivedFunc* = proc (clipboard: PClipboard, text: cstring,
                                      data: gpointer){.cdecl.}
  TClipboardClearFunc* = proc (clipboard: PClipboard,
                               user_data_or_owner: gpointer){.cdecl.}
