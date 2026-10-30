# Included by headers/gdk2.nim; do not import directly.
type
  TKeymap* = object of TGObject
    display*: PDisplay

  PKeymap* = ptr TKeymap
  TKeymapClass* = object of TGObjectClass
    direction_changed*: proc (keymap: PKeymap){.cdecl.}

  PKeymapClass* = ptr TKeymapClass
