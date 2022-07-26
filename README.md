# GDScript to Python to C Transpiler

[![Template](https://github.com/LinuxUserGD/gdscript-transpiler-bin/actions/workflows/template.yml/badge.svg?branch=dev)](https://github.com/LinuxUserGD/gdscript-transpiler-bin/actions/workflows/template.yml)
[![Godot 4.0.alpha](Godot-v4.0.svg)](https://downloads.tuxfamily.org/godotengine/4.0/)
[![MIT license](blue.svg)](LICENSE)
[![Python](python.svg)](https://www.python.org/)

[![Icon](gdscript-transpiler-bin/icon.svg)](gdscript-transpiler-bin/icon.svg) 

`gdscript-transpiler-bin` is a [GDScript](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_basics.html) compiler and [x-python](https://github.com/rocky/x-python) runtime environment.

Minimal Scripts can be transpiled to Python.

Binary builds are compiled with [Nuitka](https://github.com/Nuitka/Nuitka):

- [itch.io](https://linuxusergd.itch.io/gdscript-transpiler-bin)

- [GitHub Actions](https://github.com/LinuxUserGD/GDScript2PythonTranspiler/actions)

For Python script generated from [`main.gd`](gdscript-transpiler-bin/main.gd), see [`main.py`](https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-main-py).

[![Video](preview.gif)](preview.gif)

## Example

### Godot Engine 4 command line

- `./godot4 -s main.gd --headless help`

- `./godot4 -s main.gd --headless path=main.gd` (audio.gd, transpiler.gd, props.gd)

### Python environment

- `python main.py help`

- `python main.py path=main.gd`

### Nuitka compiled binary

- `./main help`

- `./main path=main.gd`

## License

### See [LICENSE](LICENSE) and [CREDITS](CREDITS) (third-party licenses)