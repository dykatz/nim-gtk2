# Included by headers/gtk2.nim; do not import directly.
type
  TRcStyleClass* = object of TGObjectClass
    create_rc_style*: proc (rc_style: PRcStyle): PRcStyle{.cdecl.}
    parse*: proc (rc_style: PRcStyle, settings: PSettings, scanner: PGScanner): guint{.
        cdecl.}
    merge*: proc (dest: PRcStyle, src: PRcStyle){.cdecl.}
    create_style*: proc (rc_style: PRcStyle): PStyle{.cdecl.}
    reserved371: proc (){.cdecl.}
    reserved372: proc (){.cdecl.}
    reserved373: proc (){.cdecl.}
    reserved374: proc (){.cdecl.}

  PRcStyleClass* = ptr TRcStyleClass
