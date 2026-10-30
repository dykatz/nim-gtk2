# Included by headers/gtk2.nim; do not import directly.
type
  TLabel* = object of TMisc
    `label`*: cstring
    Label_flag0*: guint16
    mnemonic_keyval*: guint
    text*: cstring
    attrs*: pango.PAttrList
    effective_attrs*: pango.PAttrList
    layout*: pango.PLayout
    mnemonic_widget*: PWidget
    mnemonic_window*: PWindow
    select_info*: PLabelSelectionInfo

  PLabel* = ptr TLabel
