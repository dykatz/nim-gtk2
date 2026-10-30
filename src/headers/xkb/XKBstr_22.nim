# Included by headers/xkb.nim; do not import directly.
proc XkbXI_DevHasBtnActs*(d: PXkbDeviceInfoPtr): bool
proc XkbXI_LegalDevBtn*(d: PXkbDeviceInfoPtr, b: int16): bool
proc XkbXI_DevHasLeds*(d: PXkbDeviceInfoPtr): bool
