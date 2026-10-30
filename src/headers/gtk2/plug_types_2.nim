# Included by headers/gtk2.nim; do not import directly.
type
  TPlugClass* = object of TWindowClass
    embedded*: proc (plug: PPlug){.cdecl.}
    reserved551: proc (){.cdecl.}
    reserved552: proc (){.cdecl.}
    reserved553: proc (){.cdecl.}
    reserved554: proc (){.cdecl.}

  # GtkProgress is deprecated but embedded in GtkProgressBar's C layout.
  # Retain only private ABI storage, never a public GtkProgress binding.
  PPlugClass* = ptr TPlugClass
