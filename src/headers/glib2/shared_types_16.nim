# Included by headers/glib2.nim; do not import directly.
type
  TGCompletionFunc* = gchar
  PGCompletionFunc* = ptr TGCompletionFunc
  TGCompletionStrncmpFunc* = proc (s1: cstring, s2: cstring, n: gsize): gint{.
      cdecl.}
  TGCompletion*{.final.} = object
    items*: PGList
    fn*: TGCompletionFunc
    prefix*: cstring
    cache*: PGList
    strncmp_func*: TGCompletionStrncmpFunc


  PGCompletion* = ptr TGCompletion
