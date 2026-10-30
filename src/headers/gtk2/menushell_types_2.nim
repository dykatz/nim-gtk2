# Included by headers/gtk2.nim; do not import directly.
type
  TMenuShellClass* = object of TContainerClass
    MenuShellClass_flag0*: guint16
    deactivate*: proc (menu_shell: PMenuShell){.cdecl.}
    selection_done*: proc (menu_shell: PMenuShell){.cdecl.}
    move_current*: proc (menu_shell: PMenuShell, direction: TMenuDirectionType){.
        cdecl.}
    activate_current*: proc (menu_shell: PMenuShell, force_hide: gboolean){.
        cdecl.}
    cancel*: proc (menu_shell: PMenuShell){.cdecl.}
    select_item*: proc (menu_shell: PMenuShell, menu_item: PWidget){.cdecl.}
    insert*: proc (menu_shell: PMenuShell, child: PWidget, position: gint){.
        cdecl.}
    reserved271: proc (){.cdecl.}
    reserved272: proc (){.cdecl.}
    reserved273: proc (){.cdecl.}
    reserved274: proc (){.cdecl.}

  PMenuShellClass* = ptr TMenuShellClass
