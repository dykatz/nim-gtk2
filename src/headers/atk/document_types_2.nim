# Included by headers/atk.nim; do not import directly.
type
  TDocumentIface* = object of TGTypeInterface
    get_document_type*: proc (document: PDocument): cstring{.cdecl.}
    get_document*: proc (document: PDocument): gpointer{.cdecl.}
    pad1*: TFunction
    pad2*: TFunction
    pad3*: TFunction
    pad4*: TFunction
    pad5*: TFunction
    pad6*: TFunction
    pad7*: TFunction
    pad8*: TFunction

  PDocumentIface* = ptr TDocumentIface
