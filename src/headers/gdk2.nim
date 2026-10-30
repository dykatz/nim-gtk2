{.push gcsafe.}
import
  glib2, gdk2pixbuf, pango, cairo

when defined(win32):
  const
    lib = "libgdk-win32-2.0-0.dll"
elif defined(macosx):
  #    linklib gtk-x11-2.0
  #    linklib gdk-x11-2.0
  #    linklib pango-1.0.0
  #    linklib glib-2.0.0
  #    linklib gobject-2.0.0
  #    linklib gdk_pixbuf-2.0.0
  #    linklib atk-1.0.0
  const
    lib = "libgdk-(quartz|x11)-2.0(|.0).dylib"
else:
  const
    lib = "libgdk-x11-2.0.so(|.0)"
include "gdk2/core"
include "gdk2/input"
include "gdk2/input_types"
include "gdk2/visual_types"
include "gdk2/color_types"
include "gdk2/drawable_types"
include "gdk2/types_types"
include "gdk2/font_types"
include "gdk2/gc_types"
include "gdk2/image_types"
include "gdk2/rgb_types"
include "gdk2/screen_types"
include "gdk2/shared_types"
include "gdk2/visual_types_2"
include "gdk2/color_types_2"
include "gdk2/gc_types_2"
include "gdk2/cursor_types"
include "gdk2/dnd_types"
include "gdk2/types_types_2"
include "gdk2/events_types"
include "gdk2/image_types_2"
include "gdk2/drawable_types_2"
include "gdk2/input_types_2"
include "gdk2/events_types_2"
include "gdk2/shared_types_2"
include "gdk2/keys_types"
include "gdk2/pixmap_types"
include "gdk2/property_types"
include "gdk2/region_types"
include "gdk2/display_types"
include "gdk2/keys_types_2"
include "gdk2/screen_types_2"
include "gdk2/window_types"
include "gdk2/core_2"
include "gdk2/color"
include "gdk2/cursor"
include "gdk2/screen"
include "gdk2/cursor_2"
include "gdk2/dnd"
include "gdk2/cursor_3"
include "gdk2/dnd_2"
include "gdk2/types"
include "gdk2/drawable"
include "gdk2/font"
include "gdk2/events"
include "gdk2/font_2"
include "gdk2/events_2"
include "gdk2/font_3"
include "gdk2/events_3"
include "gdk2/font_4"
include "gdk2/events_4"
include "gdk2/font_5"
include "gdk2/events_5"
include "gdk2/font_6"
include "gdk2/core_3"
include "gdk2/events_6"
include "gdk2/font_7"
include "gdk2/gc"
include "gdk2/image"
include "gdk2/input_2"
include "gdk2/image_2"
include "gdk2/input_3"
include "gdk2/keys"
include "gdk2/keysyms"
include "gdk2/keys_2"
include "gdk2/keysyms_2"
include "gdk2/keys_3"
include "gdk2/keysyms_3"
include "gdk2/keys_4"
include "gdk2/keysyms_4"
include "gdk2/keys_5"
include "gdk2/keysyms_5"
include "gdk2/keys_6"
include "gdk2/keysyms_6"
include "gdk2/keys_7"
include "gdk2/keysyms_7"
include "gdk2/keys_8"
include "gdk2/keysyms_8"
include "gdk2/keys_9"
include "gdk2/keysyms_9"
include "gdk2/keys_10"
include "gdk2/keysyms_10"
include "gdk2/keys_11"
include "gdk2/keysyms_11"
include "gdk2/keys_12"
include "gdk2/keysyms_12"
include "gdk2/keys_13"
include "gdk2/keysyms_13"
include "gdk2/keys_14"
include "gdk2/keysyms_14"
include "gdk2/keys_15"
include "gdk2/keysyms_15"
include "gdk2/keys_16"
include "gdk2/keysyms_16"
include "gdk2/keys_17"
include "gdk2/keysyms_17"
include "gdk2/keys_18"
include "gdk2/keysyms_18"
include "gdk2/keys_19"
include "gdk2/keysyms_19"
include "gdk2/keys_20"
include "gdk2/keysyms_20"
include "gdk2/cairo"
include "gdk2/pango"
include "gdk2/pixbuf"
include "gdk2/pixmap"
include "gdk2/types_2"
include "gdk2/pixmap_2"
include "gdk2/property"
include "gdk2/region"
include "gdk2/rgb"
include "gdk2/display"
include "gdk2/screen_2"
include "gdk2/selection"
include "gdk2/types_3"
include "gdk2/selection_2"
include "gdk2/types_4"
include "gdk2/selection_3"
include "gdk2/types_5"
include "gdk2/selection_4"
include "gdk2/visual"
include "gdk2/window"
include "gdk2/types_6"
include "gdk2/window_2"
include "gdk2/private"
include "gdk2/window_3"
include "gdk2/core_4"
when not declared(DISABLE_DEPRECATED):
  proc exit*(error_code: gint){.cdecl, dynlib: lib, importc: "gdk_exit".}
