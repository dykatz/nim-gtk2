# Included by headers/glib2.nim; do not import directly.
type
  TGBaseInitFunc* = proc (g_class: gpointer){.cdecl.}
  TGBaseFinalizeFunc* = proc (g_class: gpointer){.cdecl.}
  TGClassInitFunc* = proc (g_class: gpointer, class_data: gpointer){.cdecl.}
  TGClassFinalizeFunc* = proc (g_class: gpointer, class_data: gpointer){.cdecl.}
  TGInstanceInitFunc* = proc (instance: PGTypeInstance, g_class: gpointer){.
      cdecl.}
  TGInterfaceInitFunc* = proc (g_iface: gpointer, iface_data: gpointer){.cdecl.}
  TGInterfaceFinalizeFunc* = proc (g_iface: gpointer, iface_data: gpointer){.
      cdecl.}
  TGTypeClassCacheFunc* = proc (cache_data: gpointer, g_class: PGTypeClass): gboolean{.
      cdecl.}
