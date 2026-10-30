# Included by headers/atk.nim; do not import directly.
type
  TObjectClass* = object of TGObjectClass
    get_name*: proc (accessible: PObject): cstring{.cdecl.}
    get_description*: proc (accessible: PObject): cstring{.cdecl.}
    get_parent*: proc (accessible: PObject): PObject{.cdecl.}
    get_n_children*: proc (accessible: PObject): gint{.cdecl.}
    ref_child*: proc (accessible: PObject, i: gint): PObject{.cdecl.}
    get_index_in_parent*: proc (accessible: PObject): gint{.cdecl.}
    ref_relation_set*: proc (accessible: PObject): PRelationSet{.cdecl.}
    get_role*: proc (accessible: PObject): TRole{.cdecl.}
    get_layer*: proc (accessible: PObject): TLayer{.cdecl.}
    get_mdi_zorder*: proc (accessible: PObject): gint{.cdecl.}
    ref_state_set*: proc (accessible: PObject): PStateSet{.cdecl.}
    set_name*: proc (accessible: PObject, name: cstring){.cdecl.}
    set_description*: proc (accessible: PObject, description: cstring){.cdecl.}
    set_parent*: proc (accessible: PObject, parent: PObject){.cdecl.}
    set_role*: proc (accessible: PObject, role: TRole){.cdecl.}
    connect_property_change_handler*: proc (accessible: PObject,
        handler: TPropertyChangeHandler): guint{.cdecl.}
    remove_property_change_handler*: proc (accessible: PObject,
        handler_id: guint){.cdecl.}
    initialize*: proc (accessible: PObject, data: gpointer){.cdecl.}
    children_changed*: proc (accessible: PObject, change_index: guint,
                             changed_child: gpointer){.cdecl.}
    focus_event*: proc (accessible: PObject, focus_in: gboolean){.cdecl.}
    property_change*: proc (accessible: PObject, values: PPropertyValues){.cdecl.}
    state_change*: proc (accessible: PObject, name: cstring, state_set: gboolean){.
        cdecl.}
    visible_data_changed*: proc (accessible: PObject){.cdecl.}
    pad1*: TFunction
    pad2*: TFunction
    pad3*: TFunction
    pad4*: TFunction

  PObjectClass* = ptr TObjectClass
