/* Native GTK2 diagnostic, independent of Nim; no windows are mapped.
 * Use a fresh absolute XBEL filename in an existing temporary directory.
 * Empty-list source cleanup in GTK2 calls g_source_remove from its own destroy
 * notifier, which modern GLib diagnoses. See the optional native source patch.
 */
#include <gtk/gtk.h>

int main(int argc, char **argv)
{
  GtkRecentManager *manager;
  GtkWidget *chooser;
  if (argc != 2 || !gtk_init_check(&argc, &argv))
    return 2;
  manager = g_object_new(GTK_TYPE_RECENT_MANAGER, "filename", argv[1], NULL);
  chooser = gtk_recent_chooser_widget_new_for_manager(manager);
  g_object_ref_sink(chooser);
  gtk_recent_chooser_set_limit(GTK_RECENT_CHOOSER(chooser), 10);
  while (gtk_events_pending())
    gtk_main_iteration_do(FALSE);
  gtk_widget_destroy(chooser);
  g_object_unref(chooser);
  g_object_unref(manager);
  return 0;
}
