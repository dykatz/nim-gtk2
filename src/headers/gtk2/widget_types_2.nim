# Included by headers/gtk2.nim; do not import directly.
type
  TWidgetClass* = object of TObjectClass
    activate_signal*: guint
    set_scroll_adjustments_signal*: guint
    dispatch_child_properties_changed*: proc (widget: PWidget, n_pspecs: guint,
        pspecs: PPGParamSpec){.cdecl.}
    show*: proc (widget: PWidget){.cdecl.}
    show_all*: proc (widget: PWidget){.cdecl.}
    hide*: proc (widget: PWidget){.cdecl.}
    hide_all*: proc (widget: PWidget){.cdecl.}
    map*: proc (widget: PWidget){.cdecl.}
    unmap*: proc (widget: PWidget){.cdecl.}
    realize*: proc (widget: PWidget){.cdecl.}
    unrealize*: proc (widget: PWidget){.cdecl.}
    size_request*: proc (widget: PWidget, requisition: PRequisition){.cdecl.}
    size_allocate*: proc (widget: PWidget, allocation: PAllocation){.cdecl.}
    state_changed*: proc (widget: PWidget, previous_state: TStateType){.cdecl.}
    parent_set*: proc (widget: PWidget, previous_parent: PWidget){.cdecl.}
    hierarchy_changed*: proc (widget: PWidget, previous_toplevel: PWidget){.
        cdecl.}
    style_set*: proc (widget: PWidget, previous_style: PStyle){.cdecl.}
    direction_changed*: proc (widget: PWidget,
                              previous_direction: TTextDirection){.cdecl.}
    grab_notify*: proc (widget: PWidget, was_grabbed: gboolean){.cdecl.}
    child_notify*: proc (widget: PWidget, pspec: PGParamSpec){.cdecl.}
    mnemonic_activate*: proc (widget: PWidget, group_cycling: gboolean): gboolean{.
        cdecl.}
    grab_focus*: proc (widget: PWidget){.cdecl.}
    focus*: proc (widget: PWidget, direction: TDirectionType): gboolean{.cdecl.}
    event*: proc (widget: PWidget, event: gdk2.PEvent): gboolean{.cdecl.}
    button_press_event*: proc (widget: PWidget, event: PEventButton): gboolean{.
        cdecl.}
    button_release_event*: proc (widget: PWidget, event: PEventButton): gboolean{.
        cdecl.}
    scroll_event*: proc (widget: PWidget, event: PEventScroll): gboolean{.
        cdecl.}
    motion_notify_event*: proc (widget: PWidget, event: PEventMotion): gboolean{.
        cdecl.}
    delete_event*: proc (widget: PWidget, event: PEventAny): gboolean{.cdecl.}
    destroy_event*: proc (widget: PWidget, event: PEventAny): gboolean{.cdecl.}
    expose_event*: proc (widget: PWidget, event: PEventExpose): gboolean{.
        cdecl.}
    key_press_event*: proc (widget: PWidget, event: PEventKey): gboolean{.
        cdecl.}
    key_release_event*: proc (widget: PWidget, event: PEventKey): gboolean{.
        cdecl.}
    enter_notify_event*: proc (widget: PWidget, event: PEventCrossing): gboolean{.
        cdecl.}
    leave_notify_event*: proc (widget: PWidget, event: PEventCrossing): gboolean{.
        cdecl.}
    configure_event*: proc (widget: PWidget, event: PEventConfigure): gboolean{.
        cdecl.}
    focus_in_event*: proc (widget: PWidget, event: PEventFocus): gboolean{.
        cdecl.}
    focus_out_event*: proc (widget: PWidget, event: PEventFocus): gboolean{.
        cdecl.}
    map_event*: proc (widget: PWidget, event: PEventAny): gboolean{.cdecl.}
    unmap_event*: proc (widget: PWidget, event: PEventAny): gboolean{.cdecl.}
    property_notify_event*: proc (widget: PWidget, event: PEventProperty): gboolean{.
        cdecl.}
    selection_clear_event*: proc (widget: PWidget, event: PEventSelection): gboolean{.
        cdecl.}
    selection_request_event*: proc (widget: PWidget, event: PEventSelection): gboolean{.
        cdecl.}
    selection_notify_event*: proc (widget: PWidget, event: PEventSelection): gboolean{.
        cdecl.}
    proximity_in_event*: proc (widget: PWidget, event: PEventProximity): gboolean{.
        cdecl.}
    proximity_out_event*: proc (widget: PWidget, event: PEventProximity): gboolean{.
        cdecl.}
    visibility_notify_event*: proc (widget: PWidget, event: PEventVisibility): gboolean{.
        cdecl.}
    client_event*: proc (widget: PWidget, event: PEventClient): gboolean{.
        cdecl.}
    no_expose_event*: proc (widget: PWidget, event: PEventAny): gboolean{.
        cdecl.}
    window_state_event*: proc (widget: PWidget, event: PEventWindowState): gboolean{.
        cdecl.}
    selection_get*: proc (widget: PWidget, selection_data: PSelectionData,
                          info: guint, time: guint){.cdecl.}
    selection_received*: proc (widget: PWidget, selection_data: PSelectionData,
                               time: guint){.cdecl.}
    drag_begin*: proc (widget: PWidget, context: PDragContext){.cdecl.}
    drag_end*: proc (widget: PWidget, context: PDragContext){.cdecl.}
    drag_data_get*: proc (widget: PWidget, context: PDragContext,
                          selection_data: PSelectionData, info: guint,
                          time: guint){.cdecl.}
    drag_data_delete*: proc (widget: PWidget, context: PDragContext){.cdecl.}
    drag_leave*: proc (widget: PWidget, context: PDragContext, time: guint){.
        cdecl.}
    drag_motion*: proc (widget: PWidget, context: PDragContext, x: gint,
                        y: gint, time: guint): gboolean{.cdecl.}
    drag_drop*: proc (widget: PWidget, context: PDragContext, x: gint,
                      y: gint, time: guint): gboolean{.cdecl.}
    drag_data_received*: proc (widget: PWidget, context: PDragContext,
                               x: gint, y: gint, selection_data: PSelectionData,
                               info: guint, time: guint){.cdecl.}
    popup_menu*: proc (widget: PWidget): gboolean{.cdecl.}
    show_help*: proc (widget: PWidget, help_type: TWidgetHelpType): gboolean{.
        cdecl.}
    get_accessible*: proc (widget: PWidget): atk.PObject{.cdecl.}
    reserved1: proc (){.cdecl.}
    reserved2: proc (){.cdecl.}
    reserved3: proc (){.cdecl.}
    reserved4: proc (){.cdecl.}
    reserved5*: proc (){.cdecl.}
    reserved6*: proc (){.cdecl.}
    reserved7*: proc (){.cdecl.}
    reserved8*: proc (){.cdecl.}

  PWidgetClass* = ptr TWidgetClass
