# Included by headers/gtk2.nim; do not import directly.
proc TYPE_NOTEBOOK*(): GType
proc NOTEBOOK*(obj: pointer): PNotebook
proc NOTEBOOK_CLASS*(klass: pointer): PNotebookClass
proc IS_NOTEBOOK*(obj: pointer): bool
proc IS_NOTEBOOK_CLASS*(klass: pointer): bool
proc NOTEBOOK_GET_CLASS*(obj: pointer): PNotebookClass
proc show_tabs*(a: PNotebook): guint
proc set_show_tabs*(a: PNotebook, `show_tabs`: guint)
proc homogeneous*(a: PNotebook): guint
proc set_homogeneous*(a: PNotebook, `homogeneous`: guint)
proc show_border*(a: PNotebook): guint
proc set_show_border*(a: PNotebook, `show_border`: guint)
proc tab_pos*(a: PNotebook): guint
proc scrollable*(a: PNotebook): guint
proc set_scrollable*(a: PNotebook, `scrollable`: guint)
proc in_child*(a: PNotebook): guint

proc click_child*(a: PNotebook): guint
proc set_click_child*(a: PNotebook, `click_child`: guint)
proc button*(a: PNotebook): guint
proc set_button*(a: PNotebook, `button`: guint)
proc need_timer*(a: PNotebook): guint
proc set_need_timer*(a: PNotebook, `need_timer`: guint)
proc child_has_focus*(a: PNotebook): guint
proc set_child_has_focus*(a: PNotebook, `child_has_focus`: guint)
proc have_visible_child*(a: PNotebook): guint
proc set_have_visible_child*(a: PNotebook, `have_visible_child`: guint)
proc focus_out*(a: PNotebook): guint
proc set_focus_out*(a: PNotebook, `focus_out`: guint)
proc notebook_get_type*(): TType{.cdecl, dynlib: lib,
                                  importc: "gtk_notebook_get_type".}
proc notebook_new*(): PNotebook{.cdecl, dynlib: lib, importc: "gtk_notebook_new".}
proc append_page*(notebook: PNotebook, child: PWidget,
                           tab_label: PWidget): gint{.cdecl, dynlib: lib,
    importc: "gtk_notebook_append_page".}
proc append_page_menu*(notebook: PNotebook, child: PWidget,
                                tab_label: PWidget, menu_label: PWidget): gint{.
    cdecl, dynlib: lib, importc: "gtk_notebook_append_page_menu".}
proc prepend_page*(notebook: PNotebook, child: PWidget,
                            tab_label: PWidget): gint{.cdecl, dynlib: lib,
    importc: "gtk_notebook_prepend_page".}
proc prepend_page_menu*(notebook: PNotebook, child: PWidget,
                                 tab_label: PWidget, menu_label: PWidget): gint{.
    cdecl, dynlib: lib, importc: "gtk_notebook_prepend_page_menu".}
proc insert_page*(notebook: PNotebook, child: PWidget,
                           tab_label: PWidget, position: gint): gint{.cdecl,
    dynlib: lib, importc: "gtk_notebook_insert_page".}
proc insert_page_menu*(notebook: PNotebook, child: PWidget,
                                tab_label: PWidget, menu_label: PWidget,
                                position: gint): gint{.cdecl, dynlib: lib,
    importc: "gtk_notebook_insert_page_menu".}
proc remove_page*(notebook: PNotebook, page_num: gint){.cdecl,
    dynlib: lib, importc: "gtk_notebook_remove_page".}
proc get_current_page*(notebook: PNotebook): gint{.cdecl, dynlib: lib,
    importc: "gtk_notebook_get_current_page".}
proc get_n_pages*(notebook: PNotebook): gint{.cdecl, dynlib: lib,
    importc: "gtk_notebook_get_n_pages".}
proc get_nth_page*(notebook: PNotebook, page_num: gint): PWidget{.
    cdecl, dynlib: lib, importc: "gtk_notebook_get_nth_page".}
proc page_num*(notebook: PNotebook, child: PWidget): gint{.cdecl,
    dynlib: lib, importc: "gtk_notebook_page_num".}
