# Included by headers/gdk2pixbuf.nim; do not import directly.
type
  TPixbufLoader*{.final, pure.} = object
    parent_instance*: TGObject
    priv*: gpointer

  PPixbufLoader* = ptr TPixbufLoader
  TPixbufLoaderClass*{.final, pure.} = object
    parent_class*: TGObjectClass
    area_prepared*: proc (loader: PPixbufLoader){.cdecl.}
    area_updated*: proc (loader: PPixbufLoader, x: int32, y: int32,
                         width: int32, height: int32){.cdecl.}
    closed*: proc (loader: PPixbufLoader){.cdecl.}


  PPixbufLoaderClass* = ptr TPixbufLoaderClass
