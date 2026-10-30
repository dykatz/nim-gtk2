# Included by headers/pango.nim; do not import directly.
type
  TEngineShapeGetCoverage* = proc (font: PFont, language: PLanguage): PCoverage{.
      cdecl.}
