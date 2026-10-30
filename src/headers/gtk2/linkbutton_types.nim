# Included by headers/gtk2.nim; do not import directly.
type
  TLinkButtonPrivate*{.final, pure.} = object
    uri*: cstring
    visited*: gboolean
    popup_menu*: PWidget

  PLinkButtonPrivate* = ptr TLinkButtonPrivate
  TLinkButton* = object of TButton
    priv*: PLinkButtonPrivate

  PLinkButton* = ptr TLinkButton
  TLinkButtonClass* = object of TButtonClass
    padding1*: proc (){.cdecl.}
    padding2*: proc (){.cdecl.}
    padding3*: proc (){.cdecl.}
    padding4*: proc (){.cdecl.}

  PLinkButtonClass* = ptr TLinkButtonClass
