# Included by headers/xkb.nim; do not import directly.
proc XkbSARedirectVMods*(a: PXkbRedirectKeyAction): int16
proc XkbSARedirectSetVMods*(a: PXkbRedirectKeyAction, m: int8)
proc XkbSARedirectVModsMask*(a: PXkbRedirectKeyAction): int16
proc XkbSARedirectSetVModsMask*(a: PXkbRedirectKeyAction, m: int8)
