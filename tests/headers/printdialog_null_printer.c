/* Standalone GTK2.24 diagnostic: no mapped windows, files or print jobs.
 * Requires an installed lpr print backend (or pass another backend name).
 * Build with pkg-config --cflags --libs gtk+-unix-print-2.0.
 * Run with G_DEBUG=fatal-warnings. An absent/unselected backend exits 2.
 */
#include <gtk/gtk.h>
#include <gtk/gtkunixprint.h>
#include <stdio.h>

int main(int argc, char **argv)
{
  GtkWidget *dialog;
  const char *backend = argc > 1 ? argv[1] : "lpr";
  if (!gtk_init_check(&argc, &argv)) return 2;
  g_object_set(gtk_settings_get_default(), "gtk-print-backends", backend, NULL);
  dialog = gtk_print_unix_dialog_new("Native printer selection diagnostic", NULL);
  g_object_ref_sink(dialog);
  if (!gtk_print_unix_dialog_get_selected_printer(GTK_PRINT_UNIX_DIALOG(dialog)))
    {
      fprintf(stderr, "Backend has no initial selected printer; diagnostic not exercised\n");
      gtk_widget_destroy(dialog);
      g_object_unref(dialog);
      return 2;
    }
  /* Refiltering a real selection can temporarily leave printer == NULL. */
  gtk_print_unix_dialog_set_manual_capabilities(GTK_PRINT_UNIX_DIALOG(dialog),
    GTK_PRINT_CAPABILITY_COPIES | GTK_PRINT_CAPABILITY_COLLATE |
    GTK_PRINT_CAPABILITY_SCALE | GTK_PRINT_CAPABILITY_GENERATE_PDF);
  while (gtk_events_pending()) gtk_main_iteration_do(FALSE);
  gtk_widget_destroy(dialog);
  g_object_unref(dialog);
  return 0;
}
