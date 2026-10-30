# Included by headers/gtk2.nim; do not import directly.
type
  TProgressBarStyle* = enum
    PROGRESS_CONTINUOUS, PROGRESS_DISCRETE
  PProgressBarStyle* = ptr TProgressBarStyle
  TProgressBarOrientation* = enum
    PROGRESS_LEFT_TO_RIGHT, PROGRESS_RIGHT_TO_LEFT, PROGRESS_BOTTOM_TO_TOP,
    PROGRESS_TOP_TO_BOTTOM
  PProgressBarOrientation* = ptr TProgressBarOrientation
  TProgressBar* = object of ProgressLayout
    bar_style*: TProgressBarStyle
    orientation*: TProgressBarOrientation
    blocks*: guint
    in_block*: gint
    activity_pos*: gint
    activity_step*: guint
    activity_blocks*: guint
    pulse_fraction*: gdouble
    ProgressBar_flag0*: guint16

  PProgressBar* = ptr TProgressBar
