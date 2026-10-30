# Included by headers/pango.nim; do not import directly.
type
  PAnalysis* = ptr TAnalysis
  TEngineLangScriptBreak* = proc (text: cstring, len: int32,
                                  analysis: PAnalysis, attrs: PLogAttr,
                                  attrs_len: int32){.cdecl.}
  PEngineLang* = ptr TEngineLang
  TEngineLang*{.final, pure.} = object
    engine*: TEngine
    script_break*: TEngineLangScriptBreak

  TEngineShapeScript* = proc (font: PFont, text: cstring, length: int32,
                              analysis: PAnalysis, glyphs: PGlyphString){.cdecl.}
  PEngineShape* = ptr TEngineShape
  TEngineShape*{.final, pure.} = object
    engine*: TEngine
    script_shape*: TEngineShapeScript
    get_coverage*: TEngineShapeGetCoverage

  TAnalysis*{.final, pure.} = object
    shape_engine*: PEngineShape
    lang_engine*: PEngineLang
    font*: PFont
    level*: guint8
    language*: PLanguage
    extra_attrs*: PGSList

