# Generated from gtkiconview.h; included by headers/gtk2.nim.
proc icon_view_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_type".}
proc icon_view_new*(): ptr IconView {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_new".}
proc icon_view_new_with_model*(`model`: ptr TTreeModel): ptr IconView {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_new_with_model".}
proc icon_view_set_model*(`icon_view`: ptr IconView; `model`: ptr TTreeModel) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_model".}
proc icon_view_get_model*(`icon_view`: ptr IconView): ptr TTreeModel {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_model".}
proc icon_view_set_text_column*(`icon_view`: ptr IconView; `column`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_text_column".}
proc icon_view_get_text_column*(`icon_view`: ptr IconView): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_text_column".}
proc icon_view_set_markup_column*(`icon_view`: ptr IconView; `column`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_markup_column".}
proc icon_view_get_markup_column*(`icon_view`: ptr IconView): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_markup_column".}
proc icon_view_set_pixbuf_column*(`icon_view`: ptr IconView; `column`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_pixbuf_column".}
proc icon_view_get_pixbuf_column*(`icon_view`: ptr IconView): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_pixbuf_column".}
proc icon_view_set_item_orientation*(`icon_view`: ptr IconView; `orientation`: TOrientation) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_item_orientation".}
proc icon_view_get_item_orientation*(`icon_view`: ptr IconView): TOrientation {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_item_orientation".}
proc icon_view_set_columns*(`icon_view`: ptr IconView; `columns`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_columns".}
proc icon_view_get_columns*(`icon_view`: ptr IconView): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_columns".}
proc icon_view_set_item_width*(`icon_view`: ptr IconView; `item_width`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_item_width".}
proc icon_view_get_item_width*(`icon_view`: ptr IconView): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_item_width".}
proc icon_view_set_spacing*(`icon_view`: ptr IconView; `spacing`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_spacing".}
proc icon_view_get_spacing*(`icon_view`: ptr IconView): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_spacing".}
proc icon_view_set_row_spacing*(`icon_view`: ptr IconView; `row_spacing`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_row_spacing".}
proc icon_view_get_row_spacing*(`icon_view`: ptr IconView): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_row_spacing".}
proc icon_view_set_column_spacing*(`icon_view`: ptr IconView; `column_spacing`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_column_spacing".}
proc icon_view_get_column_spacing*(`icon_view`: ptr IconView): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_column_spacing".}
proc icon_view_set_margin*(`icon_view`: ptr IconView; `margin`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_margin".}
proc icon_view_get_margin*(`icon_view`: ptr IconView): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_margin".}
proc icon_view_set_item_padding*(`icon_view`: ptr IconView; `item_padding`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_item_padding".}
proc icon_view_get_item_padding*(`icon_view`: ptr IconView): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_item_padding".}
proc icon_view_get_path_at_pos*(`icon_view`: ptr IconView; `x`: gint; `y`: gint): ptr TTreePath {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_path_at_pos".}
proc icon_view_get_item_at_pos*(`icon_view`: ptr IconView; `x`: gint; `y`: gint; `path`: ptr ptr TTreePath; `cell`: ptr ptr TCellRenderer): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_item_at_pos".}
proc icon_view_get_visible_range*(`icon_view`: ptr IconView; `start_path`: ptr ptr TTreePath; `end_path`: ptr ptr TTreePath): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_visible_range".}
proc icon_view_selected_foreach*(`icon_view`: ptr IconView; `func`: IconViewForeachFunc; `data`: pointer) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_selected_foreach".}
proc icon_view_set_selection_mode*(`icon_view`: ptr IconView; `mode`: TSelectionMode) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_selection_mode".}
proc icon_view_get_selection_mode*(`icon_view`: ptr IconView): TSelectionMode {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_selection_mode".}
proc icon_view_select_path*(`icon_view`: ptr IconView; `path`: ptr TTreePath) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_select_path".}
proc icon_view_unselect_path*(`icon_view`: ptr IconView; `path`: ptr TTreePath) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_unselect_path".}
proc icon_view_path_is_selected*(`icon_view`: ptr IconView; `path`: ptr TTreePath): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_path_is_selected".}
proc icon_view_get_item_row*(`icon_view`: ptr IconView; `path`: ptr TTreePath): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_item_row".}
proc icon_view_get_item_column*(`icon_view`: ptr IconView; `path`: ptr TTreePath): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_item_column".}
proc icon_view_get_selected_items*(`icon_view`: ptr IconView): ptr TGList {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_selected_items".}
proc icon_view_select_all*(`icon_view`: ptr IconView) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_select_all".}
proc icon_view_unselect_all*(`icon_view`: ptr IconView) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_unselect_all".}
proc icon_view_item_activated*(`icon_view`: ptr IconView; `path`: ptr TTreePath) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_item_activated".}
proc icon_view_set_cursor*(`icon_view`: ptr IconView; `path`: ptr TTreePath; `cell`: ptr TCellRenderer; `start_editing`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_cursor".}
proc icon_view_get_cursor*(`icon_view`: ptr IconView; `path`: ptr ptr TTreePath; `cell`: ptr ptr TCellRenderer): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_cursor".}
proc icon_view_scroll_to_path*(`icon_view`: ptr IconView; `path`: ptr TTreePath; `use_align`: gboolean; `row_align`: gfloat; `col_align`: gfloat) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_scroll_to_path".}
proc icon_view_enable_model_drag_source*(`icon_view`: ptr IconView; `start_button_mask`: gdk2.TModifierType; `targets`: ptr TTargetEntry; `n_targets`: gint; `actions`: gdk2.TDragAction) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_enable_model_drag_source".}
proc icon_view_enable_model_drag_dest*(`icon_view`: ptr IconView; `targets`: ptr TTargetEntry; `n_targets`: gint; `actions`: gdk2.TDragAction) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_enable_model_drag_dest".}
proc icon_view_unset_model_drag_source*(`icon_view`: ptr IconView) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_unset_model_drag_source".}
proc icon_view_unset_model_drag_dest*(`icon_view`: ptr IconView) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_unset_model_drag_dest".}
proc icon_view_set_reorderable*(`icon_view`: ptr IconView; `reorderable`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_reorderable".}
proc icon_view_get_reorderable*(`icon_view`: ptr IconView): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_reorderable".}
proc icon_view_set_drag_dest_item*(`icon_view`: ptr IconView; `path`: ptr TTreePath; `pos`: IconViewDropPosition) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_drag_dest_item".}
proc icon_view_get_drag_dest_item*(`icon_view`: ptr IconView; `path`: ptr ptr TTreePath; `pos`: ptr IconViewDropPosition) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_drag_dest_item".}
proc icon_view_get_dest_item_at_pos*(`icon_view`: ptr IconView; `drag_x`: gint; `drag_y`: gint; `path`: ptr ptr TTreePath; `pos`: ptr IconViewDropPosition): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_dest_item_at_pos".}
proc icon_view_create_drag_icon*(`icon_view`: ptr IconView; `path`: ptr TTreePath): ptr gdk2.TPixmap {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_create_drag_icon".}
proc icon_view_convert_widget_to_bin_window_coords*(`icon_view`: ptr IconView; `wx`: gint; `wy`: gint; `bx`: ptr gint; `by`: ptr gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_convert_widget_to_bin_window_coords".}
proc icon_view_set_tooltip_item*(`icon_view`: ptr IconView; `tooltip`: ptr TTooltip; `path`: ptr TTreePath) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_tooltip_item".}
proc icon_view_set_tooltip_cell*(`icon_view`: ptr IconView; `tooltip`: ptr TTooltip; `path`: ptr TTreePath; `cell`: ptr TCellRenderer) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_tooltip_cell".}
proc icon_view_get_tooltip_context*(`icon_view`: ptr IconView; `x`: ptr gint; `y`: ptr gint; `keyboard_tip`: gboolean; `model`: ptr ptr TTreeModel; `path`: ptr ptr TTreePath; `iter`: ptr TTreeIter): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_tooltip_context".}
proc icon_view_set_tooltip_column*(`icon_view`: ptr IconView; `column`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_set_tooltip_column".}
proc icon_view_get_tooltip_column*(`icon_view`: ptr IconView): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_icon_view_get_tooltip_column".}
