# Included by headers/xkb.nim; do not import directly.
proc XkbAX_AnyFeedback*(c: PXkbControlsPtr): int16
proc XkbAX_NeedOption*(c: PXkbControlsPtr, w: int16): int16
proc XkbAX_NeedFeedback*(c: PXkbControlsPtr, w: int16): bool
  #
  #      Assorted constants and limits.
  #
