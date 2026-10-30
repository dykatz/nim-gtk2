# Included by headers/gtk2.nim; do not import directly.
proc add_with_properties*(container: PContainer, widget: PWidget,
                                    first_prop_name: cstring){.varargs,
    importc: "gtk_container_add_with_properties", cdecl, dynlib: lib.}
proc child_set*(container: PContainer, child: PWidget,
                          first_prop_name: cstring){.varargs, cdecl,
    importc: "gtk_container_child_set", dynlib: lib.}
proc child_get*(container: PContainer, child: PWidget,
                          first_prop_name: cstring){.varargs, cdecl,
    importc: "gtk_container_child_get", dynlib: lib.}
proc child_set_valist*(container: PContainer, child: PWidget,
                                 first_property_name: cstring){.varargs,
    importc: "gtk_container_child_set_valist", cdecl, dynlib: lib.}
proc child_get_valist*(container: PContainer, child: PWidget,
                                 first_property_name: cstring){.varargs,
    importc: "gtk_container_child_get_valist", cdecl, dynlib: lib.}
