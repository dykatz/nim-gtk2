/* Optional native ABI probe: build against GTK2 headers, never initialize GTK. */
#define GTK_DISABLE_DEPRECATED
#include <gtk/gtk.h>
#include <stddef.h>

size_t nim_gtk2_sizeof_print_unit(void) { return sizeof(GtkUnit); }
size_t nim_gtk2_sizeof_page_orientation(void) { return sizeof(GtkPageOrientation); }
size_t nim_gtk2_sizeof_print_pages(void) { return sizeof(GtkPrintPages); }
size_t nim_gtk2_sizeof_page_set(void) { return sizeof(GtkPageSet); }
size_t nim_gtk2_sizeof_print_duplex(void) { return sizeof(GtkPrintDuplex); }
size_t nim_gtk2_sizeof_print_quality(void) { return sizeof(GtkPrintQuality); }
int nim_gtk2_unit_mm(void) { return GTK_UNIT_MM; }
int nim_gtk2_print_selection(void) { return GTK_PRINT_PAGES_SELECTION; }
void nim_gtk2_invoke_print_settings(GtkPrintSettingsFunc fn, gpointer data) {
  fn("cups-abi-option", "copied value", data);
}
size_t nim_gtk2_sizeof_requisition(void) { return sizeof(GtkRequisition); }
size_t nim_gtk2_requisition_height_offset(void) { return offsetof(GtkRequisition, height); }
size_t nim_gtk2_sizeof_event_expose(void) { return sizeof(GdkEventExpose); }
size_t nim_gtk2_event_expose_area_offset(void) { return offsetof(GdkEventExpose, area); }
int nim_gtk2_damage_value(void) { return GDK_DAMAGE; }
typedef void (*NimHsvConvert)(gdouble, gdouble, gdouble, gdouble *, gdouble *, gdouble *);
int nim_gtk2_invoke_hsv_convert(NimHsvConvert fn) {
  gdouble r = -1, g = -1, b = -1;
  fn(0.5, 1.0, 1.0, &r, &g, &b);
  return r == 0.0 && g == 1.0 && b == 1.0;
}

