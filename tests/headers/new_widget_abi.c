/* Optional native ABI probe: build against GTK2 headers, never initialize GTK. */
#define GTK_DISABLE_DEPRECATED
#include <gtk/gtk.h>
#include <stddef.h>

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
