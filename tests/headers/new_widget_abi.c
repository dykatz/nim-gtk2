/* Optional native ABI probe: build against GTK2 headers, never initialize GTK. */
#define GTK_DISABLE_DEPRECATED
#include <gtk/gtk.h>
#include <stddef.h>

gboolean nim_gtk2_image_offer_abi(gboolean (*set)(GtkSelectionData *, GdkPixbuf *),
                                GdkPixbuf *(*get)(GtkSelectionData *)) {
  typedef void (*Targets)(GtkTargetList *, guint, gboolean);
  typedef GtkTargetEntry *(*Table)(GtkTargetList *, gint *);
  typedef void (*Free)(GtkTargetEntry *, gint);
  typedef gboolean (*Set)(GtkSelectionData *, GdkPixbuf *);
  typedef GdkPixbuf *(*Get)(GtkSelectionData *);
  typedef GdkPixbuf *(*Copy)(const GdkPixbuf *);
#define IMAGE_ABI(T, F) { typedef char checked[__builtin_types_compatible_p(T, __typeof__(&F)) ? 1 : -1]; (void)sizeof(checked); }
  IMAGE_ABI(Targets, gtk_target_list_add_image_targets);
  IMAGE_ABI(Table, gtk_target_table_new_from_list);
  IMAGE_ABI(Free, gtk_target_table_free);
  IMAGE_ABI(Set, gtk_selection_data_set_pixbuf);
  IMAGE_ABI(Get, gtk_selection_data_get_pixbuf);
  IMAGE_ABI(Copy, gdk_pixbuf_copy);
#undef IMAGE_ABI
  return set((GtkSelectionData *)(guintptr)0xc1, (GdkPixbuf *)(guintptr)0xc2) == -73 &&
    get((GtkSelectionData *)(guintptr)0xc1) == (GdkPixbuf *)(guintptr)0xc2;
}

