# Included by headers/gtk2.nim; do not import directly.
type
  TFrameClass* = object of TBinClass
    compute_child_allocation*: proc (frame: PFrame, allocation: PAllocation){.
        cdecl.}

  PFrameClass* = ptr TFrameClass
