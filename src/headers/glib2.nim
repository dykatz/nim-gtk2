{.push gcsafe.}

when defined(windows):
  const
    gliblib = "libglib-2.0-0.dll"
    gmodulelib = "libgmodule-2.0-0.dll"
    gobjectlib = "libgobject-2.0-0.dll"
elif defined(macosx):
  const
    gliblib = "libglib-2.0(|.0).dylib"
    gmodulelib = "libgmodule-2.0(|.0).dylib"
    gobjectlib = "libgobject-2.0(|.0).dylib"
else:
  const
    gliblib = "libglib-2.0.so(|.0)"
    gmodulelib = "libgmodule-2.0.so(|.0)"
    gobjectlib = "libgobject-2.0.so(|.0)"
# gthreadlib = "libgthread-2.0.so"

include "glib2/error_types"
include "glib2/type_types"
include "glib2/param_types"
include "glib2/shared_types"
include "glib2/types_types"
include "glib2/quark_types"
include "glib2/valuecollector_types"
include "glib2/type_types_2"
include "glib2/value_types"
include "glib2/dataset_types"
include "glib2/slist_types"
include "glib2/list_types"
include "glib2/param_types_2"
include "glib2/main_types"
include "glib2/core"
include "glib2/type"
include "glib2/type_types_3"
include "glib2/type_2"
include "glib2/enums"
include "glib2/type_3"
include "glib2/shared_types_2"
include "glib2/type_types_4"
include "glib2/type_4"
include "glib2/type_types_5"
include "glib2/type_5"
include "glib2/type_types_6"
include "glib2/type_6"
include "glib2/shared_types_3"
include "glib2/value"
include "glib2/valuearray_types"
include "glib2/valuearray"
include "glib2/value_2"
include "glib2/valuetypes"
include "glib2/type_7"
include "glib2/valuetypes_2"
include "glib2/shared_types_4"
include "glib2/valuetypes_3"
include "glib2/param"
include "glib2/param_types_3"
include "glib2/param_2"
include "glib2/shared_types_5"
include "glib2/param_3"
include "glib2/closure"
include "glib2/closure_types"
include "glib2/closure_2"
include "glib2/shared_types_6"
include "glib2/signal_types"
include "glib2/shared_types_7"
include "glib2/closure_3"
include "glib2/signal_types_2"
include "glib2/closure_4"
include "glib2/signal_types_3"
include "glib2/closure_5"
include "glib2/signal"
include "glib2/shared_types_8"
include "glib2/typeplugin_types"
include "glib2/signal_2"
include "glib2/type_8"
include "glib2/typeplugin"
include "glib2/object_types"
include "glib2/shared_types_9"
include "glib2/typeplugin_2"
include "glib2/object"
include "glib2/shared_types_10"
include "glib2/object_2"
include "glib2/enums_types"
include "glib2/object_3"
include "glib2/enums_2"
include "glib2/shared_types_11"
include "glib2/enums_3"
include "glib2/strfuncs_types"
include "glib2/enums_4"
include "glib2/strfuncs"
include "glib2/utils"
include "glib2/utils_types"
include "glib2/utils_2"
include "glib2/fileutils"
include "glib2/utils_3"
include "glib2/environ"
include "glib2/shared_types_12"
include "glib2/utils_4"
include "glib2/trashstack_types"
include "glib2/trashstack"
include "glib2/hash_types"
include "glib2/shared_types_13"
include "glib2/hash"
include "glib2/dataset"
include "glib2/quark"
include "glib2/dataset_2"
include "glib2/quark_2"
include "glib2/mem_types"
include "glib2/shared_types_14"
include "glib2/mem"
include "glib2/lib_autocleanups"
include "glib2/error"
include "glib2/mem_2"
include "glib2/slist"
include "glib2/list"
include "glib2/shared_types_15"
include "glib2/list_2"
include "glib2/shared_types_16"
include "glib2/list_3"
include "glib2/convert_types"
include "glib2/quark_3"
include "glib2/convert"
include "glib2/shared_types_17"
include "glib2/convert_2"
include "glib2/shared_types_18"
include "glib2/dataset_3"
include "glib2/quark_4"
include "glib2/shared_types_19"
include "glib2/date_types"
include "glib2/date"
include "glib2/date_types_2"
include "glib2/quark_5"
include "glib2/date_types_3"
include "glib2/quark_6"
include "glib2/date_types_4"
include "glib2/date_2"
include "glib2/dir_types"
include "glib2/dir"
include "glib2/fileutils_types"
include "glib2/dir_2"
include "glib2/quark_7"
include "glib2/fileutils_2"
include "glib2/hook_types"
include "glib2/shared_types_20"
include "glib2/hook_types_2"
include "glib2/fileutils_3"
include "glib2/hook"
include "glib2/threadpool_types"
include "glib2/threadpool"
include "glib2/timer_types"
include "glib2/threadpool_2"
include "glib2/timer"
include "glib2/shared_types_21"
include "glib2/unicode_types"
include "glib2/charset"
include "glib2/unicode"
include "glib2/unicode_types_2"
include "glib2/unicode_2"
include "glib2/string_types"
include "glib2/stringchunk_types"
include "glib2/stringchunk"
include "glib2/string"
include "glib2/lib_autocleanups_2"
include "glib2/string_2"
include "glib2/iochannel_types"
include "glib2/quark_8"
include "glib2/iochannel_types_2"
include "glib2/main_types_2"
include "glib2/quark_9"
include "glib2/iochannel_types_3"
include "glib2/quark_10"
include "glib2/iochannel_types_4"
include "glib2/shared_types_22"
include "glib2/quark_11"
include "glib2/iochannel"
include "glib2/messages_types"
include "glib2/iochannel_2"
include "glib2/shared_types_23"
include "glib2/messages"
when false:
  proc g_error*(format: cstring){.varargs.}
  proc g_message*(format: cstring){.varargs.}
  proc g_critical*(format: cstring){.varargs.}
  proc g_warning*(format: cstring){.varargs.}