size_t nim_gtk2_sizeof_file_chooser_action(void) { return sizeof(GtkFileChooserAction); }
size_t nim_gtk2_sizeof_file_chooser_error(void) { return sizeof(GtkFileChooserError); }
size_t nim_gtk2_sizeof_file_filter_flags(void) { return sizeof(GtkFileFilterFlags); }
size_t nim_gtk2_sizeof_file_filter_info(void) { return sizeof(GtkFileFilterInfo); }
size_t nim_gtk2_file_filter_mime_offset(void) { return offsetof(GtkFileFilterInfo, mime_type); }
size_t nim_gtk2_sizeof_file_chooser_button(void) { return sizeof(GtkFileChooserButton); }
size_t nim_gtk2_sizeof_file_chooser_button_class(void) { return sizeof(GtkFileChooserButtonClass); }
int nim_gtk2_invoke_file_filter(GtkFileFilterFunc fn, void *data) {
  GtkFileFilterInfo info = { GTK_FILE_FILTER_FILENAME | GTK_FILE_FILTER_URI |
    GTK_FILE_FILTER_DISPLAY_NAME | GTK_FILE_FILTER_MIME_TYPE,
    "/abi.txt", "file:///abi.txt", "abi.txt", "text/plain" };
  return fn(&info, data);
}
size_t nim_gtk2_sizeof_gsize(void) { return sizeof(gsize); }
size_t nim_gtk2_sizeof_gtype(void) { return sizeof(GType); }
size_t nim_gtk2_sizeof_gobject_class(void) { return sizeof(GObjectClass); }
size_t nim_gtk2_sizeof_assistant_page_type(void) { return sizeof(GtkAssistantPageType); }
int nim_gtk2_assistant_progress(void) { return GTK_ASSISTANT_PAGE_PROGRESS; }
size_t nim_gtk2_sizeof_color_selection(void) { return sizeof(GtkColorSelection); }
size_t nim_gtk2_sizeof_color_selection_class(void) { return sizeof(GtkColorSelectionClass); }
size_t nim_gtk2_sizeof_color_selection_dialog(void) { return sizeof(GtkColorSelectionDialog); }
size_t nim_gtk2_sizeof_color_selection_dialog_class(void) { return sizeof(GtkColorSelectionDialogClass); }
size_t nim_gtk2_sizeof_font_selection(void) { return sizeof(GtkFontSelection); }
size_t nim_gtk2_sizeof_font_selection_class(void) { return sizeof(GtkFontSelectionClass); }
size_t nim_gtk2_sizeof_font_selection_dialog(void) { return sizeof(GtkFontSelectionDialog); }
size_t nim_gtk2_sizeof_font_selection_dialog_class(void) { return sizeof(GtkFontSelectionDialogClass); }
size_t nim_gtk2_sizeof_layout(void) { return sizeof(GtkLayout); }
size_t nim_gtk2_sizeof_layout_class(void) { return sizeof(GtkLayoutClass); }
size_t nim_gtk2_sizeof_handlebox(void) { return sizeof(GtkHandleBox); }
size_t nim_gtk2_sizeof_handlebox_class(void) { return sizeof(GtkHandleBoxClass); }
size_t nim_gtk2_layout_extent_width(void) { return sizeof(((GtkLayout *)0)->width); }
int nim_gtk2_automatic_snap_edge(void) { return (int)(GtkPositionType)-1; }
typedef void (*NimHandleChildFunc)(GtkHandleBox *, GtkWidget *, gpointer);
void nim_gtk2_invoke_handle_child(NimHandleChildFunc fn, gpointer data) {
  fn((GtkHandleBox *)(guintptr)0x123, (GtkWidget *)(guintptr)0x456, data);
}
size_t nim_gtk2_sizeof_orientation(void) { return sizeof(GtkOrientation); }
size_t nim_gtk2_sizeof_toolbar_style(void) { return sizeof(GtkToolbarStyle); }
size_t nim_gtk2_sizeof_relief_style(void) { return sizeof(GtkReliefStyle); }
size_t nim_gtk2_sizeof_ellipsize(void) { return sizeof(PangoEllipsizeMode); }
int nim_gtk2_toolbar_both_horiz(void) { return GTK_TOOLBAR_BOTH_HORIZ; }
size_t nim_gtk2_sizeof_attach_options(void) { return sizeof(GtkAttachOptions); }
size_t nim_gtk2_sizeof_button_box_style(void) { return sizeof(GtkButtonBoxStyle); }
int nim_gtk2_button_box_center(void) { return GTK_BUTTONBOX_CENTER; }
size_t nim_gtk2_box_spacing_width(void) { return sizeof(((GtkBox *)0)->spacing); }
size_t nim_gtk2_table_dimension_width(void) { return sizeof(((GtkTable *)0)->ncols); }
size_t nim_gtk2_table_spacing_width(void) { return sizeof(((GtkTableRowCol *)0)->spacing); }
size_t nim_gtk2_table_padding_width(void) { return sizeof(((GtkTableChild *)0)->xpadding); }
size_t nim_gtk2_sizeof_arrow_type(void) { return sizeof(GtkArrowType); }
size_t nim_gtk2_sizeof_shadow_type(void) { return sizeof(GtkShadowType); }
size_t nim_gtk2_sizeof_position_type(void) { return sizeof(GtkPositionType); }
int nim_gtk2_arrow_none(void) { return GTK_ARROW_NONE; }
int nim_gtk2_position_bottom(void) { return GTK_POS_BOTTOM; }
size_t nim_gtk2_sizeof_gdk_color(void) { return sizeof(GdkColor); }
size_t nim_gtk2_offset_gdk_color_red(void) { return offsetof(GdkColor, red); }
size_t nim_gtk2_offset_gdk_color_blue(void) { return offsetof(GdkColor, blue); }
size_t nim_gtk2_sizeof_calendar_options(void) { return sizeof(GtkCalendarDisplayOptions); }
int nim_gtk2_calendar_options(void) {
  return GTK_CALENDAR_SHOW_HEADING | GTK_CALENDAR_SHOW_DAY_NAMES |
    GTK_CALENDAR_NO_MONTH_CHANGE | GTK_CALENDAR_SHOW_WEEK_NUMBERS |
    GTK_CALENDAR_SHOW_DETAILS;
}
size_t nim_gtk2_sizeof_error(void) { return sizeof(GError); }
size_t nim_gtk2_sizeof_recent_data(void) { return sizeof(GtkRecentData); }
size_t nim_gtk2_sizeof_recent_filter_info(void) { return sizeof(GtkRecentFilterInfo); }
size_t nim_gtk2_sizeof_page_range(void) { return sizeof(GtkPageRange); }
size_t nim_gtk2_offset_recent_data_private(void) { return offsetof(GtkRecentData, is_private); }
size_t nim_gtk2_offset_recent_filter_age(void) { return offsetof(GtkRecentFilterInfo, age); }
size_t nim_gtk2_offset_error_message(void) { return offsetof(GError, message); }
size_t nim_gtk2_sizeof_page_type(void) { return sizeof(GtkAssistantPageType); }
size_t nim_gtk2_sizeof_filter_flags(void) { return sizeof(GtkRecentFilterFlags); }
size_t nim_gtk2_sizeof_image_type(void) { return sizeof(GtkImageType); }
size_t nim_gtk2_sizeof_message_type(void) { return sizeof(GtkMessageType); }
size_t nim_gtk2_sizeof_buttons_type(void) { return sizeof(GtkButtonsType); }
size_t nim_gtk2_sizeof_tree_iter(void) { return sizeof(GtkTreeIter); }
size_t nim_gtk2_offset_tree_iter_tail(void) { return offsetof(GtkTreeIter, user_data3); }
size_t nim_gtk2_sizeof_gvalue(void) { return sizeof(GValue); }
size_t nim_gtk2_offset_gvalue_data(void) { return offsetof(GValue, data); }
size_t nim_gtk2_sizeof_text_iter(void) { return sizeof(GtkTextIter); }
size_t nim_gtk2_offset_text_iter_tail(void) { return offsetof(GtkTextIter, dummy14); }
size_t nim_gtk2_sizeof_colorspace(void) { return sizeof(GdkColorspace); }
size_t nim_gtk2_sizeof_interpolation(void) { return sizeof(GdkInterpType); }
size_t nim_gtk2_sizeof_pixbuf_error(void) { return sizeof(GdkPixbufError); }
size_t nim_gtk2_sizeof_alpha_mode(void) { return sizeof(GdkPixbufAlphaMode); }
int nim_gtk2_incomplete_animation(void) { return GDK_PIXBUF_ERROR_INCOMPLETE_ANIMATION; }
size_t nim_gtk2_sizeof_sort_type(void) { return sizeof(GtkSortType); }
int nim_gtk2_sort_descending(void) { return GTK_SORT_DESCENDING; }
size_t nim_gtk2_sizeof_wrap_mode(void) { return sizeof(GtkWrapMode); }
int nim_gtk2_wrap_word_char(void) { return GTK_WRAP_WORD_CHAR; }
int nim_gtk2_image_gicon(void) { return GTK_IMAGE_GICON; }
int nim_gtk2_message_other(void) { return GTK_MESSAGE_OTHER; }

gint nim_gtk2_invoke_assistant(GtkAssistantPageFunc fn, gpointer data)
{
  return fn(5, data);
}

gboolean nim_gtk2_invoke_filter(GtkRecentFilterFunc fn, gpointer data)
{
  GtkRecentFilterInfo info = {0};
  info.contains = GTK_RECENT_FILTER_URI;
  info.uri = "file:///abi.txt";
  info.age = -1;
  return fn(&info, data);
}
