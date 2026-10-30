# Included by headers/atk.nim; do not import directly.
type
  TUtilClass* = object of TGObjectClass
    add_global_event_listener*: proc (listener: TGSignalEmissionHook,
                                      event_type: cstring): guint{.cdecl.}
    remove_global_event_listener*: proc (listener_id: guint){.cdecl.}
    add_key_event_listener*: proc (listener: TKeySnoopFunc, data: gpointer): guint{.
        cdecl.}
    remove_key_event_listener*: proc (listener_id: guint){.cdecl.}
    get_root*: proc (): PObject{.cdecl.}
    get_toolkit_name*: proc (): cstring{.cdecl.}
    get_toolkit_version*: proc (): cstring{.cdecl.}

  PUtilClass* = ptr TUtilClass
