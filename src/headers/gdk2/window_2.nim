# Included by headers/gdk2.nim; do not import directly.
proc WINDOW_CLASS*(klass: pointer): PWindowObjectClass
proc IS_WINDOW*(anObject: pointer): bool
proc IS_WINDOW_CLASS*(klass: pointer): bool
proc WINDOW_GET_CLASS*(obj: pointer): PWindowObjectClass
proc WINDOW_OBJECT*(anObject: pointer): PWindowObject
const
  bm_TWindowObject_guffaw_gravity* = 0x0001'u16
const
  bp_TWindowObject_guffaw_gravity* = 0'u16
const
  bm_TWindowObject_input_only* = 0x0002'u16
const
  bp_TWindowObject_input_only* = 1'u16
const
  bm_TWindowObject_modal_hint* = 0x0004'u16
const
  bp_TWindowObject_modal_hint* = 2'u16
const
  bm_TWindowObject_destroyed* = 0x0018'u16
const
  bp_TWindowObject_destroyed* = 3'u16

proc WindowObject_guffaw_gravity*(a: PWindowObject): guint
proc WindowObject_set_guffaw_gravity*(a: PWindowObject,
                                      `guffaw_gravity`: guint)
proc WindowObject_input_only*(a: PWindowObject): guint
proc WindowObject_set_input_only*(a: PWindowObject, `input_only`: guint)
proc WindowObject_modal_hint*(a: PWindowObject): guint
proc WindowObject_set_modal_hint*(a: PWindowObject, `modal_hint`: guint)
proc WindowObject_destroyed*(a: PWindowObject): guint
proc WindowObject_set_destroyed*(a: PWindowObject, `destroyed`: guint)
proc window_object_get_type*(): GType{.cdecl, dynlib: lib,
                                       importc: "gdk_window_object_get_type".}
proc new*(parent: PWindow, attributes: PWindowAttr, attributes_mask: gint): PWindow{.
    cdecl, dynlib: lib, importc: "gdk_window_new".}
proc destroy*(window: PWindow){.cdecl, dynlib: lib,
                                       importc: "gdk_window_destroy".}
