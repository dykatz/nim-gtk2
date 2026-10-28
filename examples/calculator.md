# MATE-style calculator

[`calculator.nim`](calculator.nim) is a standalone desktop calculator written
using **only `gtk2ui`** for its UI. It takes inspiration from MATE Calculator's
basic/scientific layouts; no MATE code, artwork, or C++ runtime is used.

From the repository root:

```sh
nim c -r --path:src examples/calculator.nim
```

This opens an interactive window. GTK2 and a working display are required.

## Features

- Editable expression display with normal keyboard editing and Enter to evaluate.
- Basic/scientific view toggle; decimal arithmetic, parentheses, powers,
  percentages, factorials, square, reciprocal, sign change, and backspace.
- Trigonometric/inverse functions, degrees/radians toggle, logarithms,
  exponentials, square root, absolute value, and constants π and e.
- `Ans` for the last successful result; `MC`, `MR`, `MS`, `M+`, and `M−`
  (labelled `M-`) for memory.
- Previous/Next history navigation, Clear History, and descriptive errors that
  preserve the expression for correction. History holds the last 100 results.

The display accepts `+ - * / ^`, postfix `%` and `!`, `pi`, `e`, `ans`, and
functions `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `sqrt`, `ln`, `log`
(base 10), `exp`, `abs`, `inv`, `floor`, `ceil`. Unicode `× ÷ − π √` aliases
are accepted too. Multiplication must be explicit (`2*pi`, not `2pi`). Function
buttons insert an opening parenthesis; close it before evaluating.

Examples:

```text
(2 + 3) * 4       = 20
2^3^2            = 512
-2^2             = -4
200 * 10%        = 20
sin(30)          = 0.5    (Degrees)
cos(pi)          = -1     (Radians)
5!               = 120
sqrt(81) + log(100) = 11
```

After evaluation, a digit/function button starts a new expression, while an
operator continues the result. Keyboard edits and history recall are preserved.
`C` clears the expression, not memory or history. Memory operations evaluate the
current expression without adding a history entry.

## Scope and testing

This is an example application, **not a complete MATE Calculator replacement**.
It uses finite real `float64` arithmetic (15 significant digits on display), not
MATE's multiprecision arithmetic. It does not implement financial/programming
modes, unit conversions, complex numbers, or persistent settings/history.
Percent means division by 100, not contextual commercial percentage arithmetic:
`200 + 10%` is `200.1`, whereas `200 * (1 + 10%)` is `220`.
Factorial accepts integers 0–170. Invalid domains, division by zero, overflow,
excessive nesting, and oversized expressions report errors.

The evaluator in [`calculator_engine.nim`](calculator_engine.nim) has no GTK
or display dependency, and does not execute input as code:

```sh
nim r tests/tcalculator_engine.nim
```

Run both arithmetic tests and hidden-window integration tests with:

```sh
nimble testCalculator
```

The integration test requires a display but never shows a window or runs the
interactive application. On headless Linux hosts with Xvfb installed, use
`xvfb-run -a nimble testCalculator`.
