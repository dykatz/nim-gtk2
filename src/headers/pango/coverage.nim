# Included by headers/pango.nim; do not import directly.
proc coverage_new*(): PCoverage{.cdecl, dynlib: lib,
                                 importc: "pango_coverage_new".}
proc reference*(coverage: PCoverage): PCoverage{.cdecl, dynlib: lib,
    importc: "pango_coverage_ref".}
proc unref*(coverage: PCoverage){.cdecl, dynlib: lib,
    importc: "pango_coverage_unref".}
proc copy*(coverage: PCoverage): PCoverage{.cdecl, dynlib: lib,
    importc: "pango_coverage_copy".}
proc get*(coverage: PCoverage, index: int32): TCoverageLevel{.cdecl,
    dynlib: lib, importc: "pango_coverage_get".}
proc set*(coverage: PCoverage, index: int32, level: TCoverageLevel){.
    cdecl, dynlib: lib, importc: "pango_coverage_set".}
proc max*(coverage: PCoverage, other: PCoverage){.cdecl, dynlib: lib,
    importc: "pango_coverage_max".}
proc to_bytes*(coverage: PCoverage, bytes: PPguchar, n_bytes: var int32){.
    cdecl, dynlib: lib, importc: "pango_coverage_to_bytes".}
proc coverage_from_bytes*(bytes: Pguchar, n_bytes: int32): PCoverage{.cdecl,
    dynlib: lib, importc: "pango_coverage_from_bytes".}
proc TYPE_FONTSET*(): GType