include "gdk2/core_5"
when not declared(DISABLE_DEPRECATED):
  proc set_use_xshm*(use_xshm: gboolean){.cdecl, dynlib: lib,
      importc: "gdk_set_use_xshm".}
  proc get_use_xshm*(): gboolean{.cdecl, dynlib: lib,
                                  importc: "gdk_get_use_xshm".}
include "gdk2/core_6"
when not declared(DISABLE_DEPRECATED):
  proc input_add_full*(source: gint, condition: TInputCondition,
                       `function`: TInputFunction, data: gpointer,
                       destroy: TDestroyNotify): gint{.cdecl, dynlib: lib,
      importc: "gdk_input_add_full".}
  proc input_add*(source: gint, condition: TInputCondition,
                  `function`: TInputFunction, data: gpointer): gint{.cdecl,
      dynlib: lib, importc: "gdk_input_add".}
  proc input_remove*(tag: gint){.cdecl, dynlib: lib, importc: "gdk_input_remove".}
include "gdk2/core_7"
when not declared(MULTIHEAD_SAFE):
  proc pointer_ungrab*(time: guint32){.cdecl, dynlib: lib,
                                       importc: "gdk_pointer_ungrab".}
  proc keyboard_ungrab*(time: guint32){.cdecl, dynlib: lib,
                                        importc: "gdk_keyboard_ungrab".}
  proc pointer_is_grabbed*(): gboolean{.cdecl, dynlib: lib,
                                        importc: "gdk_pointer_is_grabbed".}
  proc screen_width*(): gint{.cdecl, dynlib: lib, importc: "gdk_screen_width".}
  proc screen_height*(): gint{.cdecl, dynlib: lib, importc: "gdk_screen_height".}
  proc screen_width_mm*(): gint{.cdecl, dynlib: lib,
                                 importc: "gdk_screen_width_mm".}
  proc screen_height_mm*(): gint{.cdecl, dynlib: lib,
                                  importc: "gdk_screen_height_mm".}
  proc beep*(){.cdecl, dynlib: lib, importc: "gdk_beep".}
include "gdk2/core_8"
when not declared(MULTIHEAD_SAFE):
  proc set_double_click_time*(msec: guint){.cdecl, dynlib: lib,
      importc: "gdk_set_double_click_time".}
include "gdk2/core_9"
when not declared(MULTIHEAD_SAFE):
  proc event_send_client_message*(event: PEvent, xid: guint32): gboolean{.cdecl,
      dynlib: lib, importc: "gdk_event_send_client_message".}
  proc event_send_clientmessage_toall*(event: PEvent){.cdecl, dynlib: lib,
      importc: "gdk_event_send_clientmessage_toall".}
include "gdk2/core_10"
include "gdk2/color_2"
include "gdk2/cursor_4"
include "gdk2/dnd_3"
include "gdk2/types_7"
include "gdk2/drawable_2"
include "gdk2/font_8"
include "gdk2/gc_2"
include "gdk2/image_3"
include "gdk2/input_4"
include "gdk2/keys_21"
include "gdk2/pixmap_3"
include "gdk2/types_8"
include "gdk2/pixmap_4"
include "gdk2/drawable_3"
include "gdk2/color_3"
include "gdk2/display_2"
include "gdk2/screen_3"
include "gdk2/visual_2"
include "gdk2/window_4"
include "gdk2/types_9"
include "gdk2/window_5"
include "gdk2/types_10"
include "gdk2/drawable_4"
include "gdk2/types_11"
include "gdk2/drawable_5"
{.pop.}
