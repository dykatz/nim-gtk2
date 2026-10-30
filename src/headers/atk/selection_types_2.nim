# Included by headers/atk.nim; do not import directly.
type
  TSelectionIface* = object of TGTypeInterface
    add_selection*: proc (selection: PSelection, i: gint): gboolean{.cdecl.}
    clear_selection*: proc (selection: PSelection): gboolean{.cdecl.}
    ref_selection*: proc (selection: PSelection, i: gint): PObject{.cdecl.}
    get_selection_count*: proc (selection: PSelection): gint{.cdecl.}
    is_child_selected*: proc (selection: PSelection, i: gint): gboolean{.cdecl.}
    remove_selection*: proc (selection: PSelection, i: gint): gboolean{.cdecl.}
    select_all_selection*: proc (selection: PSelection): gboolean{.cdecl.}
    selection_changed*: proc (selection: PSelection){.cdecl.}
    pad1*: TFunction
    pad2*: TFunction

  PSelectionIface* = ptr TSelectionIface
