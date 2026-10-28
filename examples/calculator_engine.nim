## Display-independent expression evaluator for calculator.nim.
## Deliberately parses expressions rather than executing Nim or shell code.
import std/[math, strutils]

type
  CalculatorError* = object of ValueError
  AngleMode* = enum degrees, radians
  Parser = object
    input: string
    pos, depth: int
    answer: float
    mode: AngleMode

proc fail(message: string) {.noreturn.} =
  raise newException(CalculatorError, message)

proc finite(value: float): float =
  if classify(value) in {fcNan, fcInf, fcNegInf}:
    fail("Result is outside the real, finite range")
  value

proc skip(p: var Parser) =
  while p.pos < p.input.len and p.input[p.pos].isSpaceAscii: inc p.pos

proc take(p: var Parser, token: char): bool =
  p.skip()
  if p.pos < p.input.len and p.input[p.pos] == token:
    inc p.pos
    result = true

proc enter(p: var Parser) =
  inc p.depth
  if p.depth > 128: fail("Expression is nested too deeply")

proc expression(p: var Parser): float
proc unary(p: var Parser): float

proc function(p: Parser, name: string, x: float): float =
  let angle = if p.mode == degrees: x * PI / 180.0 else: x
  let inverseScale = if p.mode == degrees: 180.0 / PI else: 1.0
  case name
  of "sin": result = sin(angle)
  of "cos": result = cos(angle)
  of "tan":
    if abs(cos(angle)) < 1e-15: fail("Tangent is undefined at this angle")
    result = tan(angle)
  of "asin":
    if abs(x) > 1: fail("asin requires a value between -1 and 1")
    result = arcsin(x) * inverseScale
  of "acos":
    if abs(x) > 1: fail("acos requires a value between -1 and 1")
    result = arccos(x) * inverseScale
  of "atan": result = arctan(x) * inverseScale
  of "sqrt":
    if x < 0: fail("Square root requires a nonnegative value")
    result = sqrt(x)
  of "ln", "log":
    if x <= 0: fail("Logarithm requires a positive value")
    result = if name == "ln": ln(x) else: log10(x)
  of "exp": result = exp(x)
  of "abs": result = abs(x)
  of "floor": result = floor(x)
  of "ceil": result = ceil(x)
  of "inv":
    if x == 0: fail("Cannot divide by zero")
    result = 1 / x
  else: fail("Unknown function: " & name)
  result = finite(result)

proc primary(p: var Parser): float =
  p.skip()
  if p.take('('):
    result = p.expression()
    if not p.take(')'): fail("Missing closing parenthesis")
  elif p.pos < p.input.len and p.input[p.pos].isAlphaAscii:
    let start = p.pos
    while p.pos < p.input.len and p.input[p.pos].isAlphaNumeric: inc p.pos
    let name = p.input[start ..< p.pos].toLowerAscii
    case name
    of "pi": result = PI
    of "e": result = exp(1.0)
    of "ans": result = p.answer
    else:
      if not p.take('('): fail("Expected '(' after " & name)
      let value = p.expression()
      if not p.take(')'): fail("Missing closing parenthesis")
      result = p.function(name, value)
  else:
    let start = p.pos
    while p.pos < p.input.len and p.input[p.pos] in {'0'..'9', '.'}: inc p.pos
    if p.pos < p.input.len and p.input[p.pos] in {'e', 'E'}:
      inc p.pos
      if p.pos < p.input.len and p.input[p.pos] in {'+', '-'}: inc p.pos
      while p.pos < p.input.len and p.input[p.pos] in {'0'..'9'}: inc p.pos
    if p.pos == start: fail("Expected a number, constant or function")
    try:
      result = finite(parseFloat(p.input[start ..< p.pos]))
    except ValueError:
      fail("Invalid number")

proc postfix(p: var Parser): float =
  result = p.primary()
  while true:
    if p.take('%'):
      result /= 100
    elif p.take('!'):
      if result < 0 or result > 170 or floor(result) != result:
        fail("Factorial requires an integer from 0 to 170")
      let n = int(result)
      result = 1
      for i in 2 .. n: result *= float(i)
    else: break

proc power(p: var Parser): float =
  result = p.postfix()
  if p.take('^'):
    let exponent = p.unary() # Right-associative, and permits 2^-3.
    if result == 0 and exponent < 0: fail("Cannot divide by zero")
    result = finite(pow(result, exponent))

proc unary(p: var Parser): float =
  p.enter()
  defer: dec p.depth
  if p.take('+'): result = p.unary()
  elif p.take('-'): result = -p.unary()
  else: result = p.power()

proc product(p: var Parser): float =
  result = p.unary()
  while true:
    if p.take('*'): result = finite(result * p.unary())
    elif p.take('/'):
      let divisor = p.unary()
      if divisor == 0: fail("Cannot divide by zero")
      result = finite(result / divisor)
    else: break

proc expression(p: var Parser): float =
  p.enter()
  defer: dec p.depth
  result = p.product()
  while true:
    if p.take('+'): result = finite(result + p.product())
    elif p.take('-'): result = finite(result - p.product())
    else: break

proc evaluate*(input: string, answer = 0.0, mode = degrees): float =
  if input.len > 4096: fail("Expression is too long")
  let normalized = input.replace("×", "*").replace("÷", "/").replace("−", "-")
    .replace("π", "pi").replace("√", "sqrt")
  var p = Parser(input: normalized, answer: finite(answer), mode: mode)
  result = finite(p.expression())
  p.skip()
  if p.pos != p.input.len: fail("Unexpected input at column " & $(p.pos + 1))

proc formatResult*(value: float): string =
  result = formatFloat(finite(value), ffDefault, 15)
  if '.' in result and 'e' notin result and 'E' notin result:
    while result.endsWith("0"): result.setLen(result.len - 1)
    if result.endsWith("."): result.setLen(result.len - 1)
  if result == "-0": result = "0"
