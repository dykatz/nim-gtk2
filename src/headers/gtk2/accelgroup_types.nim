# Included by headers/gtk2.nim; do not import directly.
type
  TAccelFlags* = int32
  PAccelFlags* = ptr TAccelFlags
  TAccelKey*{.final, pure.} = object
    accel_key*: guint
    accel_mods*: gdk2.TModifierType
    flag0*: guint16

  PAccelKey* = ptr TAccelKey
  TAccelGroupEntry*{.final, pure.} = object
    key*: TAccelKey
    closure*: PGClosure
    accel_path_quark*: TGQuark

  PAccelGroupEntry* = ptr TAccelGroupEntry
  TAccelGroup* = object of TGObject
    lock_count*: guint
    modifier_mask*: gdk2.TModifierType
    acceleratables*: PGSList
    n_accels*: guint
    priv_accels*: PAccelGroupEntry

  PAccelGroup* = ptr TAccelGroup
  TAccelGroupClass* = object of TGObjectClass
    accel_changed*: proc (accel_group: PAccelGroup, keyval: guint,
                          modifier: gdk2.TModifierType, accel_closure: PGClosure){.
        cdecl.}
    reserved1: proc (){.cdecl.}
    reserved2: proc (){.cdecl.}
    reserved3: proc (){.cdecl.}
    reserved4: proc (){.cdecl.}

  PAccelGroupClass* = ptr TAccelGroupClass
