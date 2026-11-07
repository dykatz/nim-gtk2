/* Optional native GTK2 diagnostic; no realization, selection or warning suppression.
 * gcc ... textview_overwrite.c $(pkg-config --cflags --libs gtk+-2.0)
 * Run with G_DEBUG=fatal-warnings. Stock 2.24.33 can fail the layout assertion;
 * the optional source patch makes this exit normally. Never modifies installed GTK.
 */
#include <gtk/gtk.h>
int main(int argc, char **argv) {
  gtk_init(&argc, &argv);
  GtkTextBuffer *buffer = gtk_text_buffer_new(NULL);
  GtkWidget *view = gtk_text_view_new_with_buffer(buffer);
  g_object_unref(buffer);
  g_object_ref_sink(view);
  gtk_text_view_set_overwrite(GTK_TEXT_VIEW(view), TRUE);
  if (!gtk_text_view_get_overwrite(GTK_TEXT_VIEW(view)) || gtk_widget_get_realized(view)) return 1;
  gtk_widget_destroy(view);
  g_object_unref(view);
  return 0;
}
