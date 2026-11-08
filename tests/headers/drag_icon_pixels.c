/* Public observations only: actual XFixes cursor pixels or GTK's public DND
 * toplevels and GDK drawable capture. No GtkDragSourceInfo/site/cursor cache access. */
#include <gtk/gtk.h>
#include <gdk/gdkx.h>
#include <X11/extensions/Xfixes.h>

int nim_drag_icon_fallback_width(void) {
  guint width, height;
  gdk_display_get_maximal_cursor_size(gdk_display_get_default(), &width, &height);
  return width < 8192 ? MAX((int)width + 1, 96) : 0;
}
/* GTK's cursor compositing rounds some opaque channels down by one. Observe
 * that native rendering, without changing pixels, caches or acceptance bits. */
static int near_channel(guint a, guint b) { return ABS((int)a - (int)b) <= 1; }
int nim_drag_icon_pixels(guint32 rgba, int window_only) {
  int count = 0;
  Display *display = GDK_DISPLAY_XDISPLAY(gdk_display_get_default());
  int event, error;
  if (!XFixesQueryExtension(display, &event, &error)) return -1;
  XFixesCursorImage *cursor = XFixesGetCursorImage(display);
  if (cursor) {
    unsigned int i;
    for (i = 0; i < (unsigned int)cursor->width * cursor->height; ++i) {
      unsigned long pixel = cursor->pixels[i];
      if (((pixel >> 24) & 255) >= 254 &&
          near_channel((pixel >> 16) & 255, rgba >> 24) &&
          near_channel((pixel >> 8) & 255, (rgba >> 16) & 255) &&
          near_channel(pixel & 255, (rgba >> 8) & 255)) ++count;
    }
    XFree(cursor);
  }
  if (window_only) count = 0;
  GList *windows = gtk_window_list_toplevels(), *item;
  for (item = windows; item; item = item->next) {
    GtkWidget *w = item->data;
    if (gtk_window_get_type_hint(GTK_WINDOW(w)) != GDK_WINDOW_TYPE_HINT_DND ||
        !gtk_widget_get_realized(w) || !gtk_widget_get_visible(w)) continue;
    GdkWindow *window = gtk_widget_get_window(w);
    gint width, height;
    gdk_drawable_get_size(GDK_DRAWABLE(window), &width, &height);
    width = MIN(width, 64); height = MIN(height, 48);
    GdkPixbuf *pixels = gdk_pixbuf_get_from_drawable(NULL, GDK_DRAWABLE(window), NULL,
                                                   0, 0, 0, 0, width, height);
    if (!pixels) continue;
    gint x, y, stride = gdk_pixbuf_get_rowstride(pixels), n = gdk_pixbuf_get_n_channels(pixels);
    guchar *data = gdk_pixbuf_get_pixels(pixels);
    for (y = 0; y < height; ++y)
      for (x = 0; x < width; ++x) {
        guchar *p = data + y * stride + x * n;
        if (p[0] == (rgba >> 24) && p[1] == ((rgba >> 16) & 255) && p[2] == ((rgba >> 8) & 255)) ++count;
      }
    g_object_unref(pixels);
  }
  g_list_free(windows);
  return count;
}
