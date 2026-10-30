# Included by headers/gtk2.nim; do not import directly.
type
  TClipboardReceivedFunc* = proc (clipboard: PClipboard,
                                  selection_data: PSelectionData, data: gpointer){.
      cdecl.}
  TClipboardGetFunc* = proc (clipboard: PClipboard,
                             selection_data: PSelectionData, info: guint,
                             user_data_or_owner: gpointer){.cdecl.}
  ProgressClassLayout = object of TWidgetClass
    paint: proc (progress: ProgressLayoutPtr){.cdecl.}
    update: proc (progress: ProgressLayoutPtr){.cdecl.}
    act_mode_enter: proc (progress: ProgressLayoutPtr){.cdecl.}
    reserved561: proc (){.cdecl.}
    reserved562: proc (){.cdecl.}
    reserved563: proc (){.cdecl.}
    reserved564: proc (){.cdecl.}

