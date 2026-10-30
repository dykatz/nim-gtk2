# Included by headers/gtk2.nim; do not import directly.
proc size_group_get_child_requisition*(widget: PWidget,
                                       requisition: PRequisition){.cdecl,
    dynlib: lib, importc: "_gtk_size_group_get_child_requisition".}
proc size_group_compute_requisition*(widget: PWidget, requisition: PRequisition){.
    cdecl, dynlib: lib, importc: "_gtk_size_group_compute_requisition".}
proc size_group_queue_resize*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "_gtk_size_group_queue_resize".}
const
  bm_TGtkSocket_same_app* = 0x0001'u16
const
  bp_TGtkSocket_same_app* = 0'u16
const
  bm_TGtkSocket_focus_in* = 0x0002'u16
const
  bp_TGtkSocket_focus_in* = 1'u16
const
  bm_TGtkSocket_have_size* = 0x0004'u16
const
  bp_TGtkSocket_have_size* = 2'u16
const
  bm_TGtkSocket_need_map* = 0x0008'u16
const
  bp_TGtkSocket_need_map* = 3'u16
const
  bm_TGtkSocket_is_mapped* = 0x0010'u16
const
  bp_TGtkSocket_is_mapped* = 4'u16