gboolean nim_gtk2_uri_drag_abi(gboolean (*drop)(GtkWidget *, GdkDragContext *, gint, gint, guint),
  void (*data)(GtkWidget *, GdkDragContext *, gint, gint, GtkSelectionData *, guint, guint),
  void (*del)(GtkWidget *, GdkDragContext *), gboolean (*succeeded)(GdkDragContext *)) {
  typedef void (*Get)(GtkWidget *, GdkDragContext *, GdkAtom, guint32);
  typedef void (*Finish)(GdkDragContext *, gboolean, gboolean, guint32);
  typedef GdkAtom (*Find)(GtkWidget *, GdkDragContext *, GtkTargetList *);
  typedef gboolean (*Outcome)(GdkDragContext *);
  typedef void (*Source)(GtkWidget *, GdkModifierType, const GtkTargetEntry *, gint, GdkDragAction);
  typedef void (*Dest)(GtkWidget *, GtkDestDefaults, const GtkTargetEntry *, gint, GdkDragAction);
#define URI_DRAG_ABI(TYPE, EXPR) typedef char checked[__builtin_types_compatible_p(TYPE, __typeof__(EXPR)) ? 1 : -1]; (void)sizeof(checked)
  { URI_DRAG_ABI(Get, &gtk_drag_get_data); }
  { URI_DRAG_ABI(Outcome, &gdk_drag_drop_succeeded); }
  { URI_DRAG_ABI(Finish, &gtk_drag_finish); }
  { URI_DRAG_ABI(Find, &gtk_drag_dest_find_target); }
  { URI_DRAG_ABI(Source, &gtk_drag_source_set); }
  { URI_DRAG_ABI(Dest, &gtk_drag_dest_set); }
  { URI_DRAG_ABI(__typeof__(drop), ((GtkWidgetClass *)0)->drag_drop); }
  { URI_DRAG_ABI(__typeof__(data), ((GtkWidgetClass *)0)->drag_data_received); }
  { URI_DRAG_ABI(__typeof__(del), ((GtkWidgetClass *)0)->drag_data_delete); }
#undef URI_DRAG_ABI
  if (drop((GtkWidget *)(guintptr)0xc1, (GdkDragContext *)(guintptr)0xc2, -456789, 123456, 0xf2345678u) != -33) return FALSE;
  data((GtkWidget *)(guintptr)0xc1, (GdkDragContext *)(guintptr)0xc2, -400000, 500000,
       (GtkSelectionData *)(guintptr)0xc3, 0x89abcdefu, 0xf2345678u);
  del((GtkWidget *)(guintptr)0xc1, (GdkDragContext *)(guintptr)0xc2);
  return sizeof(GtkDragResult) == sizeof(gint) && succeeded((GdkDragContext *)(guintptr)0xc2) == -91;
}
gboolean nim_gtk2_uri_selection_abi(gboolean (*set)(GtkSelectionData *, gchar **),
                                  gchar **(*get)(GtkSelectionData *)) {
  typedef gboolean (*Set)(GtkSelectionData *, gchar **);
  typedef gchar **(*Get)(GtkSelectionData *);
  typedef char SetSignature[__builtin_types_compatible_p(Set, __typeof__(&gtk_selection_data_set_uris)) ? 1 : -1];
  typedef char GetSignature[__builtin_types_compatible_p(Get, __typeof__(&gtk_selection_data_get_uris)) ? 1 : -1];
  gchar *items[] = { "file:///a%20b", "urn:example:x", NULL };
  gchar **result;
  (void)sizeof(SetSignature); (void)sizeof(GetSignature);
  if (set((GtkSelectionData *)(guintptr)0xb1, items) != -77) return FALSE;
  result = get((GtkSelectionData *)(guintptr)0xb1);
  return result && result[0] && result[0][0] == 'u' && result[1] == NULL;
}
size_t nim_gtk2_text_window_type_size_abi(void) { return sizeof(GtkTextWindowType); }
gboolean nim_gtk2_public_text_paths_abi(void (*coords)(GtkTextView *, GtkTextWindowType, gint, gint, gint *, gint *)) {
  typedef void (*Offset)(GtkTextBuffer *, GtkTextIter *, gint);
  typedef void (*Line)(GtkTextBuffer *, GtkTextIter *, gint, gint);
  typedef void (*Mark)(GtkTextBuffer *, GtkTextIter *, GtkTextMark *);
  typedef GSList *(*Tags)(const GtkTextIter *);
  typedef gboolean (*Toggle)(GtkTextIter *, GtkTextTag *);
  typedef gchar *(*Slice)(const GtkTextIter *, const GtkTextIter *);
  typedef void (*Visible)(GtkTextView *, GdkRectangle *);
  typedef void (*Location)(GtkTextView *, const GtkTextIter *, GdkRectangle *);
  typedef void (*AtLocation)(GtkTextView *, GtkTextIter *, gint, gint);
  typedef void (*YRange)(GtkTextView *, const GtkTextIter *, gint *, gint *);
  typedef void (*AtY)(GtkTextView *, GtkTextIter *, gint, gint *);
  typedef void (*Coords)(GtkTextView *, GtkTextWindowType, gint, gint, gint *, gint *);
  typedef GtkIconSet *(*IconNew)(void);
  typedef GtkIconSet *(*IconRef)(GtkIconSet *);
  typedef void (*IconUnref)(GtkIconSet *);
#define PUBLIC_TEXT_AUDIT(TYPE, EXPR) typedef char signature[__builtin_types_compatible_p(TYPE, __typeof__(EXPR)) ? 1 : -1]; (void)sizeof(signature)
  { PUBLIC_TEXT_AUDIT(Offset, &gtk_text_buffer_get_iter_at_offset); }
  { PUBLIC_TEXT_AUDIT(Line, &gtk_text_buffer_get_iter_at_line_offset); }
  { PUBLIC_TEXT_AUDIT(Line, &gtk_text_buffer_get_iter_at_line_index); }
  { PUBLIC_TEXT_AUDIT(Mark, &gtk_text_buffer_get_iter_at_mark); }
  { PUBLIC_TEXT_AUDIT(Tags, &gtk_text_iter_get_tags); }
  { PUBLIC_TEXT_AUDIT(Toggle, &gtk_text_iter_forward_to_tag_toggle); }
  { PUBLIC_TEXT_AUDIT(Slice, &gtk_text_iter_get_slice); }
  { PUBLIC_TEXT_AUDIT(Visible, &gtk_text_view_get_visible_rect); }
  { PUBLIC_TEXT_AUDIT(Location, &gtk_text_view_get_iter_location); }
  { PUBLIC_TEXT_AUDIT(AtLocation, &gtk_text_view_get_iter_at_location); }
  { PUBLIC_TEXT_AUDIT(YRange, &gtk_text_view_get_line_yrange); }
  { PUBLIC_TEXT_AUDIT(AtY, &gtk_text_view_get_line_at_y); }
  { PUBLIC_TEXT_AUDIT(Coords, &gtk_text_view_buffer_to_window_coords); }
  { PUBLIC_TEXT_AUDIT(Coords, &gtk_text_view_window_to_buffer_coords); }
  { PUBLIC_TEXT_AUDIT(IconNew, &gtk_icon_set_new); }
  { PUBLIC_TEXT_AUDIT(IconRef, &gtk_icon_set_ref); }
  { PUBLIC_TEXT_AUDIT(IconUnref, &gtk_icon_set_unref); }
#undef PUBLIC_TEXT_AUDIT
  gint x = 0, y = 0;
  coords((GtkTextView *)(guintptr)0xb1, GTK_TEXT_WINDOW_TEXT, -71, -72, &x, &y);
  return x == -81 && y == -82 && sizeof(GtkIconSet *) == sizeof(gpointer);
}
size_t nim_gtk2_public_iter_anchor_storage_abi(guint index) {
  static const size_t layout[] = { sizeof(GtkTextIter), __alignof__(GtkTextIter),
    sizeof(GtkTextChildAnchor), offsetof(GtkTextChildAnchor, segment), sizeof(GtkTextChildAnchorClass) };
  return index < G_N_ELEMENTS(layout) ? layout[index] : 0;
}
gboolean nim_gtk2_public_line_paths_abi(gunichar (*character)(const GtkTextIter *)) {
  typedef GtkTextIter *(*Copy)(const GtkTextIter *);
  typedef void (*Free)(GtkTextIter *);
  typedef GSList *(*Marks)(const GtkTextIter *);
  typedef GSList *(*Toggled)(const GtkTextIter *, gboolean);
  typedef gint (*Count)(const GtkTextIter *);
  typedef gboolean (*Move)(GtkTextIter *);
  typedef gunichar (*Character)(const GtkTextIter *);
  typedef GList *(*Widgets)(GtkTextChildAnchor *);
  typedef gboolean (*DisplayMove)(GtkTextView *, GtkTextIter *);
  typedef gboolean (*DisplayStart)(GtkTextView *, const GtkTextIter *);
#define LINE_PUBLIC_AUDIT(TYPE, EXPR) typedef char signature[__builtin_types_compatible_p(TYPE, __typeof__(EXPR)) ? 1 : -1]; (void)sizeof(signature)
  { LINE_PUBLIC_AUDIT(Copy, &gtk_text_iter_copy); }
  { LINE_PUBLIC_AUDIT(Free, &gtk_text_iter_free); }
  { LINE_PUBLIC_AUDIT(Marks, &gtk_text_iter_get_marks); }
  { LINE_PUBLIC_AUDIT(Toggled, &gtk_text_iter_get_toggled_tags); }
  { LINE_PUBLIC_AUDIT(Count, &gtk_text_iter_get_chars_in_line); }
  { LINE_PUBLIC_AUDIT(Count, &gtk_text_iter_get_bytes_in_line); }
  { LINE_PUBLIC_AUDIT(Move, &gtk_text_iter_forward_to_line_end); }
  { LINE_PUBLIC_AUDIT(Character, &gtk_text_iter_get_char); }
  { LINE_PUBLIC_AUDIT(Widgets, &gtk_text_child_anchor_get_widgets); }
  { LINE_PUBLIC_AUDIT(DisplayMove, &gtk_text_view_forward_display_line); }
  { LINE_PUBLIC_AUDIT(DisplayMove, &gtk_text_view_backward_display_line); }
  { LINE_PUBLIC_AUDIT(DisplayMove, &gtk_text_view_forward_display_line_end); }
  { LINE_PUBLIC_AUDIT(DisplayMove, &gtk_text_view_backward_display_line_start); }
  { LINE_PUBLIC_AUDIT(DisplayStart, &gtk_text_view_starts_display_line); }
#undef LINE_PUBLIC_AUDIT
  return character((const GtkTextIter *)(guintptr)0xa1) == 0x1f642;
}
size_t nim_gtk2_buffer_storage_abi(guint index) {
  static const size_t layout[] = { sizeof(GtkTextBuffer), offsetof(GtkTextBuffer, tag_table),
    offsetof(GtkTextBuffer, btree), offsetof(GtkTextBuffer, clipboard_contents_buffers),
    offsetof(GtkTextBuffer, selection_clipboards), offsetof(GtkTextBuffer, log_attr_cache),
    offsetof(GtkTextBuffer, user_action_count), offsetof(GtkTextBuffer, user_action_count) + sizeof(guint),
    sizeof(GtkTextBufferClass), offsetof(GtkTextBufferClass, insert_text),
    offsetof(GtkTextBufferClass, insert_pixbuf), offsetof(GtkTextBufferClass, insert_child_anchor),
    offsetof(GtkTextBufferClass, delete_range), offsetof(GtkTextBufferClass, changed),
    offsetof(GtkTextBufferClass, modified_changed), offsetof(GtkTextBufferClass, mark_set),
    offsetof(GtkTextBufferClass, mark_deleted), offsetof(GtkTextBufferClass, apply_tag),
    offsetof(GtkTextBufferClass, remove_tag), offsetof(GtkTextBufferClass, begin_user_action),
    offsetof(GtkTextBufferClass, end_user_action), offsetof(GtkTextBufferClass, paste_done) };
  return index < G_N_ELEMENTS(layout) ? layout[index] : 0;
}
gboolean nim_gtk2_buffer_api_abi(GtkTextBufferClass *klass) {
  typedef gboolean (*Get)(GtkTextBuffer *);
  typedef void (*Set)(GtkTextBuffer *, gboolean);
  typedef void (*Cursor)(GtkTextBuffer *, const GtkTextIter *);
  typedef void (*Select)(GtkTextBuffer *, const GtkTextIter *, const GtkTextIter *);
  typedef gboolean (*Bounds)(GtkTextBuffer *, GtkTextIter *, GtkTextIter *);
  typedef void (*Action)(GtkTextBuffer *);
  typedef void (*Text)(GtkTextBuffer *, const gchar *, gint);
  typedef void (*Insert)(GtkTextBuffer *, GtkTextIter *, const gchar *, gint);
  typedef void (*Delete)(GtkTextBuffer *, GtkTextIter *, GtkTextIter *);
  typedef gboolean (*DeleteSelection)(GtkTextBuffer *, gboolean, gboolean);
  typedef void (*MarkSet)(GtkTextBuffer *, const GtkTextIter *, GtkTextMark *);
  typedef void (*PasteDone)(GtkTextBuffer *, GtkClipboard *);
#define BUFFER_AUDIT(TYPE, EXPR) typedef char signature[__builtin_types_compatible_p(TYPE, __typeof__(EXPR)) ? 1 : -1]; (void)sizeof(signature)
  { BUFFER_AUDIT(Get, &gtk_text_buffer_get_modified); }
  { BUFFER_AUDIT(Set, &gtk_text_buffer_set_modified); }
  { BUFFER_AUDIT(Get, &gtk_text_buffer_get_has_selection); }
  { BUFFER_AUDIT(Cursor, &gtk_text_buffer_place_cursor); }
  { BUFFER_AUDIT(Select, &gtk_text_buffer_select_range); }
  { BUFFER_AUDIT(Bounds, &gtk_text_buffer_get_selection_bounds); }
  { BUFFER_AUDIT(Action, &gtk_text_buffer_begin_user_action); }
  { BUFFER_AUDIT(Action, &gtk_text_buffer_end_user_action); }
  { BUFFER_AUDIT(Text, &gtk_text_buffer_set_text); }
  { BUFFER_AUDIT(Text, &gtk_text_buffer_insert_at_cursor); }
  { BUFFER_AUDIT(Insert, &gtk_text_buffer_insert); }
  { BUFFER_AUDIT(Insert, klass->insert_text); }
  { BUFFER_AUDIT(Delete, &gtk_text_buffer_delete); }
  { BUFFER_AUDIT(DeleteSelection, &gtk_text_buffer_delete_selection); }
  { BUFFER_AUDIT(MarkSet, klass->mark_set); }
  { BUFFER_AUDIT(PasteDone, klass->paste_done); }
#undef BUFFER_AUDIT
  klass->insert_text((GtkTextBuffer *)(guintptr)0xe1, (GtkTextIter *)(guintptr)0xe2, "x", -99);
  klass->mark_set((GtkTextBuffer *)(guintptr)0xe1, (GtkTextIter *)(guintptr)0xe2, (GtkTextMark *)(guintptr)0xe3);
  klass->paste_done((GtkTextBuffer *)(guintptr)0xe1, (GtkClipboard *)(guintptr)0xe4);
  return TRUE;
}
size_t nim_gtk2_tag_storage_abi(guint index) {
  static const size_t layout[] = { sizeof(GtkTextTag), offsetof(GtkTextTag, table),
    offsetof(GtkTextTag, name), offsetof(GtkTextTag, priority), offsetof(GtkTextTag, values),
    sizeof(GtkTextTagClass), offsetof(GtkTextTagClass, event), sizeof(GtkTextTagTable),
    sizeof(GtkTextTagTableClass), offsetof(GtkTextTagTableClass, tag_changed),
    offsetof(GtkTextTagTableClass, tag_added), offsetof(GtkTextTagTableClass, tag_removed) };
  return index < G_N_ELEMENTS(layout) ? layout[index] : 0;
}
gboolean nim_gtk2_tag_api_abi(gboolean (*event)(GtkTextTag *, GObject *, GdkEvent *, const GtkTextIter *)) {
  typedef GtkTextTag *(*New)(const gchar *);
  typedef gint (*Priority)(GtkTextTag *);
  typedef void (*SetPriority)(GtkTextTag *, gint);
  typedef gboolean (*Event)(GtkTextTag *, GObject *, GdkEvent *, const GtkTextIter *);
  typedef void (*AddRemove)(GtkTextTagTable *, GtkTextTag *);
  typedef GtkTextTag *(*Lookup)(GtkTextTagTable *, const gchar *);
  typedef gint (*Size)(GtkTextTagTable *);
  typedef void (*Foreach)(GtkTextTagTable *, GtkTextTagTableForeach, gpointer);
#define TAG_AUDIT(TYPE, EXPR) typedef char signature[__builtin_types_compatible_p(TYPE, __typeof__(EXPR)) ? 1 : -1]; (void)sizeof(signature)
  { TAG_AUDIT(New, &gtk_text_tag_new); }
  { TAG_AUDIT(Priority, &gtk_text_tag_get_priority); }
  { TAG_AUDIT(SetPriority, &gtk_text_tag_set_priority); }
  { TAG_AUDIT(Event, &gtk_text_tag_event); }
  { TAG_AUDIT(Event, ((GtkTextTagClass *)0)->event); }
  { TAG_AUDIT(AddRemove, &gtk_text_tag_table_add); }
  { TAG_AUDIT(AddRemove, &gtk_text_tag_table_remove); }
  { TAG_AUDIT(Lookup, &gtk_text_tag_table_lookup); }
  { TAG_AUDIT(Size, &gtk_text_tag_table_get_size); }
  { TAG_AUDIT(Foreach, &gtk_text_tag_table_foreach); }
#undef TAG_AUDIT
  GdkEvent native_event = {0}; GtkTextIter iter;
  native_event.type = GDK_BUTTON_PRESS;
  return event((GtkTextTag *)(guintptr)0xf5, (GObject *)(guintptr)0xf6, &native_event, &iter) == -123;
}
size_t nim_gtk2_tag_table_storage_abi(guint index) {
  static const size_t layout[] = { offsetof(GtkTextTagTable, hash),
    offsetof(GtkTextTagTable, anonymous), offsetof(GtkTextTagTable, anon_count),
    offsetof(GtkTextTagTable, buffers) };
  return index < G_N_ELEMENTS(layout) ? layout[index] : 0;
}
gboolean nim_gtk2_tag_table_api_abi(GtkTextTagTableClass *klass, GtkTextTagTableForeach visit) {
  typedef GType (*Type)(void) G_GNUC_CONST;
  typedef GtkTextTagTable *(*New)(void);
  typedef GtkTextBuffer *(*BufferNew)(GtkTextTagTable *);
  typedef GtkTextTagTable *(*BufferTable)(GtkTextBuffer *);
  typedef void (*Changed)(GtkTextTagTable *, GtkTextTag *, gboolean);
  typedef void (*AddedRemoved)(GtkTextTagTable *, GtkTextTag *);
#define TABLE_AUDIT(TYPE, EXPR) typedef char signature[__builtin_types_compatible_p(TYPE, __typeof__(EXPR)) ? 1 : -1]; (void)sizeof(signature)
  { TABLE_AUDIT(Type, &gtk_text_tag_table_get_type); }
  { TABLE_AUDIT(New, &gtk_text_tag_table_new); }
  { TABLE_AUDIT(BufferNew, &gtk_text_buffer_new); }
  { TABLE_AUDIT(BufferTable, &gtk_text_buffer_get_tag_table); }
  { TABLE_AUDIT(Changed, klass->tag_changed); }
  { TABLE_AUDIT(AddedRemoved, klass->tag_added); }
  { TABLE_AUDIT(AddedRemoved, klass->tag_removed); }
#undef TABLE_AUDIT
  klass->tag_changed((GtkTextTagTable *)(guintptr)0xc1, (GtkTextTag *)(guintptr)0xc2, -93);
  klass->tag_added((GtkTextTagTable *)(guintptr)0xc1, (GtkTextTag *)(guintptr)0xc2);
  klass->tag_removed((GtkTextTagTable *)(guintptr)0xc1, (GtkTextTag *)(guintptr)0xc2);
  visit((GtkTextTag *)(guintptr)0xc2, (gpointer)(guintptr)0xc3);
  return TRUE;
}
size_t nim_gtk2_attributes_storage_abi(guint index) {
  static const size_t layout[] = { sizeof(GtkTextAppearance), offsetof(GtkTextAppearance, rise),
    offsetof(GtkTextAppearance, padding1), sizeof(GtkTextAttributes),
    offsetof(GtkTextAttributes, appearance), offsetof(GtkTextAttributes, font),
    offsetof(GtkTextAttributes, font_scale), offsetof(GtkTextAttributes, tabs),
    offsetof(GtkTextAttributes, language), offsetof(GtkTextAttributes, pg_bg_color) };
  return index < G_N_ELEMENTS(layout) ? layout[index] : 0;
}
gboolean nim_gtk2_attributes_api_abi(GtkTextAttributes *(*ref)(GtkTextAttributes *)) {
  typedef GtkTextAttributes *(*New)(void);
  typedef GType (*Type)(void) G_GNUC_CONST;
  typedef GtkTextAttributes *(*CopyRef)(GtkTextAttributes *);
  typedef void (*CopyValues)(GtkTextAttributes *, GtkTextAttributes *);
  typedef void (*Unref)(GtkTextAttributes *);
  typedef gboolean (*Iter)(const GtkTextIter *, GtkTextAttributes *);
  typedef GtkTextAttributes *(*Defaults)(GtkTextView *);
#define ATTR_AUDIT(TYPE, EXPR) typedef char signature[__builtin_types_compatible_p(TYPE, __typeof__(EXPR)) ? 1 : -1]; (void)sizeof(signature)
  { ATTR_AUDIT(New, &gtk_text_attributes_new); }
  { ATTR_AUDIT(Type, &gtk_text_attributes_get_type); }
  { ATTR_AUDIT(CopyRef, &gtk_text_attributes_copy); }
  { ATTR_AUDIT(CopyRef, &gtk_text_attributes_ref); }
  { ATTR_AUDIT(CopyValues, &gtk_text_attributes_copy_values); }
  { ATTR_AUDIT(Unref, &gtk_text_attributes_unref); }
  { ATTR_AUDIT(Iter, &gtk_text_iter_get_attributes); }
  { ATTR_AUDIT(Defaults, &gtk_text_view_get_default_attributes); }
#undef ATTR_AUDIT
  return ref((GtkTextAttributes *)(guintptr)0xf4) == (GtkTextAttributes *)(guintptr)0xf4;
}
size_t nim_gtk2_textmark_storage_abi(guint index) {
  static const size_t layout[] = { sizeof(GtkTextMark), offsetof(GtkTextMark, segment), sizeof(GtkTextMarkClass) };
  return index < G_N_ELEMENTS(layout) ? layout[index] : 0;
}
gboolean nim_gtk2_textmark_api_abi(GtkTextMark *(*make)(const gchar *, gboolean)) {
  typedef GtkTextMark *(*New)(const gchar *, gboolean);
  typedef void (*Add)(GtkTextBuffer *, GtkTextMark *, const GtkTextIter *);
  typedef void (*Visible)(GtkTextMark *, gboolean);
  typedef gboolean (*BoolGet)(GtkTextMark *);
  typedef const gchar *(*Name)(GtkTextMark *);
  typedef GtkTextBuffer *(*Buffer)(GtkTextMark *);
#define MARK_AUDIT(TYPE, EXPR) typedef char signature[__builtin_types_compatible_p(TYPE, __typeof__(EXPR)) ? 1 : -1]; (void)sizeof(signature)
  { MARK_AUDIT(New, &gtk_text_mark_new); }
  { MARK_AUDIT(Add, &gtk_text_buffer_add_mark); }
  { MARK_AUDIT(Visible, &gtk_text_mark_set_visible); }
  { MARK_AUDIT(BoolGet, &gtk_text_mark_get_visible); }
  { MARK_AUDIT(BoolGet, &gtk_text_mark_get_deleted); }
  { MARK_AUDIT(BoolGet, &gtk_text_mark_get_left_gravity); }
  { MARK_AUDIT(Name, &gtk_text_mark_get_name); }
  { MARK_AUDIT(Buffer, &gtk_text_mark_get_buffer); }
#undef MARK_AUDIT
  return make("mark-abi", -123) == (GtkTextMark *)(guintptr)0xf3;
}
size_t nim_gtk2_textview_storage_abi(guint index) {
  static const size_t layout[] = {
    sizeof(GtkTextView), offsetof(GtkTextView, buffer), offsetof(GtkTextView, tabs),
    offsetof(GtkTextView, text_window), offsetof(GtkTextView, hadjustment),
    offsetof(GtkTextView, im_context), offsetof(GtkTextView, pending_place_cursor_button),
    sizeof(GtkTextViewClass), offsetof(GtkTextViewClass, set_scroll_adjustments),
    offsetof(GtkTextViewClass, backspace), offsetof(GtkTextViewClass, cut_clipboard),
    offsetof(GtkTextViewClass, copy_clipboard), offsetof(GtkTextViewClass, paste_clipboard),
    offsetof(GtkTextViewClass, toggle_overwrite), offsetof(GtkTextViewClass, move_focus)
  };
  return index < G_N_ELEMENTS(layout) ? layout[index] : 0;
}
gboolean nim_gtk2_textview_policy_abi(void (*focus)(GtkTextView *, GtkDirectionType)) {
  typedef void (*Set)(GtkTextView *, gboolean);
  typedef gboolean (*Get)(GtkTextView *);
  typedef void (*Action)(GtkTextView *);
  typedef void (*Focus)(GtkTextView *, GtkDirectionType);
#define VIEW_AUDIT(TYPE, EXPR) typedef char signature[__builtin_types_compatible_p(TYPE, __typeof__(EXPR)) ? 1 : -1]; (void)sizeof(signature)
  { VIEW_AUDIT(Set, &gtk_text_view_set_editable); }
  { VIEW_AUDIT(Get, &gtk_text_view_get_editable); }
  { VIEW_AUDIT(Set, &gtk_text_view_set_cursor_visible); }
  { VIEW_AUDIT(Get, &gtk_text_view_get_cursor_visible); }
  { VIEW_AUDIT(Set, &gtk_text_view_set_accepts_tab); }
  { VIEW_AUDIT(Get, &gtk_text_view_get_accepts_tab); }
  { VIEW_AUDIT(Set, &gtk_text_view_set_overwrite); }
  { VIEW_AUDIT(Get, &gtk_text_view_get_overwrite); }
  { VIEW_AUDIT(Action, ((GtkTextViewClass *)0)->backspace); }
  { VIEW_AUDIT(Action, ((GtkTextViewClass *)0)->cut_clipboard); }
  { VIEW_AUDIT(Focus, ((GtkTextViewClass *)0)->move_focus); }
#undef VIEW_AUDIT
  focus((GtkTextView *)(guintptr)0xf2, GTK_DIR_LEFT);
  return sizeof(GtkDirectionType) == sizeof(gint);
}
size_t nim_gtk2_entry_storage_abi(guint index) {
  static const size_t layout[] = {
    sizeof(GtkEntry), offsetof(GtkEntry, text_area), offsetof(GtkEntry, current_pos),
    offsetof(GtkEntry, cached_layout), offsetof(GtkEntry, button),
    offsetof(GtkEntry, invisible_char), offsetof(GtkEntry, width_chars),
    sizeof(GtkEntryClass), offsetof(GtkEntryClass, populate_popup),
    offsetof(GtkEntryClass, backspace), offsetof(GtkEntryClass, cut_clipboard),
    offsetof(GtkEntryClass, copy_clipboard), offsetof(GtkEntryClass, paste_clipboard),
    offsetof(GtkEntryClass, toggle_overwrite), offsetof(GtkEntryClass, get_text_area_size)
  };
  return index < G_N_ELEMENTS(layout) ? layout[index] : 0;
}
gboolean nim_gtk2_entry_public_bool_abi(void (*area)(GtkEntry *, gint *, gint *, gint *, gint *)) {
  typedef void (*EditableSet)(GtkEditable *, gboolean);
  typedef gboolean (*EditableGet)(GtkEditable *);
  typedef void (*EntrySet)(GtkEntry *, gboolean);
  typedef gboolean (*EntryGet)(GtkEntry *);
  typedef void (*EntryAction)(GtkEntry *);
  typedef void (*EntryArea)(GtkEntry *, gint *, gint *, gint *, gint *);
#define ENTRY_AUDIT(TYPE, EXPR) typedef char signature[__builtin_types_compatible_p(TYPE, __typeof__(EXPR)) ? 1 : -1]; (void)sizeof(signature)
  { ENTRY_AUDIT(EditableSet, &gtk_editable_set_editable); }
  { ENTRY_AUDIT(EditableGet, &gtk_editable_get_editable); }
  { ENTRY_AUDIT(EntrySet, &gtk_entry_set_visibility); }
  { ENTRY_AUDIT(EntryGet, &gtk_entry_get_visibility); }
  { ENTRY_AUDIT(EntryAction, ((GtkEntryClass *)0)->backspace); }
  { ENTRY_AUDIT(EntryAction, ((GtkEntryClass *)0)->cut_clipboard); }
  { ENTRY_AUDIT(EntryArea, ((GtkEntryClass *)0)->get_text_area_size); }
#undef ENTRY_AUDIT
  gint x = 0, y = 0, width = 0, height = 0;
  area((GtkEntry *)(guintptr)0xf1, &x, &y, &width, &height);
  return x == -123 && y == 17 && width == 300 && height == 40;
}
gboolean nim_gtk2_entry_progress_abi(gdouble (*value)(GtkEntry *, gdouble), void (*pulse)(GtkEntry *)) {
  typedef void (*Set)(GtkEntry *, gdouble);
  typedef gdouble (*Get)(GtkEntry *);
  typedef void (*Pulse)(GtkEntry *);
#define PROGRESS_PROTO(TYPE, FN) typedef char FN##_signature[__builtin_types_compatible_p(TYPE, __typeof__(&FN)) ? 1 : -1]; (void)sizeof(FN##_signature)
  PROGRESS_PROTO(Set, gtk_entry_set_progress_fraction);
  PROGRESS_PROTO(Get, gtk_entry_get_progress_fraction);
  PROGRESS_PROTO(Set, gtk_entry_set_progress_pulse_step);
  PROGRESS_PROTO(Get, gtk_entry_get_progress_pulse_step);
  PROGRESS_PROTO(Pulse, gtk_entry_progress_pulse);
#undef PROGRESS_PROTO
  pulse((GtkEntry *)(guintptr)0xe2);
  return sizeof(gdouble) == 8 && value((GtkEntry *)(guintptr)0xe1, 0.1234567890123) == 0.9876543210123;
}
typedef gunichar (*NimEntryMaskPolicy)(GtkEntry *, gunichar);
gboolean nim_gtk2_entry_editing_abi(NimEntryMaskPolicy mask) {
  typedef void (*BoolSet)(GtkEntry *, gboolean);
  typedef gboolean (*BoolGet)(GtkEntry *);
  typedef void (*MaskSet)(GtkEntry *, gunichar);
  typedef gunichar (*MaskGet)(GtkEntry *);
  typedef void (*Unset)(GtkEntry *);
#define EDIT_PROTO(TYPE, FN) typedef char FN##_signature[__builtin_types_compatible_p(TYPE, __typeof__(&FN)) ? 1 : -1]; (void)sizeof(FN##_signature)
  EDIT_PROTO(BoolSet, gtk_entry_set_overwrite_mode);
  EDIT_PROTO(BoolGet, gtk_entry_get_overwrite_mode);
  EDIT_PROTO(BoolSet, gtk_entry_set_has_frame);
  EDIT_PROTO(BoolGet, gtk_entry_get_has_frame);
  EDIT_PROTO(MaskSet, gtk_entry_set_invisible_char);
  EDIT_PROTO(MaskGet, gtk_entry_get_invisible_char);
  EDIT_PROTO(Unset, gtk_entry_unset_invisible_char);
  EDIT_PROTO(BoolSet, gtk_entry_set_visibility);
  EDIT_PROTO(BoolGet, gtk_entry_get_visibility);
#undef EDIT_PROTO
  return sizeof(gunichar) == 4 && mask((GtkEntry *)(guintptr)0xb1, 0x1f512) == 0x10ffff;
}
typedef void (*NimEntryIconSignal)(GtkEntry *, GtkEntryIconPosition, GdkEvent *, gpointer);
gboolean nim_gtk2_entry_icon_abi(NimEntryIconSignal fn) {
  typedef void (*PixbufSet)(GtkEntry *, GtkEntryIconPosition, GdkPixbuf *);
  typedef void (*NameSet)(GtkEntry *, GtkEntryIconPosition, const gchar *);
  typedef const gchar *(*NameGet)(GtkEntry *, GtkEntryIconPosition);
  typedef gchar *(*TooltipGet)(GtkEntry *, GtkEntryIconPosition);
  typedef GdkPixbuf *(*PixbufGet)(GtkEntry *, GtkEntryIconPosition);
  typedef GtkImageType (*StorageGet)(GtkEntry *, GtkEntryIconPosition);
  typedef void (*BoolSet)(GtkEntry *, GtkEntryIconPosition, gboolean);
  typedef gboolean (*BoolGet)(GtkEntry *, GtkEntryIconPosition);
  typedef GdkWindow *(*WindowGet)(GtkEntry *, GtkEntryIconPosition);
  typedef gboolean (*WidgetSensitive)(GtkWidget *);
#define ICON_PROTO(TYPE, FN) typedef char FN##_signature[__builtin_types_compatible_p(TYPE, __typeof__(&FN)) ? 1 : -1]; (void)sizeof(FN##_signature)
  ICON_PROTO(PixbufSet, gtk_entry_set_icon_from_pixbuf);
  ICON_PROTO(NameSet, gtk_entry_set_icon_from_icon_name);
  ICON_PROTO(NameGet, gtk_entry_get_icon_name);
  ICON_PROTO(PixbufGet, gtk_entry_get_icon_pixbuf);
  ICON_PROTO(StorageGet, gtk_entry_get_icon_storage_type);
  ICON_PROTO(NameSet, gtk_entry_set_icon_tooltip_text);
  ICON_PROTO(TooltipGet, gtk_entry_get_icon_tooltip_text);
  ICON_PROTO(BoolSet, gtk_entry_set_icon_sensitive);
  ICON_PROTO(BoolGet, gtk_entry_get_icon_sensitive);
  ICON_PROTO(BoolSet, gtk_entry_set_icon_activatable);
  ICON_PROTO(BoolGet, gtk_entry_get_icon_activatable);
  ICON_PROTO(WindowGet, gtk_entry_get_icon_window);
  ICON_PROTO(WidgetSensitive, gtk_widget_is_sensitive);
#undef ICON_PROTO
  GdkEventButton event = {0};
  event.type = GDK_3BUTTON_PRESS; event.button = G_MAXUINT; event.time = G_MAXUINT32;
  event.x = 1.25; event.y = -2.5; event.x_root = 123.5; event.y_root = 456.25;
  event.state = GDK_CONTROL_MASK;
  fn((GtkEntry *)(guintptr)0xa1, GTK_ENTRY_ICON_SECONDARY, (GdkEvent *)&event, (gpointer)(guintptr)0xa2);
  return sizeof(GtkEntryIconPosition) == sizeof(gint) && GTK_ENTRY_ICON_PRIMARY == 0 && GTK_ENTRY_ICON_SECONDARY == 1;
}
typedef gfloat (*NimEntryFloatPolicy)(GtkEntry *, gfloat);
typedef gboolean (*NimEntryBoolPolicy)(GtkEntry *, gboolean);
gboolean nim_gtk2_entry_policy_abi(NimEntryFloatPolicy align, NimEntryBoolPolicy activate) {
  typedef void (*IntSet)(GtkEntry *, gint);
  typedef gint (*IntGet)(GtkEntry *);
  typedef void (*FloatSet)(GtkEntry *, gfloat);
  typedef gfloat (*FloatGet)(GtkEntry *);
  typedef void (*BoolSet)(GtkEntry *, gboolean);
  typedef gboolean (*BoolGet)(GtkEntry *);
  typedef char max_set[__builtin_types_compatible_p(IntSet, __typeof__(&gtk_entry_set_max_length)) ? 1 : -1];
  typedef char max_get[__builtin_types_compatible_p(IntGet, __typeof__(&gtk_entry_get_max_length)) ? 1 : -1];
  typedef char width_set[__builtin_types_compatible_p(IntSet, __typeof__(&gtk_entry_set_width_chars)) ? 1 : -1];
  typedef char width_get[__builtin_types_compatible_p(IntGet, __typeof__(&gtk_entry_get_width_chars)) ? 1 : -1];
  typedef char align_set[__builtin_types_compatible_p(FloatSet, __typeof__(&gtk_entry_set_alignment)) ? 1 : -1];
  typedef char align_get[__builtin_types_compatible_p(FloatGet, __typeof__(&gtk_entry_get_alignment)) ? 1 : -1];
  typedef char activate_set[__builtin_types_compatible_p(BoolSet, __typeof__(&gtk_entry_set_activates_default)) ? 1 : -1];
  typedef char activate_get[__builtin_types_compatible_p(BoolGet, __typeof__(&gtk_entry_get_activates_default)) ? 1 : -1];
  (void)sizeof(max_set); (void)sizeof(max_get); (void)sizeof(width_set); (void)sizeof(width_get);
  (void)sizeof(align_set); (void)sizeof(align_get); (void)sizeof(activate_set); (void)sizeof(activate_get);
  return align((GtkEntry *)(guintptr)0x91, 0.25f) == 0.75f &&
    activate((GtkEntry *)(guintptr)0x92, -123) == 17;
}
typedef void (*NimEntrySelectionNotify)(GObject *, GParamSpec *, gpointer);
void nim_gtk2_entry_selection_notify_abi(NimEntrySelectionNotify fn, GClosureNotify release) {
  typedef void (*Notify)(GObject *, GParamSpec *);
  typedef char notify_signature[__builtin_types_compatible_p(Notify,
    __typeof__(((GObjectClass *)0)->notify)) ? 1 : -1];
  (void)sizeof(notify_signature);
  fn((GObject *)(guintptr)0x81, (GParamSpec *)(guintptr)0x82, (gpointer)(guintptr)0x83);
  release((gpointer)(guintptr)0x83, (GClosure *)(guintptr)0x84);
}
typedef gboolean (*NimEditableBounds)(GtkEditable *, gint *, gint *);
gboolean nim_gtk2_editable_selection_abi(NimEditableBounds fn) {
  typedef void (*Select)(GtkEditable *, gint, gint);
  typedef gint (*Position)(GtkEditable *);
  typedef gchar *(*Chars)(GtkEditable *, gint, gint);
  typedef char select_signature[__builtin_types_compatible_p(Select,
    __typeof__(&gtk_editable_select_region)) ? 1 : -1];
  typedef char position_signature[__builtin_types_compatible_p(Position,
    __typeof__(&gtk_editable_get_position)) ? 1 : -1];
  typedef char bounds_signature[__builtin_types_compatible_p(NimEditableBounds,
    __typeof__(&gtk_editable_get_selection_bounds)) ? 1 : -1];
  typedef char chars_signature[__builtin_types_compatible_p(Chars,
    __typeof__(&gtk_editable_get_chars)) ? 1 : -1];
  gint first = 0, last = 0;
  (void)sizeof(select_signature); (void)sizeof(position_signature);
  (void)sizeof(bounds_signature); (void)sizeof(chars_signature);
  return fn((GtkEditable *)(guintptr)0x71, &first, &last) == 17 &&
    first == -123 && last == G_MAXINT;
}
typedef void (*NimCompletionActionSignal)(GtkEntryCompletion *, gint, gpointer);
void nim_gtk2_completion_action_abi(NimCompletionActionSignal fn) {
  typedef void (*Insert)(GtkEntryCompletion *, gint, const gchar *);
  typedef void (*Delete)(GtkEntryCompletion *, gint);
  typedef char insert_signature[__builtin_types_compatible_p(Insert,
    __typeof__(&gtk_entry_completion_insert_action_text)) ? 1 : -1];
  typedef char delete_signature[__builtin_types_compatible_p(Delete,
    __typeof__(&gtk_entry_completion_delete_action)) ? 1 : -1];
  (void)sizeof(insert_signature); (void)sizeof(delete_signature);
  fn((GtkEntryCompletion *)(guintptr)0x61, G_MININT, (gpointer)(guintptr)0x62);
}
typedef void (*NimCompletionSetMatch)(GtkEntryCompletion *, GtkEntryCompletionMatchFunc,
  gpointer, GDestroyNotify);
