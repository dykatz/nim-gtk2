# Included by headers/glib2.nim; do not import directly.
proc g_spaced_primes_closest*(num: guint): guint{.cdecl, dynlib: gliblib,
    importc: "g_spaced_primes_closest".}
