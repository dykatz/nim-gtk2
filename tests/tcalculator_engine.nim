import std/[math, strutils, unittest]
import ../examples/calculator_engine

proc close(a, b: float): bool = abs(a - b) < 1e-10 * max(1.0, abs(b))

suite "calculator expressions (no display required)":
  test "precedence, powers, unary signs and scientific notation":
    check evaluate("2 + 3 * 4") == 14
    check evaluate("(2 + 3) * 4") == 20
    check evaluate("2^3^2") == 512
    check evaluate("-2^2") == -4
    check evaluate("2^-3") == 0.125
    check evaluate("1e3 + 2.5E-2") == 1000.025
    check evaluate("--2") == 2
    check evaluate("6 × 4 ÷ 2 − √(9)") == 9
    check close(evaluate("sin(π / 2)", mode = radians), 1)
  test "constants, previous answer, percentages and factorials":
    check close(evaluate("pi"), PI)
    check close(evaluate("ln(e)"), 1)
    check evaluate("ans * 3", answer = 7) == 21
    check evaluate("200 * 10%") == 20
    check evaluate("5! + 0!") == 121
    check evaluate("170!") > 1e300
    check evaluate("inv(4)") == 0.25
  test "scientific functions and angle modes":
    check close(evaluate("sin(30)"), 0.5)
    check close(evaluate("cos(pi)", mode = radians), -1)
    check close(evaluate("asin(0.5)"), 30)
    check close(evaluate("acos(0)", mode = radians), PI / 2)
    check close(evaluate("atan(1)"), 45)
    check close(evaluate("tan(45)"), 1)
    check evaluate("sqrt(9) + log(100) + abs(-2)") == 7
    check evaluate("floor(2.9) + ceil(2.1)") == 5
    check close(evaluate("exp(1)"), exp(1.0))
  test "invalid syntax, domains, overflow and resource bounds":
    for expression in ["", "1 +", "1..2", "1e+", "2(3)", "unknown(2)",
                       "sqrt(4", "2 3", "echo(1)", "1/0", "inv(0)",
                       "sqrt(-1)", "ln(0)", "log(-1)", "asin(2)",
                       "acos(-2)", "tan(90)", "(-1)!", "2.5!", "171!",
                       "0^-1", "(-2)^0.5", "1e999", "1e308*10", "exp(1000)",
                       repeat("(", 150) & "1" & repeat(")", 150),
                       repeat("1", 4097)]:
      expect CalculatorError:
        discard evaluate(expression)
  test "display formatting remains parseable":
    check formatResult(100) == "100"
    check formatResult(-0.0) == "0"
    for value in [0.125, 1e30, -1e-30, PI]:
      check close(evaluate(formatResult(value)), value)
