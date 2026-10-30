# Generated from gtkprinter.h; included by headers/gtk2.nim.
when defined(posix) and not defined(macosx):
  proc print_capabilities_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_capabilities_get_type".}
  proc printer_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_get_type".}
  proc printer_new*(`name`: cstring; `backend`: ptr PrintBackend; `virtual`: gboolean): ptr Printer {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_new".}
  proc printer_get_backend*(`printer`: ptr Printer): ptr PrintBackend {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_get_backend".}
  proc printer_get_name*(`printer`: ptr Printer): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_get_name".}
  proc printer_get_state_message*(`printer`: ptr Printer): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_get_state_message".}
  proc printer_get_description*(`printer`: ptr Printer): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_get_description".}
  proc printer_get_location*(`printer`: ptr Printer): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_get_location".}
  proc printer_get_icon_name*(`printer`: ptr Printer): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_get_icon_name".}
  proc printer_get_job_count*(`printer`: ptr Printer): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_get_job_count".}
  proc printer_is_active*(`printer`: ptr Printer): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_is_active".}
  proc printer_is_paused*(`printer`: ptr Printer): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_is_paused".}
  proc printer_is_accepting_jobs*(`printer`: ptr Printer): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_is_accepting_jobs".}
  proc printer_is_virtual*(`printer`: ptr Printer): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_is_virtual".}
  proc printer_is_default*(`printer`: ptr Printer): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_is_default".}
  proc printer_accepts_pdf*(`printer`: ptr Printer): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_accepts_pdf".}
  proc printer_accepts_ps*(`printer`: ptr Printer): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_accepts_ps".}
  proc printer_list_papers*(`printer`: ptr Printer): ptr TGList {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_list_papers".}
  proc printer_get_default_page_size*(`printer`: ptr Printer): ptr PageSetup {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_get_default_page_size".}
  proc printer_compare*(`a`: ptr Printer; `b`: ptr Printer): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_compare".}
  proc printer_has_details*(`printer`: ptr Printer): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_has_details".}
  proc printer_request_details*(`printer`: ptr Printer) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_request_details".}
  proc printer_get_capabilities*(`printer`: ptr Printer): PrintCapabilities {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_get_capabilities".}
  proc printer_get_hard_margins*(`printer`: ptr Printer; `top`: ptr gdouble; `bottom`: ptr gdouble; `left`: ptr gdouble; `right`: ptr gdouble): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_printer_get_hard_margins".}
  proc enumerate_printers*(`func`: PrinterFunc; `data`: pointer; `destroy`: TGDestroyNotify; `wait`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_enumerate_printers".}
