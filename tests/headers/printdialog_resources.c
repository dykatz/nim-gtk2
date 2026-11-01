/* Native GTK2.24 resource diagnostic; no Nim, mapped windows, backends or jobs.
 * Exit 1 on GTK2's leaked final GtkPageSetup, 0 when fixed.
 * Build with your compiler and pkg-config --cflags --libs gtk+-unix-print-2.0.
 */
#include <gtk/gtk.h>
#include <gtk/gtkpagesetupunixdialog.h>
#include <stdio.h>

static void finalized(gpointer data, GObject *object)
{
  *(int *)data = 1;
}
int main(int argc, char **argv)
{
  GtkWidget *dialog;
  GtkPageSetup *setup;
  int gone = 0;
  if (!gtk_init_check(&argc, &argv)) return 2;
  g_object_set(gtk_settings_get_default(), "gtk-print-backends", "", NULL);
  dialog = gtk_page_setup_unix_dialog_new("Native resource diagnostic", NULL);
  g_object_ref_sink(dialog);
  /* Contrary to its annotation, GTK2 returns a full reference here. */
  setup = gtk_page_setup_unix_dialog_get_page_setup(GTK_PAGE_SETUP_UNIX_DIALOG(dialog));
  g_object_weak_ref(G_OBJECT(setup), finalized, &gone);
  g_object_unref(setup);
  gtk_widget_destroy(dialog);
  g_object_unref(dialog);
  if (!gone) fprintf(stderr, "GTK2 retained its final last_setup reference\n");
  return gone ? 0 : 1;
}
