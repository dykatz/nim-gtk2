/* Standalone native GTK2/GIO compatibility diagnostic. No Nim, no mapped UI.
 * Pass an existing directory containing at least one file. Modern GIO diagnoses
 * GTK2's filename-completion model's missing is-hidden/is-backup attributes.
 * See docs/gtk2.md and patches/gtk2-filechooser-completion-gio.patch.
 */
#include <gtk/gtk.h>

int main(int argc, char **argv)
{
  GtkWidget *chooser;
  gint64 until;

  if (argc != 2) {
    g_printerr("usage: %s directory-containing-files\n", argv[0]);
    return 2;
  }
  if (!gtk_init_check(&argc, &argv))
    return 2;

  chooser = gtk_file_chooser_widget_new(GTK_FILE_CHOOSER_ACTION_SAVE);
  g_object_ref_sink(chooser);
  gtk_file_chooser_set_current_folder(GTK_FILE_CHOOSER(chooser), argv[1]);
  gtk_file_chooser_set_current_name(GTK_FILE_CHOOSER(chooser), "new-file.txt");
  until = g_get_monotonic_time() + G_TIME_SPAN_SECOND;
  while (g_get_monotonic_time() < until) {
    while (gtk_events_pending())
      gtk_main_iteration_do(FALSE);
    g_usleep(5000);
  }
  gtk_widget_destroy(chooser);
  g_object_unref(chooser);
  return 0;
}