include "glib2/shared_types_24"
include "glib2/messages_2"
include "glib2/markup_types"
include "glib2/quark_12"
include "glib2/markup"
include "glib2/markup_types_2"
include "glib2/markup_2"
include "glib2/markup_types_3"
include "glib2/markup_3"
include "glib2/node_types"
include "glib2/markup_4"
include "glib2/node_types_2"
include "glib2/shared_types_25"
include "glib2/node"
include "glib2/tree_types"
include "glib2/shared_types_26"
include "glib2/tree"
include "glib2/pattern_types"
include "glib2/pattern"
include "glib2/primes"
include "glib2/qsort"
include "glib2/queue_types"
include "glib2/queue"
include "glib2/rand_types"
include "glib2/rand"
include "glib2/shared_types_27"
include "glib2/rand_2"
include "glib2/scanner_types"
include "glib2/rand_3"
include "glib2/scanner_types_2"
include "glib2/shared_types_28"
include "glib2/rand_4"
include "glib2/scanner"
include "glib2/quark_13"
include "glib2/shell_types"
include "glib2/shell"
include "glib2/quark_14"
include "glib2/spawn_types"
include "glib2/shared_types_29"
include "glib2/quark_15"
include "glib2/spawn"
include "glib2/value_3"
include "glib2/boxed"
include "glib2/valuearray_2"
include "glib2/lib_types"
include "glib2/shared_types_30"
include "glib2/lib_types_2"
include "glib2/marshal"
when false:
  type
    PGArray* = pointer
  proc g_array_append_val*(a: PGArray, v: gpointer): PGArray =
    result = g_array_append_vals(a, addr(v), 1)

  proc g_array_prepend_val*(a: PGArray, v: gpointer): PGArray =
    result = g_array_prepend_vals(a, addr(v), 1)

  proc g_array_insert_val*(a: PGArray, i: guint, v: gpointer): PGArray =
    result = g_array_insert_vals(a, i, addr(v), 1)

  proc g_ptr_array_index*(parray: PGPtrArray, index: guint): gpointer =
    result = cast[Pgpointer](cast[int](parray[].pdata) +
        index * sizeof(gpointer))[]

  proc G_THREAD_ERROR*(): TGQuark =
    result = g_thread_error_quark()

  proc g_mutex_lock*(mutex: PGMutex) =
    if g_threads_got_initialized:
      g_thread_functions_for_glib_use.mutex_lock(mutex)

  proc g_mutex_trylock*(mutex: PGMutex): gboolean =
    if g_threads_got_initialized:
      result = g_thread_functions_for_glib_use.mutex_trylock(mutex)
    else:
      result = true

  proc g_mutex_unlock*(mutex: PGMutex) =
    if g_threads_got_initialized:
      g_thread_functions_for_glib_use.mutex_unlock(mutex)

  proc g_mutex_free*(mutex: PGMutex) =
    if g_threads_got_initialized:
      g_thread_functions_for_glib_use.mutex_free(mutex)

  proc g_cond_wait*(cond: PGCond, mutex: PGMutex) =
    if g_threads_got_initialized:
      g_thread_functions_for_glib_use.cond_wait(cond, mutex)

  proc g_cond_timed_wait*(cond: PGCond, mutex: PGMutex, end_time: PGTimeVal): gboolean =
    if g_threads_got_initialized:
      result = g_thread_functions_for_glib_use.cond_timed_wait(cond, mutex,
          end_time)
    else:
      result = true

  proc g_thread_supported*(): gboolean =
    result = g_threads_got_initialized

  proc g_mutex_new*(): PGMutex =
    result = g_thread_functions_for_glib_use.mutex_new()

  proc g_cond_new*(): PGCond =
    result = g_thread_functions_for_glib_use.cond_new()

  proc g_cond_signal*(cond: PGCond) =
    if g_threads_got_initialized:
      g_thread_functions_for_glib_use.cond_signal(cond)

  proc g_cond_broadcast*(cond: PGCond) =
    if g_threads_got_initialized:
      g_thread_functions_for_glib_use.cond_broadcast(cond)

  proc g_cond_free*(cond: PGCond) =
    if g_threads_got_initialized:
      g_thread_functions_for_glib_use.cond_free(cond)

  proc g_private_new*(dest: TGDestroyNotify): PGPrivate =
    result = g_thread_functions_for_glib_use.private_new(dest)

  proc g_private_get*(private_key: PGPrivate): gpointer =
    if g_threads_got_initialized:
      result = g_thread_functions_for_glib_use.private_get(private_key)
    else:
      result = private_key

  proc g_private_set*(private_key: var PGPrivate, data: gpointer) =
    if g_threads_got_initialized:
      nil
    else:
      private_key = data

  proc g_thread_yield*() =
    if g_threads_got_initialized:
      g_thread_functions_for_glib_use.thread_yield

  proc g_thread_create*(fn: TGThreadFunc, data: gpointer, joinable: gboolean,
                        error: pointer): PGThread =
    result = g_thread_create_full(fn, data, 0, joinable, false,
                                  G_THREAD_PRIORITY_NORMAL, error)

  proc g_static_mutex_get_mutex*(mutex: PPGMutex): PGMutex =
    result = g_static_mutex_get_mutex_impl(mutex)

  proc g_static_mutex_lock*(mutex: PGStaticMutex) =
    g_mutex_lock(g_static_mutex_get_mutex_impl(PPGMutex(mutex)))

  proc g_static_mutex_trylock*(mutex: PGStaticMutex): gboolean =
    result = g_mutex_trylock(g_static_mutex_get_mutex(PPGMutex(mutex)))

  proc g_static_mutex_unlock*(mutex: PGStaticMutex) =
    g_mutex_unlock(g_static_mutex_get_mutex_impl(PPGMutex(mutex)))

  proc g_main_new*(is_running: gboolean): PGMainLoop =
    result = g_main_loop_new(nil, is_running)

  proc g_main_iteration*(may_block: gboolean): gboolean =
    result = g_main_context_iteration(nil, may_block)

  proc g_main_pending*(): gboolean =
    result = g_main_context_pending(nil)

  proc g_main_set_poll_func*(fn: TGPollFunc) =
    g_main_context_set_poll_func(nil, fn)

