/* Isolated X11 test manager: real SAVE_TARGETS, native GTK INCR reception/serving.
 * Own X connection for manager requests; no private GTK layout or codec decoding. */
#include <gtk/gtk.h>
#include <gdk/gdkx.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
typedef struct { gchar *name, *type; guchar *bytes; gint len; } Item;
static Display *xd;
static Window win;
static Atom manager, save, clipboard;
static XSelectionRequestEvent request;
static int busy, reject_request;
static void notify(int success) {
  XEvent reply;
  memset(&reply, 0, sizeof(reply));
  reply.xselection.type = SelectionNotify;
  reply.xselection.display = xd;
  reply.xselection.requestor = request.requestor;
  reply.xselection.selection = request.selection;
  reply.xselection.target = request.target;
  reply.xselection.property = success ? request.property : None;
  reply.xselection.time = request.time;
  XSendEvent(xd, request.requestor, False, 0, &reply);
  XFlush(xd);
  busy = 0;
}
static void free_item(gpointer data) {
  Item *item = data;
  g_free(item->name); g_free(item->type); g_free(item->bytes); g_free(item);
}
static void get_item(GtkClipboard *c, GtkSelectionData *selection, guint info, gpointer data) {
  Item *item = g_ptr_array_index((GPtrArray *)data, info);
  gtk_selection_data_set(selection, gdk_atom_intern(item->type, FALSE), 8, item->bytes, item->len);
}
static void clear_items(GtkClipboard *c, gpointer data) {
  g_ptr_array_free((GPtrArray *)data, TRUE);
}
static void received(GtkClipboard *c, GtkSelectionData *selection, gpointer data) {
  int size = gtk_selection_data_get_length(selection);
  if (size < 0 || size > 2000000 || gtk_selection_data_get_format(selection) != 8) {
    notify(0); printf("REJECTED\n"); fflush(stdout); return;
  }
  GPtrArray *items = g_ptr_array_new_with_free_func(free_item);
  Item *item = g_new0(Item, 1);
  item->name = gdk_atom_name(gtk_selection_data_get_target(selection));
  item->type = gdk_atom_name(gtk_selection_data_get_data_type(selection));
  item->len = size;
  item->bytes = g_malloc(MAX(size, 1));
  if (size) memcpy(item->bytes, gtk_selection_data_get_data(selection), size);
  g_ptr_array_add(items, item);
  GtkTargetEntry target = { item->name, 0, 0 };
  if (!gtk_clipboard_set_with_data(c, &target, 1, get_item, clear_items, items)) exit(4);
  gdk_display_sync(gdk_display_get_default());
  printf("SAVED %s %d\n", item->name, size); fflush(stdout);
  notify(1);
}
int nim_gtk2_test_manager(int reject) {
  reject_request = reject;
  xd = XOpenDisplay(NULL);
  if (!xd) return 2;
  manager = XInternAtom(xd, "CLIPBOARD_MANAGER", False);
  save = XInternAtom(xd, "SAVE_TARGETS", False);
  clipboard = XInternAtom(xd, "CLIPBOARD", False);
  if (XGetSelectionOwner(xd, manager) != None) return 3; /* Never replace a real manager. */
  win = XCreateSimpleWindow(xd, DefaultRootWindow(xd), 0, 0, 1, 1, 0, 0, 0);
  XSetSelectionOwner(xd, manager, win, CurrentTime);
  XSync(xd, False);
  printf("MANAGER_READY\n"); fflush(stdout);
  for (;;) {
    while (XPending(xd)) {
      XEvent event; XNextEvent(xd, &event);
      if (event.type != SelectionRequest) continue;
      if (busy) return 5;
      request = event.xselectionrequest;
      busy = 1;
      if (reject_request == 2 && request.target == save) { busy = 0; continue; } /* Real unresponsive-manager probe. */
      if (request.target != save || reject_request == 1) {
        notify(0); printf("REJECTED\n"); fflush(stdout); continue;
      }
      Atom type; int format; unsigned long count, remaining; unsigned char *value = NULL;
      if (XGetWindowProperty(xd, request.requestor, request.property, 0, 1024, False,
          XA_ATOM, &type, &format, &count, &remaining, &value) != Success ||
          type != XA_ATOM || format != 32 || !count || remaining) return 6;
      Atom *targets = (Atom *)value;
      char *selected = NULL;
      printf("HINTS %lu", count);
      for (unsigned long i = 0; i < count; i++) {
        char *name = XGetAtomName(xd, targets[i]);
        printf(" %s", name);
        if (!selected && (!strcmp(name, "UTF8_STRING") || !strcmp(name, "image/png") ||
            !strcmp(name, "text/uri-list") || !strncmp(name, "application/", 12))) selected = strdup(name);
        XFree(name);
      }
      printf("\n"); fflush(stdout); XFree(value);
      if (!selected) { notify(0); continue; }
      gtk_clipboard_request_contents(gtk_clipboard_get(GDK_SELECTION_CLIPBOARD),
        gdk_atom_intern(selected, FALSE), received, NULL);
      free(selected);
    }
    while (gtk_events_pending()) gtk_main_iteration_do(FALSE);
    g_usleep(1000);
  }
}
