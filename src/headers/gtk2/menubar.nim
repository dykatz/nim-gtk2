# Included by headers/gtk2.nim; do not import directly.
proc TYPE_MENU_BAR*(): GType
proc MENU_BAR*(obj: pointer): PMenuBar
proc MENU_BAR_CLASS*(klass: pointer): PMenuBarClass
proc IS_MENU_BAR*(obj: pointer): bool
proc IS_MENU_BAR_CLASS*(klass: pointer): bool
proc MENU_BAR_GET_CLASS*(obj: pointer): PMenuBarClass
proc menu_bar_get_type*(): TType{.cdecl, dynlib: lib,
                                  importc: "gtk_menu_bar_get_type".}
proc menu_bar_new*(): PMenuBar{.cdecl, dynlib: lib, importc: "gtk_menu_bar_new".}
proc cycle_focus*(menubar: PMenuBar, dir: TDirectionType){.cdecl,
    dynlib: lib, importc: "_gtk_menu_bar_cycle_focus".}