proc set_current_page*(notebook: PNotebook, page_num: gint){.cdecl,
    dynlib: lib, importc: "gtk_notebook_set_current_page".}
proc next_page*(notebook: PNotebook){.cdecl, dynlib: lib,
    importc: "gtk_notebook_next_page".}
proc prev_page*(notebook: PNotebook){.cdecl, dynlib: lib,
    importc: "gtk_notebook_prev_page".}
proc set_show_border*(notebook: PNotebook, show_border: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_notebook_set_show_border".}
proc get_show_border*(notebook: PNotebook): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_notebook_get_show_border".}
proc set_show_tabs*(notebook: PNotebook, show_tabs: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_notebook_set_show_tabs".}
proc get_show_tabs*(notebook: PNotebook): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_notebook_get_show_tabs".}
proc set_tab_pos*(notebook: PNotebook, pos: TPositionType){.cdecl,
    dynlib: lib, importc: "gtk_notebook_set_tab_pos".}
proc get_tab_pos*(notebook: PNotebook): TPositionType{.cdecl,
    dynlib: lib, importc: "gtk_notebook_get_tab_pos".}
proc set_scrollable*(notebook: PNotebook, scrollable: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_notebook_set_scrollable".}
proc get_scrollable*(notebook: PNotebook): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_notebook_get_scrollable".}
proc set_tab_reorderable*(notebook: PNotebook, child: PWidget, b: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_notebook_set_tab_reorderable".}
proc get_tab_reorderable*(notebook: PNotebook, child: PWidget): gboolean {.cdecl,
    dynlib: lib, importc: "gtk_notebook_get_tab_reorderable".}
proc popup_enable*(notebook: PNotebook){.cdecl, dynlib: lib,
    importc: "gtk_notebook_popup_enable".}
proc popup_disable*(notebook: PNotebook){.cdecl, dynlib: lib,
    importc: "gtk_notebook_popup_disable".}
proc get_tab_label*(notebook: PNotebook, child: PWidget): PWidget{.
    cdecl, dynlib: lib, importc: "gtk_notebook_get_tab_label".}
proc set_tab_label*(notebook: PNotebook, child: PWidget,
                             tab_label: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_notebook_set_tab_label".}
proc set_tab_label_text*(notebook: PNotebook, child: PWidget,
                                  tab_text: cstring){.cdecl, dynlib: lib,
    importc: "gtk_notebook_set_tab_label_text".}
proc get_tab_label_text*(notebook: PNotebook, child: PWidget): cstring{.
    cdecl, dynlib: lib, importc: "gtk_notebook_get_tab_label_text".}
proc get_menu_label*(notebook: PNotebook, child: PWidget): PWidget{.
    cdecl, dynlib: lib, importc: "gtk_notebook_get_menu_label".}
proc set_menu_label*(notebook: PNotebook, child: PWidget,
                              menu_label: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_notebook_set_menu_label".}
proc set_menu_label_text*(notebook: PNotebook, child: PWidget,
                                   menu_text: cstring){.cdecl, dynlib: lib,
    importc: "gtk_notebook_set_menu_label_text".}
proc get_menu_label_text*(notebook: PNotebook, child: PWidget): cstring{.
    cdecl, dynlib: lib, importc: "gtk_notebook_get_menu_label_text".}
proc query_tab_label_packing*(notebook: PNotebook, child: PWidget,
                                       expand: Pgboolean, fill: Pgboolean,
                                       pack_type: PPackType){.cdecl,
    dynlib: lib, importc: "gtk_notebook_query_tab_label_packing".}
proc set_tab_label_packing*(notebook: PNotebook, child: PWidget,
                                     expand: gboolean, fill: gboolean,
                                     pack_type: TPackType){.cdecl, dynlib: lib,
    importc: "gtk_notebook_set_tab_label_packing".}
proc reorder_child*(notebook: PNotebook, child: PWidget, position: gint){.
    cdecl, dynlib: lib, importc: "gtk_notebook_reorder_child".}
const
  bm_TGtkPixmap_build_insensitive* = 0x0001'u16
const
  bp_TGtkPixmap_build_insensitive* = 0'u16

const
  bm_TGtkPlug_same_app* = 0x0001'u16
const
  bp_TGtkPlug_same_app* = 0'u16

