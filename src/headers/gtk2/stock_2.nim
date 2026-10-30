# Included by headers/gtk2.nim; do not import directly.
const
  STOCK_APPLY* = "gtk-apply"
const
  STOCK_BOLD* = "gtk-bold"
const
  STOCK_CANCEL* = "gtk-cancel"
const
  STOCK_CDROM* = "gtk-cdrom"
const
  STOCK_CLEAR* = "gtk-clear"
const
  STOCK_CLOSE* = "gtk-close"
const
  STOCK_COLOR_PICKER* = "gtk-color-picker"
const
  STOCK_CONVERT* = "gtk-convert"
const
  STOCK_CONNECT* = "gtk-connect"
const
  STOCK_COPY* = "gtk-copy"
const
  STOCK_CUT* = "gtk-cut"
const
  STOCK_DELETE* = "gtk-delete"
const
  STOCK_EDIT* = "gtk-edit"
const
  STOCK_EXECUTE* = "gtk-execute"
const
  STOCK_FIND* = "gtk-find"
const
  STOCK_FIND_AND_REPLACE* = "gtk-find-and-replace"
const
  STOCK_FLOPPY* = "gtk-floppy"
const
  STOCK_GOTO_BOTTOM* = "gtk-goto-bottom"
const
  STOCK_GOTO_FIRST* = "gtk-goto-first"
const
  STOCK_GOTO_LAST* = "gtk-goto-last"
const
  STOCK_GOTO_TOP* = "gtk-goto-top"
const
  STOCK_GO_BACK* = "gtk-go-back"
const
  STOCK_GO_DOWN* = "gtk-go-down"
const
  STOCK_GO_FORWARD* = "gtk-go-forward"
const
  STOCK_GO_UP* = "gtk-go-up"
const
  STOCK_HELP* = "gtk-help"
const
  STOCK_HOME* = "gtk-home"
const
  STOCK_INDEX* = "gtk-index"
const
  STOCK_ITALIC* = "gtk-italic"
const
  STOCK_JUMP_TO* = "gtk-jump-to"
const
  STOCK_JUSTIFY_CENTER* = "gtk-justify-center"
const
  STOCK_JUSTIFY_FILL* = "gtk-justify-fill"
const
  STOCK_JUSTIFY_LEFT* = "gtk-justify-left"
const
  STOCK_JUSTIFY_RIGHT* = "gtk-justify-right"
const
  STOCK_MEDIA_FORWARD* = "gtk-media-forward"
const
  STOCK_MEDIA_NEXT* = "gtk-media-next"
const
  STOCK_MEDIA_PAUSE* = "gtk-media-pause"
const
  STOCK_MEDIA_PLAY* = "gtk-media-play"
const
  STOCK_MEDIA_PREVIOUS* = "gtk-media-previous"
const
  STOCK_MEDIA_RECORD* = "gtk-media-record"
const
  STOCK_MEDIA_REWIND* = "gtk-media-rewind"
const
  STOCK_MEDIA_STOP* = "gtk-media-stop"
const
  STOCK_MISSING_IMAGE* = "gtk-missing-image"
const
  STOCK_NEW* = "gtk-new"
const
  STOCK_NO* = "gtk-no"
const
  STOCK_OK* = "gtk-ok"
const
  STOCK_OPEN* = "gtk-open"
const
  STOCK_PASTE* = "gtk-paste"
const
  STOCK_PREFERENCES* = "gtk-preferences"
const
  STOCK_PRINT* = "gtk-print"
const
  STOCK_PRINT_PREVIEW* = "gtk-print-preview"
const
  STOCK_PROPERTIES* = "gtk-properties"
const
  STOCK_QUIT* = "gtk-quit"
const
  STOCK_REDO* = "gtk-redo"
const
  STOCK_REFRESH* = "gtk-refresh"
const
  STOCK_REMOVE* = "gtk-remove"
const
  STOCK_REVERT_TO_SAVED* = "gtk-revert-to-saved"
const
  STOCK_SAVE* = "gtk-save"
const
  STOCK_SAVE_AS* = "gtk-save-as"
const
  STOCK_SELECT_COLOR* = "gtk-select-color"
const
  STOCK_SELECT_FONT* = "gtk-select-font"
const
  STOCK_SORT_ASCENDING* = "gtk-sort-ascending"
const
  STOCK_SORT_DESCENDING* = "gtk-sort-descending"
const
  STOCK_SPELL_CHECK* = "gtk-spell-check"
const
  STOCK_STOP* = "gtk-stop"
const
  STOCK_STRIKETHROUGH* = "gtk-strikethrough"
const
  STOCK_UNDELETE* = "gtk-undelete"
const
  STOCK_UNDERLINE* = "gtk-underline"
const
  STOCK_UNDO* = "gtk-undo"
const
  STOCK_YES* = "gtk-yes"
const
  STOCK_ZOOM_100* = "gtk-zoom-100"
const
  STOCK_ZOOM_FIT* = "gtk-zoom-fit"
const
  STOCK_ZOOM_IN* = "gtk-zoom-in"
const
  STOCK_ZOOM_OUT* = "gtk-zoom-out"

proc add*(items: PStockItem, n_items: guint){.cdecl, dynlib: lib,
    importc: "gtk_stock_add".}
proc add_static*(items: PStockItem, n_items: guint){.cdecl, dynlib: lib,
    importc: "gtk_stock_add_static".}
proc stock_lookup*(stock_id: cstring, item: PStockItem): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_stock_lookup".}
proc stock_list_ids*(): PGSList{.cdecl, dynlib: lib,
                                 importc: "gtk_stock_list_ids".}
proc copy*(item: PStockItem): PStockItem{.cdecl, dynlib: lib,
    importc: "gtk_stock_item_copy".}
proc free*(item: PStockItem){.cdecl, dynlib: lib,
    importc: "gtk_stock_item_free".}