gboolean nim_gtk2_completion_match_abi(GtkEntryCompletionMatchFunc fn, GDestroyNotify destroy) {
  typedef char signature[__builtin_types_compatible_p(NimCompletionSetMatch,
    __typeof__(&gtk_entry_completion_set_match_func)) ? 1 : -1];
  gboolean matched;
  (void)sizeof(signature);
  matched = fn((GtkEntryCompletion *)(guintptr)0x51, "native-key",
    (GtkTreeIter *)(guintptr)0x52, (gpointer)(guintptr)0x53);
  destroy((gpointer)(guintptr)0x53);
  return matched == 17;
}
typedef gboolean (*NimCompletionPrefix)(GtkEntryCompletion *, const gchar *, gpointer);
typedef gboolean (*NimCompletionCursor)(GtkEntryCompletion *, GtkTreeModel *, GtkTreeIter *, gpointer);
typedef const gchar *(*NimCompletionKey)(GtkEntryCompletion *);
gboolean nim_gtk2_inline_completion_abi(NimCompletionPrefix prefix,
  NimCompletionCursor cursor, NimCompletionKey key) {
  typedef char signature[__builtin_types_compatible_p(NimCompletionKey,
    __typeof__(&gtk_entry_completion_get_completion_prefix)) ? 1 : -1];
  const gchar *text;
  (void)sizeof(signature);
  if (prefix((GtkEntryCompletion *)(guintptr)0x41, "lambda", (gpointer)(guintptr)0x42) != 17) return FALSE;
  if (cursor((GtkEntryCompletion *)(guintptr)0x41, (GtkTreeModel *)(guintptr)0x43,
    (GtkTreeIter *)(guintptr)0x44, (gpointer)(guintptr)0x42) != 19) return FALSE;
  text = key((GtkEntryCompletion *)(guintptr)0x41);
  return text && text[0] == 'k';
}
typedef GdkAtom (*NimSelectionTarget)(GtkSelectionData *);
gboolean nim_gtk2_rich_clipboard_abi(GtkClipboardGetFunc get, GtkClipboardClearFunc clear,
  NimSelectionTarget target) {
  typedef char signature[__builtin_types_compatible_p(NimSelectionTarget,
    __typeof__(&gtk_selection_data_get_target)) ? 1 : -1];
  guintptr wide = sizeof(guintptr) == 8 ? (guintptr)0x100000063ULL : 0x63;
  (void)sizeof(signature);
  get((GtkClipboard *)(guintptr)0x61, (GtkSelectionData *)(guintptr)0x62,
    G_MAXUINT, (gpointer)(guintptr)0x64);
  clear((GtkClipboard *)(guintptr)0x61, (gpointer)(guintptr)0x64);
  return (guintptr)target((GtkSelectionData *)(guintptr)0x62) == wide;
}
typedef gboolean (*NimTextDeserialize)(GtkTextBuffer *, GtkTextBuffer *, GdkAtom,
  GtkTextIter *, const guint8 *, gsize, GError **);
