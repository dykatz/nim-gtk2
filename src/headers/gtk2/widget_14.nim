# Included by headers/gtk2.nim; do not import directly.
proc widget_segment_add*(widget_segment: PTextLineSegment, child: PWidget){.
    cdecl, dynlib: lib, importc: "_gtk_widget_segment_add".}
proc widget_segment_remove*(widget_segment: PTextLineSegment, child: PWidget){.
    cdecl, dynlib: lib, importc: "_gtk_widget_segment_remove".}
proc widget_segment_ref*(widget_segment: PTextLineSegment){.cdecl, dynlib: lib,
    importc: "_gtk_widget_segment_ref".}
proc widget_segment_unref*(widget_segment: PTextLineSegment){.cdecl,
    dynlib: lib, importc: "_gtk_widget_segment_unref".}
proc anchored_child_get_layout*(child: PWidget): PTextLayout{.cdecl,
    dynlib: lib, importc: "_gtk_anchored_child_get_layout".}
