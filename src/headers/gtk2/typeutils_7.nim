# Included by headers/gtk2.nim; do not import directly.
proc VALUE_CHAR*(a: TArg): gchar =
  var a = a
  result = cast[ptr gchar](addr(a.d))[]

proc VALUE_UCHAR*(a: TArg): guchar =
  var a = a
  result = cast[ptr guchar](addr(a.d))[]

proc VALUE_BOOL*(a: TArg): gboolean =
  var a = a
  result = cast[ptr gboolean](addr(a.d))[]

proc VALUE_INT*(a: TArg): gint =
  var a = a
  result = cast[ptr gint](addr(a.d))[]

proc VALUE_UINT*(a: TArg): guint =
  var a = a
  result = cast[ptr guint](addr(a.d))[]

proc VALUE_LONG*(a: TArg): glong =
  var a = a
  result = cast[ptr glong](addr(a.d))[]

proc VALUE_ULONG*(a: TArg): gulong =
  var a = a
  result = cast[ptr gulong](addr(a.d))[]

proc VALUE_FLOAT*(a: TArg): gfloat =
  var a = a
  result = cast[ptr gfloat](addr(a.d))[]

proc VALUE_DOUBLE*(a: TArg): gdouble =
  var a = a
  result = cast[ptr gdouble](addr(a.d))[]

proc VALUE_STRING*(a: TArg): cstring =
  var a = a
  result = cast[ptr cstring](addr(a.d))[]

proc VALUE_ENUM*(a: TArg): gint =
  var a = a
  result = cast[ptr gint](addr(a.d))[]

proc VALUE_FLAGS*(a: TArg): guint =
  var a = a
  result = cast[ptr guint](addr(a.d))[]

proc VALUE_BOXED*(a: TArg): gpointer =
  var a = a
  result = cast[ptr gpointer](addr(a.d))[]

proc VALUE_OBJECT*(a: TArg): PObject =
  var a = a
  result = cast[ptr PObject](addr(a.d))[]

proc VALUE_POINTER*(a: TArg): gpointer =
  var a = a
  result = cast[ptr gpointer](addr(a.d))[]

proc VALUE_SIGNAL*(a: TArg): TArgSignalData =
  var a = a
  result = cast[ptr TArgSignalData](addr(a.d))[]

proc RETLOC_CHAR*(a: TArg): cstring =
  var a = a
  result = cast[ptr cstring](addr(a.d))[]

proc RETLOC_UCHAR*(a: TArg): Pguchar =
  var a = a
  result = cast[ptr Pguchar](addr(a.d))[]

proc RETLOC_BOOL*(a: TArg): Pgboolean =
  var a = a
  result = cast[ptr Pgboolean](addr(a.d))[]

proc RETLOC_INT*(a: TArg): Pgint =
  var a = a
  result = cast[ptr Pgint](addr(a.d))[]

proc RETLOC_UINT*(a: TArg): Pguint =
  var a = a
  result = cast[ptr Pguint](addr(a.d))[]

proc RETLOC_LONG*(a: TArg): Pglong =
  var a = a
  result = cast[ptr Pglong](addr(a.d))[]

proc RETLOC_ULONG*(a: TArg): Pgulong =
  var a = a
  result = cast[ptr Pgulong](addr(a.d))[]

proc RETLOC_FLOAT*(a: TArg): Pgfloat =
  var a = a
  result = cast[ptr Pgfloat](addr(a.d))[]

proc RETLOC_DOUBLE*(a: TArg): Pgdouble =
  var a = a
  result = cast[ptr Pgdouble](addr(a.d))[]

proc RETLOC_STRING*(a: TArg): Ppgchar =
  var a = a
  result = cast[ptr Ppgchar](addr(a.d))[]

proc RETLOC_ENUM*(a: TArg): Pgint =
  var a = a
  result = cast[ptr Pgint](addr(a.d))[]

proc RETLOC_FLAGS*(a: TArg): Pguint =
  var a = a
  result = cast[ptr Pguint](addr(a.d))[]

proc RETLOC_BOXED*(a: TArg): Pgpointer =
  var a = a
  result = cast[ptr Pgpointer](addr(a.d))[]

proc RETLOC_OBJECT*(a: TArg): PPGtkObject =
  var a = a
  result = cast[ptr PPGtkObject](addr(a.d))[]

proc RETLOC_POINTER*(a: TArg): Pgpointer =
  var a = a
  result = cast[ptr Pgpointer](addr(a.d))[]

