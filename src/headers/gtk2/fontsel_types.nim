# Included by headers/gtk2.nim; do not import directly.
type
  TFontSelection* = object of TVBox
    font_entry*: PWidget
    family_list*: PWidget
    font_style_entry*: PWidget
    face_list*: PWidget
    size_entry*: PWidget
    size_list*: PWidget
    pixels_button*: PWidget
    points_button*: PWidget
    filter_button*: PWidget
    preview_entry*: PWidget
    family*: pango.PFontFamily
    face*: pango.PFontFace
    size*: gint
    font*: gdk2.PFont

  PFontSelection* = ptr TFontSelection
  TFontSelectionDialog* = object of TDialog
    fontsel*: PWidget
    main_vbox*: PWidget
    FontSelectionDialog_action_area*: PWidget
    ok_button*: PWidget
    apply_button*: PWidget
    cancel_button*: PWidget
    dialog_width*: gint
    auto_resize*: gboolean

  PFontSelectionDialog* = ptr TFontSelectionDialog
