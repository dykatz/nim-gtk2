## MATE-style scientific calculator built entirely with gtk2 widgets.
## Build: nim c --path:src examples/calculator.nim
import std/strutils
import gtk2
import calculator_engine

proc newCalculatorWindow*(): Window =
  ## Call gtk2.init() first. The returned window has not been shown.
  let window = newWindow("Calculator", width = 480, height = 600)
  window.borderWidth = 12
  let content = newVBox(spacing = 6)
  window.add(content)
  let display = newEntry()
  let previous = newLabel("MATE-style Scientific Calculator")
  let status = newLabel("Type an expression and press Enter, or use the keypad.")
  let memoryStatus = newLabel("Memory: empty")
  content.packStart(previous, packShrink)
  content.packStart(display, packShrink)
  content.packStart(status, packShrink)

  var answer, memory: float
  var hasMemory, freshResult: bool
  var angle = degrees
  var history: seq[tuple[expression, value: string]]
  var historyIndex = -1

  proc setDisplay(value: string) =
    display.selectAll()
    display.insertText(value)
    display.focus()

  proc report(error: ref CalculatorError) =
    status.text = "Error: " & error.msg
    display.focus()

  proc calculate() =
    try:
      let expression = display.text
      let value = evaluate(expression, answer, angle)
      let formatted = formatResult(value)
      answer = value
      history.add((expression, formatted))
      if history.len > 100: history.delete(0)
      historyIndex = history.high
      previous.text = expression & " = " & formatted
      setDisplay(formatted)
      freshResult = true
      status.text = "Result — use Ans to recall it in another expression."
    except CalculatorError as error:
      report(error)

  proc insert(value: string) =
    if freshResult and value.len > 0 and value[0] notin {'+', '-', '*', '/', '^', '%', '!'}:
      display.text = ""
    freshResult = false
    display.insertText(value)
    display.focus()
    status.text = "Enter evaluates; functions need a closing ')'."

  proc actionButton(row: Box, title: string, action: proc () {.closure.}) =
    let button = newButton(title)
    row.packStart(button)
    button.onClicked(action)

  proc tokenButton(row: Box, title, token: string) =
    # Each call owns its token, avoiding loop-variable closure captures.
    actionButton(row, title, proc () = insert(token))

  proc row(parent: Box): HBox =
    result = newHBox(spacing = 4, homogeneous = true)
    parent.packStart(result, packShrink)

  let toolbar = row(content)
  let modeButton = newButton("Scientific")
  let angleButton = newButton("Degrees")
  toolbar.packStart(modeButton)
  toolbar.packStart(angleButton)
  actionButton(toolbar, "Clear History", proc () =
    history.setLen(0)
    historyIndex = -1
    previous.text = "History cleared"
    display.focus())

  let historyBar = row(content)
  proc browseHistory(direction: int) =
    if history.len == 0:
      status.text = "No previous calculations"
      return
    historyIndex = clamp(historyIndex + direction, 0, history.high)
    let item = history[historyIndex]
    previous.text = item.expression & " = " & item.value
    setDisplay(item.expression)
    freshResult = false
    status.text = "History " & $(historyIndex + 1) & " / " & $history.len
  actionButton(historyBar, "Previous", proc () = browseHistory(-1))
  actionButton(historyBar, "Next", proc () = browseHistory(1))
  actionButton(historyBar, "Ans", proc () = insert("ans"))

  let scientific = newVBox(spacing = 4)
  content.packStart(scientific, packShrink)
  let trig = row(scientific)
  for name in ["sin", "cos", "tan", "asin", "acos", "atan"]:
    tokenButton(trig, name, name & "(")
  let functions = row(scientific)
  for name in ["ln", "log", "exp", "abs"]:
    tokenButton(functions, name, name & "(")
  tokenButton(functions, "xʸ", "^")
  tokenButton(functions, "n!", "!")
  let constants = row(scientific)
  tokenButton(constants, "π", "pi")
  tokenButton(constants, "e", "e")
  tokenButton(constants, "√", "sqrt(")

  var scientificVisible = true
  modeButton.onClicked do ():
    scientificVisible = not scientificVisible
    if scientificVisible:
      scientific.showAll()
      modeButton.text = "Scientific"
    else:
      scientific.hide()
      modeButton.text = "Basic"
    display.focus()
  angleButton.onClicked do ():
    angle = if angle == degrees: radians else: degrees
    angleButton.text = if angle == degrees: "Degrees" else: "Radians"
    display.focus()

  content.packStart(memoryStatus, packShrink)
  let memoryBar = row(content)
  proc memoryAction(operation: string) =
    try:
      case operation
      of "MC": memory = 0; hasMemory = false
      of "MR":
        if not hasMemory: raise newException(CalculatorError, "Memory is empty")
        insert("(" & formatResult(memory) & ")")
      of "MS", "M+", "M-":
        let value = evaluate(display.text, answer, angle)
        let updated = case operation
          of "M+": memory + value
          of "M-": memory - value
          else: value
        discard formatResult(updated) # Check overflow before updating memory.
        memory = updated
        hasMemory = true
      else: discard
      memoryStatus.text = if hasMemory: "Memory: " & formatResult(memory) else: "Memory: empty"
      display.focus()
    except CalculatorError as error:
      report(error)
  proc memoryButton(operation: string) =
    actionButton(memoryBar, operation, proc () = memoryAction(operation))
  for operation in ["MC", "MR", "MS", "M+", "M-"]: memoryButton(operation)

  let keypad = newVBox(spacing = 4)
  content.packStart(keypad)
  proc special(row: Box, title: string) =
    actionButton(row, title, proc () =
      case title
      of "=": calculate()
      of "C":
        display.text = ""
        freshResult = false
        status.text = "Cleared"
      of "⌫":
        display.backspace()
        freshResult = false
      of "±":
        let expression = display.text.strip
        setDisplay(if expression.len == 0: "-" else: "-(" & expression & ")")
        freshResult = false
      of "x²", "1/x":
        let expression = display.text.strip
        setDisplay(if title == "x²": "(" & expression & ")^2"
                   else: "inv(" & expression & ")")
        calculate()
      else: discard
      display.focus())

  for keys in [["(", ")", "%", "⌫", "C"],
               ["7", "8", "9", "÷", "x²"],
               ["4", "5", "6", "×", "1/x"],
               ["1", "2", "3", "−", "±"],
               ["0", ".", "^", "+", "="]]:
    let buttons = newHBox(spacing = 4, homogeneous = true)
    keypad.packStart(buttons)
    for key in keys:
      case key
      of "=", "C", "⌫", "±", "x²", "1/x": special(buttons, key)
      of "÷": tokenButton(buttons, key, "/")
      of "×": tokenButton(buttons, key, "*")
      of "−": tokenButton(buttons, key, "-")
      else: tokenButton(buttons, key, key)

  display.onChanged do ():
    freshResult = false
  display.onActivate(calculate)
  display.focus()
  result = window

proc calculatorMain() =
  gtk2.init()
  let window = newCalculatorWindow()
  defer: window.destroy()
  window.run()

when isMainModule and not defined(gtk2DisableMain):
  calculatorMain()