include "glib2/slist_2"
include "glib2/list_4"
include "glib2/quark_16"
include "glib2/dataset_4"
include "glib2/quark_17"
include "glib2/hook_2"
include "glib2/quark_18"
include "glib2/iochannel_3"
when false:
  proc GLIB_CHECK_VERSION*(major, minor, micro: guint): bool =
    result = ((GLIB_MAJOR_VERSION > major) or
        ((GLIB_MAJOR_VERSION == major) and (GLIB_MINOR_VERSION > minor)) or
        ((GLIB_MAJOR_VERSION == major) and (GLIB_MINOR_VERSION == minor) and
        (GLIB_MICRO_VERSION >= micro)))

  proc g_error*(format: cstring) =
    g_log(G_LOG_DOMAIN, G_LOG_LEVEL_ERROR, format)

  proc g_message*(format: cstring) =
    g_log(G_LOG_DOMAIN, G_LOG_LEVEL_MESSAGE, format)

  proc g_critical*(format: cstring) =
    g_log(G_LOG_DOMAIN, G_LOG_LEVEL_CRITICAL, format)

  proc g_warning*(format: cstring) =
    g_log(G_LOG_DOMAIN, G_LOG_LEVEL_WARNING, format)

include "glib2/quark_19"
include "glib2/node_2"
include "glib2/rand_5"
include "glib2/scanner_2"
include "glib2/quark_20"
when false:
  proc g_ascii_isalnum*(c: gchar): bool =
    result = ((g_ascii_table[guchar(c)]) and G_ASCII_ALNUM) != 0

  proc g_ascii_isalpha*(c: gchar): bool =
    result = ((g_ascii_table[guchar(c)]) and G_ASCII_ALPHA) != 0

  proc g_ascii_iscntrl*(c: gchar): bool =
    result = ((g_ascii_table[guchar(c)]) and G_ASCII_CNTRL) != 0

  proc g_ascii_isdigit*(c: gchar): bool =
    result = ((g_ascii_table[guchar(c)]) and G_ASCII_DIGIT) != 0

  proc g_ascii_isgraph*(c: gchar): bool =
    result = ((g_ascii_table[guchar(c)]) and G_ASCII_GRAPH) != 0

  proc g_ascii_islower*(c: gchar): bool =
    result = ((g_ascii_table[guchar(c)]) and G_ASCII_LOWER) != 0

  proc g_ascii_isprint*(c: gchar): bool =
    result = ((g_ascii_table[guchar(c)]) and G_ASCII_PRINT) != 0

  proc g_ascii_ispunct*(c: gchar): bool =
    result = ((g_ascii_table[guchar(c)]) and G_ASCII_PUNCT) != 0

  proc g_ascii_isspace*(c: gchar): bool =
    result = ((g_ascii_table[guchar(c)]) and G_ASCII_SPACE) != 0

  proc g_ascii_isupper*(c: gchar): bool =
    result = ((g_ascii_table[guchar(c)]) and G_ASCII_UPPER) != 0

  proc g_ascii_isxdigit*(c: gchar): bool =
    result = ((g_ascii_table[guchar(c)]) and G_ASCII_XDIGIT) != 0

  proc g_strstrip*(str: cstring): cstring =
    result = g_strchomp(g_strchug(str))

include "glib2/quark_21"
include "glib2/type_9"
include "glib2/param_4"
include "glib2/closure_6"
include "glib2/object_4"
include "glib2/type_10"
include "glib2/typeplugin_3"
include "glib2/enums_5"
include "glib2/value_4"
include "glib2/main"
include "glib2/object_5"
{.pop.}
