# Included by headers/gdk2.nim; do not import directly.
type
  TGC* = object of TGObject
    clip_x_origin*: gint
    clip_y_origin*: gint
    ts_x_origin*: gint
    ts_y_origin*: gint
    colormap*: PColormap

  PGC* = ptr TGC
  TGCClass* = object of TGObjectClass
    get_values*: proc (gc: PGC, values: PGCValues){.cdecl.}
    set_values*: proc (gc: PGC, values: PGCValues, mask: TGCValuesMask){.cdecl.}
    set_dashes*: proc (gc: PGC, dash_offset: gint, dash_list: openarray[gint8]){.
        cdecl.}
    `reserved1`*: proc (){.cdecl.}
    `reserved2`*: proc (){.cdecl.}
    `reserved3`*: proc (){.cdecl.}
    `reserved4`*: proc (){.cdecl.}

  PGCClass* = ptr TGCClass
