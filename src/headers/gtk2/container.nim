# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CONTAINER*(): GType
proc CONTAINER*(obj: pointer): PContainer
proc CONTAINER_CLASS*(klass: pointer): PContainerClass
proc IS_CONTAINER*(obj: pointer): bool
proc IS_CONTAINER_CLASS*(klass: pointer): bool
proc CONTAINER_GET_CLASS*(obj: pointer): PContainerClass
proc IS_RESIZE_CONTAINER*(widget: pointer): bool
proc border_width*(a: PContainer): guint
proc need_resize*(a: PContainer): guint
proc set_need_resize*(a: PContainer, `need_resize`: guint)
proc resize_mode*(a: PContainer): guint
