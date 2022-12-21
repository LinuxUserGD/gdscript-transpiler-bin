# GDScript to Python to C Transpiler

[![Template](https://github.com/LinuxUserGD/gdscript-transpiler-bin/actions/workflows/template.yml/badge.svg?branch=dev)](https://github.com/LinuxUserGD/gdscript-transpiler-bin/actions/workflows/template.yml)
[![Godot 4.0.alpha](Godot-v4.0.svg)](https://downloads.tuxfamily.org/godotengine/4.0/)
[![MIT license](blue.svg)](LICENSE)
[![Python](python.svg)](https://www.python.org/)

[![Icon](gdscript-transpiler-bin/icon.svg)](gdscript-transpiler-bin/icon.svg) 

`gdscript-transpiler-bin` is a [GDScript](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_basics.html) compiler and [Python](https://www.python.org/) runtime environment using [x-python](https://github.com/rocky/x-python).

Minimal Scripts can be transpiled to Python.

Binary builds are compiled with [Nuitka](https://github.com/Nuitka/Nuitka):

- [itch.io](https://linuxusergd.itch.io/gdscript-transpiler-bin)

- [GitHub Actions](https://github.com/LinuxUserGD/GDScript2PythonTranspiler/actions)

For Python script generated from [`__main__.gd`](gdscript-transpiler-bin/__main__.gd), see [`__main__.py`](https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-__main__-py).

[![Video](preview.gif)](preview.gif)

## Example

### Godot Engine 4 command line

- `./godot4 -s __main__.gd --headless help`

- `./godot4 -s __main__.gd --headless path=__main__.gd` (audio.gd, transpiler.gd, props.gd)

### Python environment

- `python __main__.py help`

- `python __main__.py path=__main__.gd`

### Nuitka compiled binary

- `./gds help`

- `./gds path=__main__.gd`

## License

### See [LICENSE](LICENSE) and [CREDITS](CREDITS) (third-party licenses)