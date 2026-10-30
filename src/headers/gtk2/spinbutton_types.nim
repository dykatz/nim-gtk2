# Included by headers/gtk2.nim; do not import directly.
type
  TSpinButtonUpdatePolicy* = enum
    UPDATE_ALWAYS, UPDATE_IF_VALID
  PSpinButtonUpdatePolicy* = ptr TSpinButtonUpdatePolicy
  TSpinType* = enum
    SPIN_STEP_FORWARD, SPIN_STEP_BACKWARD, SPIN_PAGE_FORWARD,
    SPIN_PAGE_BACKWARD, SPIN_HOME, SPIN_END, SPIN_USER_DEFINED
  PSpinType* = ptr TSpinType
  TSpinButton* = object of TEntry
    adjustment*: PAdjustment
    panel*: gdk2.PWindow
    timer*: guint32
    climb_rate*: gdouble
    timer_step*: gdouble
    update_policy*: TSpinButtonUpdatePolicy
    SpinButton_flag0*: uint32

  PSpinButton* = ptr TSpinButton
  TSpinButtonClass* = object of TEntryClass
    input*: proc (spin_button: PSpinButton, new_value: Pgdouble): gint{.cdecl.}
    output*: proc (spin_button: PSpinButton): gint{.cdecl.}
    value_changed*: proc (spin_button: PSpinButton){.cdecl.}
    change_value*: proc (spin_button: PSpinButton, scroll: TScrollType){.cdecl.}
    reserved631: proc (){.cdecl.}
    reserved632: proc (){.cdecl.}
    reserved633: proc (){.cdecl.}
    reserved634: proc (){.cdecl.}

  PSpinButtonClass* = ptr TSpinButtonClass
