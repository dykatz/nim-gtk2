/* Opt-in GTK2 native defect diagnostic; maps no windows. Not a passing SDK test.
 * gcc -m64 tests/headers/text_serialization.c $(pkg-config --cflags --libs gtk+-2.0) -o /tmp/text-serialization
 * /tmp/text-serialization --anchor|--literal|--past-end|--bad-header
 * A two-second alarm bounds the known native serializer hang. Installed GTK is
 * never changed. See patches/gtk2-text-serialization.patch and docs/gtk2.md.
 */
#include <gtk/gtk.h>
#include <signal.h>
#include <unistd.h>
#include <string.h>
static void stalled(int sig) {
  const char message[] = "GTK2 serializer did not advance over non-pixbuf U+FFFC\n";
  (void)sig;
  (void)write(2, message, sizeof(message)-1);
  _exit(1);
}
int main(int argc, char **argv) {
  GtkTextBuffer *source, *destination;
  GtkTextIter first, last;
  GdkAtom format;
  guint8 *bytes;
  gsize length;
  GError *error = NULL;
  gboolean ok;
  const char *mode;
  if (argc != 2) return 2;
  mode = argv[1];
  gtk_init(&argc, &argv);
  source = gtk_text_buffer_new(NULL);
  format = gtk_text_buffer_register_serialize_tagset(source, NULL);
  gtk_text_buffer_register_deserialize_tagset(source, NULL);
  gtk_text_buffer_deserialize_set_can_create_tags(source, format, TRUE);
  gtk_text_buffer_set_text(source, "AB", -1);
  gtk_text_buffer_get_end_iter(source, &last);
  if (!strcmp(mode, "--anchor"))
    gtk_text_buffer_create_child_anchor(source, &last);
  else if (!strcmp(mode, "--literal"))
    gtk_text_buffer_insert(source, &last, "\357\277\274", -1);
  else if (!strcmp(mode, "--past-end")) {
    GdkPixbuf *image = gdk_pixbuf_new(GDK_COLORSPACE_RGB, TRUE, 8, 2, 2);
    gdk_pixbuf_fill(image, 0x123456ff);
    gtk_text_buffer_insert_pixbuf(source, &last, image);
    g_object_unref(image);
  } else if (!strcmp(mode, "--bad-header")) {
    const guint8 invalid[] = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    gtk_text_buffer_get_start_iter(source, &first);
    ok = gtk_text_buffer_deserialize(source, source, format, &first,
      invalid, sizeof(invalid)-1, &error);
    if (error) g_error_free(error);
    g_object_unref(source);
    return ok ? 2 : 0; /* Run with G_DEBUG=fatal-warnings to expose domain zero. */
  } else return 2;
  gtk_text_buffer_get_start_iter(source, &first);
  gtk_text_buffer_get_end_iter(source, &last);
  if (!strcmp(mode, "--past-end")) gtk_text_buffer_get_iter_at_offset(source, &last, 1);
  signal(SIGALRM, stalled);
  alarm(2);
  bytes = gtk_text_buffer_serialize(source, source, format, &first, &last, &length);
  alarm(0);
  if (!bytes) return 2;
  destination = gtk_text_buffer_new(NULL);
  gtk_text_buffer_get_start_iter(destination, &first);
  ok = gtk_text_buffer_deserialize(source, destination, format, &first, bytes, length, &error);
  g_free(bytes);
  if (!strcmp(mode, "--past-end") && (!ok || gtk_text_buffer_get_char_count(destination) != 1)) {
    g_printerr("GTK2 serializer scanned beyond the selected end%s%s\n",
      error ? ": " : "", error ? error->message : "");
    if (error) g_error_free(error);
    g_object_unref(destination); g_object_unref(source);
    return 1;
  }
  if (error) g_error_free(error);
  g_object_unref(destination); g_object_unref(source);
  return ok ? 0 : 2;
}
