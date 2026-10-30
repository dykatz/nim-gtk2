# Included by headers/gtk2.nim; do not import directly.
type
  TContainerClass* = object of TWidgetClass
    add*: proc (container: PContainer, widget: PWidget){.cdecl.}
    remove*: proc (container: PContainer, widget: PWidget){.cdecl.}
    check_resize*: proc (container: PContainer){.cdecl.}
    forall*: proc (container: PContainer, include_internals: gboolean,
                   callback: TCallback, callback_data: gpointer){.cdecl.}
    set_focus_child*: proc (container: PContainer, widget: PWidget){.cdecl.}
    child_type*: proc (container: PContainer): TType{.cdecl.}
    composite_name*: proc (container: PContainer, child: PWidget): cstring{.
        cdecl.}
    set_child_property*: proc (container: PContainer, child: PWidget,
                               property_id: guint, value: PGValue,
                               pspec: PGParamSpec){.cdecl.}
    get_child_property*: proc (container: PContainer, child: PWidget,
                               property_id: guint, value: PGValue,
                               pspec: PGParamSpec){.cdecl.}
    reserved20: proc (){.cdecl.}
    reserved21: proc (){.cdecl.}
    reserved23: proc (){.cdecl.}
    reserved24: proc (){.cdecl.}

  PContainerClass* = ptr TContainerClass
