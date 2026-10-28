
# Installation

Requires Nim 2.0 or newer (tested with Nim 2.3.1) and the native GTK2 libraries.
Cairo and X11 Nim bindings are bundled; no separate Nimble packages are needed
for the core GTK2 bindings. Native Cairo and X11 libraries are still required
when used. See [bundled binding details and licenses](third_party/README.md)
for provenance and optional adapter dependencies.

Install directly from this repository using [Nimble](https://github.com/nim-lang/nimble),
not the older `gtk2` package in the Nimble registry:

```bash
nimble install 'https://github.com/dykatz/nim-gtk2.git#head'
```

# Use this wrapper as part of your nimble package

If you wish to add this wrapper as a dependency to your nimble package then add the following to your .nimble file.

```nim
requires "nim >= 2.0.0", "https://github.com/dykatz/nim-gtk2.git#head"
```

# Validation

Run `nimble testBindings` to check the core bindings and the bundled Cairo/X11
integration without opening windows. To compile an example from this checkout:

```sh
nim c --path:src examples/ex1.nim
```

# Notes

## OSX

As of version 1.1 this binding will use [GTK-Quartz][1] if it is available,
otherwise it will fallback to the X11 version of GTK.

 [1]: https://wiki.gnome.org/action/show/Projects/GTK+/OSX
