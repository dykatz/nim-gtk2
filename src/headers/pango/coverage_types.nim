# Included by headers/pango.nim; do not import directly.
type
  TCoverageLevel* = enum
    COVERAGE_NONE, COVERAGE_FALLBACK, COVERAGE_APPROXIMATE, COVERAGE_EXACT
  PCoverageLevel* = ptr TCoverageLevel
