# Hidden-widget tests. Proc-local test variables force real closure captures.
import std/unittest
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert typeof(newAdjustment().raw) is rawGtk.PAdjustment
  doAssert typeof(newSpinButton().raw) is rawGtk.PSpinButton
  doAssert typeof(newComboBoxText().raw) is rawGtk.PComboBoxText
  doAssert not compiles(newVBox().packStart(newAdjustment()))
  doAssert not compiles(newAdjustment().show())
  doAssert not compiles(newComboBoxText().onValueChanged(proc () = discard))
  doAssert compiles(newSpinButton().selectAll())

proc finalizedCallback(data: pointer, obj: g.PGObject) {.cdecl.} =
  cast[ptr bool](data)[] = true

proc runTests() =
  gtk2.init()
  suite "gtk2 numeric and text-choice inputs":
    test "adjustment properties, atomic configuration, clamping and signals":
      let a = newAdjustment(value = 5)
      defer: a.destroy()
      check a.value == 5.0
      check a.lower == 0.0
      check a.upper == 100.0
      check a.stepIncrement == 1.0
      check a.pageIncrement == 10.0
      check a.pageSize == 0.0
      var changes, values: int
      let configConnection = a.onChanged(proc () =
        inc changes
        check a.lower == -10.0
        check a.upper == 10.0)
      let valueConnection = a.onValueChanged(proc () = inc values)
      a.configure(200, -10, 10, 0.5, 1, pageSize = 3)
      check a.value == 7.0
      check a.stepIncrement == 0.5
      check a.pageIncrement == 1.0
      check a.pageSize == 3.0
      check changes == 1
      check values == 1
      a.value = -999
      check a.value == -10.0
      check values == 2
      valueConnection.disconnect()
      a.value = 0
      check values == 2
      let alias = a
      a.destroy()
      check alias.isDestroyed
      check not configConnection.connected
      expect ValueError: discard alias.value

    test "spin range, inherited entry editing, flags and value callbacks":
      let spin = newSpinButton(-10, 10, 0.25)
      defer: spin.destroy()
      spin.digits = 2
      spin.value = 4.5
      check spin.value == 4.5
      check spin.digits == 2
      check spin.bounds == (-10.0, 10.0)
      spin.setIncrements(0.5, 2)
      check spin.increments == (0.5, 2.0)
      spin.numeric = true
      spin.wrap = true
      spin.snapToTicks = false
      check spin.numeric
      check spin.wrap
      check not spin.snapToTicks
      var values, edits: int
      spin.onValueChanged(proc () = inc values)
      spin.onChanged(proc () = inc edits)
      spin.text = "7.25"
      spin.update()
      check spin.value == 7.25
      check values >= 1
      check edits >= 1
      spin.setRange(-2, 2)
      check spin.value == 2.0
      spin.value = -100
      check spin.value == -2.0
      spin.selectAll()
      spin.insertText("1.50")
      spin.update()
      check spin.value == 1.5
      let alias = spin
      spin.destroy()
      check alias.isDestroyed
      expect ValueError: discard alias.value

    test "borrowed adjustment getters share state and retain independent ownership":
      var finalized = false
      var retained: Adjustment
      block:
        let a = newAdjustment(2, 0, 10, 0.5, 2)
        let spin = newSpinButton(a, digits = 2)
        g.weak_ref(cast[g.PGObject](a.raw), finalizedCallback, addr finalized)
        retained = spin.adjustment
        let again = spin.adjustment
        check retained.raw == a.raw
        check again.raw == a.raw
        let connection = a.onValueChanged(proc () = discard)
        retained.value = 3.5
        check spin.value == 3.5
        spin.destroy()
        check not retained.isDestroyed
        connection.disconnect()
      require not finalized
      check retained.value == 3.5
      retained.destroy()
      check retained.isDestroyed
      # Explicit destruction invalidates, but the last handle still owns a ref.
      retained = gtk2.Adjustment()
      check finalized

    test "adjustment state cache is weak and gets cleared before state release":
      var finalized = false
      block:
        let spin = newSpinButton()
        block:
          let a = spin.adjustment
          g.weak_ref(cast[g.PGObject](a.raw), finalizedCallback, addr finalized)
        for i in 0 ..< 50:
          let a = spin.adjustment
          a.value = i.float64
          check spin.value == i.float64
        check not finalized
        spin.destroy()
      # Spin retains its adjustment until native finalization, not just destroy.
      check finalized

    test "all aliases from native getters observe explicit adjustment destruction":
      let a = newAdjustment()
      let spin = newSpinButton(a)
      defer: spin.destroy()
      let alias = spin.adjustment
      let other = spin.adjustment
      a.destroy()
      check alias.isDestroyed
      check other.isDestroyed
      expect ValueError: discard spin.adjustment

    test "getters cannot resurrect a destroyed adjustment after its state is released":
      let spin = newSpinButton()
      defer: spin.destroy()
      block:
        let a = spin.adjustment
        a.destroy()
      expect ValueError: discard spin.adjustment

    test "shared adjustments can be replaced without invalidating old handles":
      let a = newAdjustment(3, 0, 20)
      let b = newAdjustment(8, 0, 30)
      let spin = newSpinButton(a)
      defer: spin.destroy()
      spin.adjustment = b
      a.value = 4
      check spin.value == 8
      b.value = 9
      check spin.value == 9
      check spin.adjustment.raw == b.raw

    test "scroll and viewport adjustment access is owned and connected":
      let scroll = newScrolledWindow()
      let viewport = newViewport()
      viewport.add(newLabel("Content"))
      scroll.add(viewport)
      let horizontal = newAdjustment(0, 0, 100)
      let vertical = newAdjustment(0, 0, 200)
      scroll.horizontalAdjustment = horizontal
      scroll.verticalAdjustment = vertical
      let viewHorizontal = viewport.horizontalAdjustment
      let viewVertical = viewport.verticalAdjustment
      check viewHorizontal.raw == horizontal.raw
      check viewVertical.raw == vertical.raw
      scroll.destroy()
      check not horizontal.isDestroyed
      check not viewVertical.isDestroyed
      # Viewport sizing owns the scroll range; it can overwrite supplied bounds.
      viewVertical.configure(25, 0, 200, 1, 10)
      check viewVertical.value == 25
      expect ValueError: discard scroll.horizontalAdjustment

    test "text combo rows, selection, insertion, removal and string copies":
      let combo = newComboBoxText(["One", "λ", "Three"])
      defer: combo.destroy()
      check combo.itemCount == 3
      check combo.activeIndex == -1
      check combo.activeText == ""
      var changes = 0
      let connection = combo.onChanged(proc () = inc changes)
      combo.activeIndex = 1
      check changes == 1
      check combo.activeText == "λ"
      let saved = combo.activeText
      combo.prependText("Zero")
      check combo.activeIndex == 2
      combo.insertText(2, "Middle")
      check combo.activeText == "λ"
      check combo.activeIndex == 3
      combo.appendText("Last")
      check combo.itemCount == 6
      combo.removeText(3)
      check saved == "λ"
      check combo.activeIndex == -1
      combo.activeIndex = 0
      combo.activeIndex = -1
      check combo.activeText == ""
      connection.disconnect()
      expect ValueError: discard combo.entryText
      expect ValueError: combo.entryText = "No entry"
      combo.destroy()
      check not connection.connected
      expect ValueError: discard combo.activeText

    test "editable text combos expose entry text without independent child handles":
      let combo = newComboBoxText(["First", "Second"], editable = true)
      defer: combo.destroy()
      var changes = 0
      combo.onChanged(proc () = inc changes)
      combo.entryText = "Custom λ"
      check combo.entryText == "Custom λ"
      check combo.activeText == "Custom λ"
      check changes >= 1
      combo.activeIndex = 1
      check combo.entryText == "Second"
      check combo.activeText == "Second"

    test "invalid numeric and string inputs fail before GTK calls":
      let a = newAdjustment()
      let spin = newSpinButton()
      let combo = newComboBoxText(["Kept"])
      defer: a.destroy()
      defer: spin.destroy()
      defer: combo.destroy()
      for n in [NaN, Inf, NegInf]:
        expect ValueError: discard newAdjustment(value = n)
        expect ValueError: a.value = n
        expect ValueError: discard newSpinButton(step = n)
        expect ValueError: spin.value = n
        expect ValueError: spin.setRange(0, n)
      expect ValueError: discard newAdjustment(lower = 2, upper = 1)
      expect ValueError: discard newAdjustment(pageSize = 101)
      expect ValueError: discard newAdjustment(stepIncrement = -1)
      expect ValueError: a.configure(1, 0, 1, 1, -1)
      check a.upper == 100
      expect ValueError: discard newSpinButton(2, 1, 1)
      expect ValueError: discard newSpinButton(step = 0)
      expect ValueError: discard newSpinButton(step = -1)
      expect ValueError: discard newSpinButton(a, climbRate = -1)
      expect ValueError: spin.digits = 21
      expect ValueError: spin.digits = -1
      expect ValueError: spin.setIncrements(-1, 10)
      expect ValueError: discard newComboBoxText(["Good", "a\0b"])
      expect ValueError: combo.appendText("a\0b")
      expect ValueError: combo.insertText(-1, "Bad")
      expect ValueError: combo.insertText(2, "Bad")
      expect ValueError: combo.removeText(1)
      expect ValueError: combo.activeIndex = 1
      expect ValueError: combo.activeIndex = -2
      check combo.itemCount == 1
      expect ValueError: discard gtk2.Adjustment().raw

    test "real heap callbacks may self-disconnect, raise, and break cycles":
      let a = newAdjustment()
      defer: a.destroy()
      var once: Connection
      var calls = 0
      once = a.onValueChanged(proc () =
        once.disconnect()
        inc calls
        check a.value == 1)
      a.value = 1
      a.value = 2
      check calls == 1
      a.onValueChanged(proc () = raise newException(ValueError, "expected adjustment error"))
      a.onValueChanged(proc () = inc calls)
      a.value = 3
      check calls == 2
      var finalized = false
      proc makeCycle(flag: pointer): rawGtk.PAdjustment =
        let adjustment = newAdjustment()
        result = adjustment.raw
        g.weak_ref(cast[g.PGObject](result), finalizedCallback, flag)
        adjustment.onValueChanged(proc () = discard adjustment.value)
        adjustment.value = 1
      let native = makeCycle(addr finalized)
      require not finalized
      rawGtk.destroy(cast[rawGtk.PObject](native))
      check finalized

    test "all three new unparented objects finalize":
      var finalized: array[3, bool]
      block:
        let a = newAdjustment()
        let spin = newSpinButton()
        let combo = newComboBoxText()
        g.weak_ref(cast[g.PGObject](a.raw), finalizedCallback, addr finalized[0])
        g.weak_ref(cast[g.PGObject](spin.raw), finalizedCallback, addr finalized[1])
        g.weak_ref(cast[g.PGObject](combo.raw), finalizedCallback, addr finalized[2])
      for done in finalized: check done

runTests()