gboolean nim_gtk2_text_serialization_abi(GtkTextBufferSerializeFunc serialize, NimTextDeserialize deserialize) {
  typedef char signature[__builtin_types_compatible_p(NimTextDeserialize,
    __typeof__(&gtk_text_buffer_deserialize)) ? 1 : -1];
  gsize length = 0, wide = sizeof(gsize) == 8 ? (gsize)0x100000033ULL : 0x33;
  GError *error = NULL;
  guint8 *bytes;
  (void)sizeof(signature);
  bytes = serialize((GtkTextBuffer *)(guintptr)0x51, (GtkTextBuffer *)(guintptr)0x52,
    (const GtkTextIter *)(guintptr)0x53, (const GtkTextIter *)(guintptr)0x54,
    &length, (gpointer)(guintptr)0x55);
  if (bytes != (guint8 *)(guintptr)0x61 || length != wide) return FALSE;
  return deserialize((GtkTextBuffer *)(guintptr)0x51, (GtkTextBuffer *)(guintptr)0x52,
    (GdkAtom)(guintptr)wide, (GtkTextIter *)(guintptr)0x53, bytes, wide, &error) == 17 &&
    error == (GError *)(guintptr)0x71;
}
typedef void (*NimAnchorInsert)(GtkTextBuffer *, GtkTextIter *, GtkTextChildAnchor *);
typedef gboolean (*NimAnchorDeleted)(GtkTextChildAnchor *);
gboolean nim_gtk2_text_anchor_abi(NimAnchorInsert insert, NimAnchorDeleted deleted) {
  typedef char insert_signature[__builtin_types_compatible_p(NimAnchorInsert,
    __typeof__(&gtk_text_buffer_insert_child_anchor)) ? 1 : -1];
  typedef char deleted_signature[__builtin_types_compatible_p(NimAnchorDeleted,
    __typeof__(&gtk_text_child_anchor_get_deleted)) ? 1 : -1];
  (void)sizeof(insert_signature); (void)sizeof(deleted_signature);
  insert((GtkTextBuffer *)(guintptr)0x51, (GtkTextIter *)(guintptr)0x52,
         (GtkTextChildAnchor *)(guintptr)0x53);
  return deleted((GtkTextChildAnchor *)(guintptr)0x53);
}
typedef gboolean (*NimIconCursor)(GtkIconView *, GtkTreePath **, GtkCellRenderer **);
gboolean nim_gtk2_icon_cursor(NimIconCursor fn) {
  GtkTreePath *path = NULL;
  GtkCellRenderer *cell = NULL;
  typedef char signature_check[__builtin_types_compatible_p(NimIconCursor,
    __typeof__(&gtk_icon_view_get_cursor)) ? 1 : -1];
  (void)sizeof(signature_check);
  return fn((GtkIconView *)(guintptr)0x21, &path, &cell) &&
    path == (GtkTreePath *)(guintptr)0x22 && cell == (GtkCellRenderer *)(guintptr)0x23;
}
gint nim_gtk2_model_compare(GtkTreeIterCompareFunc fn, gpointer data) {
  GtkTreeIter a = {0}, b = {0};
  a.stamp = 11; b.stamp = 22;
  return fn((GtkTreeModel *)(guintptr)0x42, &a, &b, data);
}
gboolean nim_gtk2_model_visible(GtkTreeModelFilterVisibleFunc fn, gpointer data) {
  GtkTreeIter iter = {0}; iter.stamp = 11;
  return fn((GtkTreeModel *)(guintptr)0x42, &iter, data);
}
void nim_gtk2_cell_data(GtkTreeCellDataFunc fn, gpointer data) {
  GtkTreeIter iter = {0}; iter.stamp = 11;
  fn((GtkTreeViewColumn *)(guintptr)0x43, (GtkCellRenderer *)(guintptr)0x44,
     (GtkTreeModel *)(guintptr)0x42, &iter, data);
}
typedef gboolean (*NimCompletionSelected)(GtkEntryCompletion *, GtkTreeModel *, GtkTreeIter *, gpointer);
gboolean nim_gtk2_completion_selected(NimCompletionSelected fn, gpointer data) {
  GtkTreeIter iter = {0};
  iter.stamp = 0x123;
  return fn((GtkEntryCompletion *)(guintptr)0x12, (GtkTreeModel *)(guintptr)0x34, &iter, data);
}
typedef GtkRadioAction *(*NimRadioNew)(const gchar *, const gchar *, const gchar *, const gchar *, gint);
GtkRadioAction *nim_gtk2_radio_new(NimRadioNew fn) { return fn("abi-radio", "Radio", NULL, NULL, -123); }
void nim_gtk2_radio_changed(void (*fn)(GtkRadioAction *, GtkRadioAction *, gpointer), gpointer data) {
  fn((GtkRadioAction *)(guintptr)0x12, (GtkRadioAction *)(guintptr)0x34, data);
}
size_t nim_gtk2_ui_item_size(void) { return sizeof(GtkUIManagerItemType); }
typedef guint (*NimUILoad)(GtkUIManager *, const gchar *, gssize, GError **);
guint nim_gtk2_ui_load(NimUILoad fn, GtkUIManager *ui) { return fn(ui, "<ui></ui>", -1, NULL); }
typedef GtkBuilder *(*NimBuilderNew)(void);
typedef guint (*NimBuilderLoad)(GtkBuilder *, const gchar *, gsize, GError **);
GtkBuilder *nim_gtk2_builder_new(NimBuilderNew fn) { return fn(); }
guint nim_gtk2_builder_load(NimBuilderLoad fn, GtkBuilder *builder) {
  const gchar xml[] = "<interface/>";
  return fn(builder, xml, sizeof(xml) - 1, NULL);
}
void nim_gtk2_builder_connect(GtkBuilderConnectFunc fn, gpointer data) {
  fn((GtkBuilder *)(guintptr)0x12, (GObject *)(guintptr)0x23, "clicked", "handler",
     (GObject *)(guintptr)0x34, G_CONNECT_AFTER | G_CONNECT_SWAPPED, data);
}
typedef GtkAction *(*NimActionNew)(const gchar *, const gchar *, const gchar *, const gchar *);
typedef gboolean (*NimActionGetBool)(GtkAction *);
typedef void (*NimActionSetBool)(GtkAction *, gboolean);
GtkAction *nim_gtk2_action_new(NimActionNew fn) { return fn("abi-command", "ABI label", NULL, NULL); }
gboolean nim_gtk2_action_get_bool(NimActionGetBool fn, GtkAction *action) { return fn(action); }
void nim_gtk2_action_set_bool(NimActionSetBool fn, GtkAction *action, gboolean value) { fn(action, value); }
size_t nim_gtk2_sizeof_target_entry(void) { return sizeof(GtkTargetEntry); }
size_t nim_gtk2_target_entry_info_offset(void) { return offsetof(GtkTargetEntry, info); }
size_t nim_gtk2_sizeof_selection_data(void) { return sizeof(GtkSelectionData); }
size_t nim_gtk2_selection_data_length_offset(void) { return offsetof(GtkSelectionData, length); }
size_t nim_gtk2_sizeof_dest_defaults(void) { return sizeof(GtkDestDefaults); }
size_t nim_gtk2_sizeof_drag_action(void) { return sizeof(GdkDragAction); }
void nim_gtk2_invoke_clipboard_text(GtkClipboardTextReceivedFunc fn, gpointer data) {
  fn((GtkClipboard *)(guintptr)0x123, "copied text", data);
}
void nim_gtk2_invoke_clipboard_contents(GtkClipboardReceivedFunc fn, gpointer data) {
  fn((GtkClipboard *)(guintptr)0x123, (GtkSelectionData *)(guintptr)0x234, data);
}
typedef gboolean (*NimDropFunc)(GtkWidget *, GdkDragContext *, gint, gint, guint32, gpointer);
gboolean nim_gtk2_invoke_drop(NimDropFunc fn, gpointer data) {
  return fn(NULL, NULL, -12, 34, 0xfedcba98U, data);
}
size_t nim_gtk2_sizeof_event_key(void) { return sizeof(GdkEventKey); }
size_t nim_gtk2_event_key_code_offset(void) { return offsetof(GdkEventKey, hardware_keycode); }
size_t nim_gtk2_sizeof_event_button(void) { return sizeof(GdkEventButton); }
size_t nim_gtk2_event_button_state_offset(void) { return offsetof(GdkEventButton, state); }
size_t nim_gtk2_sizeof_event_motion(void) { return sizeof(GdkEventMotion); }
size_t nim_gtk2_event_motion_hint_offset(void) { return offsetof(GdkEventMotion, is_hint); }
size_t nim_gtk2_sizeof_event_scroll(void) { return sizeof(GdkEventScroll); }
size_t nim_gtk2_event_scroll_direction_offset(void) { return offsetof(GdkEventScroll, direction); }
size_t nim_gtk2_sizeof_scroll_direction(void) { return sizeof(GdkScrollDirection); }
int nim_gtk2_search_visible_flag(void) { return GTK_TEXT_SEARCH_VISIBLE_ONLY; }
int nim_gtk2_search_text_flag(void) { return GTK_TEXT_SEARCH_TEXT_ONLY; }
size_t nim_gtk2_sizeof_atom(void) { return sizeof(GdkAtom); }
size_t nim_gtk2_sizeof_misc(void) { return sizeof(GtkMisc); }
size_t nim_gtk2_misc_padding_width(void) { return sizeof(((GtkMisc *)0)->xpad); }
size_t nim_gtk2_sizeof_native_window(void) { return sizeof(GdkNativeWindow); }
size_t nim_gtk2_sizeof_event_selection(void) { return sizeof(GdkEventSelection); }
size_t nim_gtk2_requestor_offset(void) { return offsetof(GdkEventSelection, requestor); }
size_t nim_gtk2_sizeof_status_icon(void) { return sizeof(GtkStatusIcon); }
size_t nim_gtk2_sizeof_status_icon_class(void) { return sizeof(GtkStatusIconClass); }
size_t nim_gtk2_sizeof_invisible(void) { return sizeof(GtkInvisible); }
size_t nim_gtk2_sizeof_invisible_class(void) { return sizeof(GtkInvisibleClass); }
#ifdef GDK_WINDOWING_X11
size_t nim_gtk2_sizeof_plug(void) { return sizeof(GtkPlug); }
size_t nim_gtk2_sizeof_plug_class(void) { return sizeof(GtkPlugClass); }
size_t nim_gtk2_sizeof_socket(void) { return sizeof(GtkSocket); }
size_t nim_gtk2_sizeof_socket_class(void) { return sizeof(GtkSocketClass); }
#endif
typedef void (*NimStatusPopup)(GtkStatusIcon *, guint, guint32, gpointer);
void nim_gtk2_invoke_status_popup(NimStatusPopup fn, gpointer data) {
  fn((GtkStatusIcon *)(guintptr)0x123, 7, 0xfedcba98U, data);
}
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
