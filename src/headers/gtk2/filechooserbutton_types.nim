# Included by headers/gtk2.nim; do not import directly.
type
  TFileChooserButtonPrivate*{.final, pure.} = object
    dialog*: PWidget
    button*: PWidget
    image*: PWidget
    label*: PWidget
    combo_box*: PWidget
    icon_cell*: PCellRenderer
    name_cell*: PCellRenderer
    model*: PTreeModel
    filter_model*: PTreeModel
    fs*: pointer

    selection_while_inactive*: pointer
    current_folder_while_inactive*: pointer

    combo_box_changed_id*: gulong
    fs_volumes_changed_id*: gulong
    fs_bookmarks_changed_id*: gulong

    dnd_select_folder_cancellable*: pointer
    update_button_cancellable*: pointer
    change_icon_theme_cancellable*: PGSList

    icon_size*: gint
    n_special*: guint8
    n_volumes*: guint8
    n_shortcuts*: guint8
    n_bookmarks*: guint8
    has_bookmark_separator*: guint
    has_current_folder_separator*: guint
    has_current_folder*: guint
    has_other_separator*: guint
    active*: guint
    focus_on_click*: guint
    is_changing_selection*: guint
  PFileChooserButtonPrivate* = ptr TFileChooserButtonPrivate
  TFileChooserButton* = object of THbox
    priv*: PFileChooserButtonPrivate
  PFileChooserButton* = ptr TFileChooserButton
  TFileChooserButtonClass* = object of THBoxClass
    file_set* : proc (fc: PFileChooserButton){.cdecl.}

  PFileChooserButtonClass* = ptr TFileChooserButtonClass
