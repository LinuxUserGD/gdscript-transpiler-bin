# GDScript to Python to C Transpiler

[![Template](https://github.com/LinuxUserGD/gdscript-transpiler-bin/actions/workflows/template.yml/badge.svg?branch=dev)](https://github.com/LinuxUserGD/gdscript-transpiler-bin/actions/workflows/template.yml)
[![Godot 4.0.alpha](Godot-v4.0.svg)](https://downloads.tuxfamily.org/godotengine/4.0/)
[![MIT license](blue.svg)](LICENSE)
[![Python](python.svg)](https://www.python.org/)

[![Icon](gdscript-transpiler-bin/icon.svg)](gdscript-transpiler-bin/icon.svg) 

`gdscript-transpiler-bin` is a GDScript compiler and Python runtime environment.

Minimal Scripts can be transpiled to Python.

Compatible with Python `2.6`, `2.7`, `3.3`, `3.4`, `3.5`, `3.6`, `3.7`, `3.8`, `3.9`, `3.10`.

Binary builds are compiled with [Nuitka](https://github.com/Nuitka/Nuitka):

- [itch.io](https://linuxusergd.itch.io/gdscript-transpiler-bin)

- [GitHub Actions](https://github.com/LinuxUserGD/GDScript2PythonTranspiler/actions)

For Python script generated from [`main.gd`](gdscript-transpiler-bin/main.gd), see [`main.py`](https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-main-py).

[![Video](preview.gif)](preview.gif)

## Example

### Godot Engine 4 command line

- `./godot4 -s main.gd --headless --help`

- `./godot4 -s main.gd --headless --path=main.gd` (audio.gd, transpiler.gd, props.gd)

### Python environment

- `python main.py --help`

- `python main.py --path=main.gd`

### Nuitka compiled binary

- `./main --help`

- `./main --path=main.gd`

## License

### See [LICENSE](LICENSE) and [CREDITS](CREDITS) (third-party licenses)