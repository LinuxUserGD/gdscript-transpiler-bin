class_name Props

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-props-py


## Godot built-in types
var types: Array = [
	"AABB",
	"Array",
	"Basis",
	"bool",
	"Callable",
	"Color",
	"Dictionary",
	"float",
	"int",
	"max",
	"nil",
	"NodePath",
	"Object",
	"PackedByteArray",
	"PackedColorArray",
	"PackedFloat32Array",
	"PackedFloat64Array",
	"PackedInt32Array",
	"PackedInt64Array",
	"PackedStringArray",
	"PackedVector2Array",
	"PackedVector3Array",
	"Plane",
	"Quaternion",
	"Rect2",
	"Rect2i",
	"RID",
	"Signal",
	"String",
	"StringName",
	"Transform2D",
	"Transform3D",
	"Vector2",
	"Vector2i",
	"Vector3",
	"Vector3i",
	"void"
]
## Common gdscript operations (for parsing)
var op: Array = [
	"",
	",",
	"[",
	"]",
	"+",
	"-",
	"*",
	"/",
	"+=",
	"-=",
	"*=",
	"/=",
	"=",
	"==",
	"!=",
	">",
	"<",
	">=",
	"<="
]
## Dictionary to replace GDScript syntax with valid Python code
var repl_dict: Dictionary = {
	"-s": "",
	"var": "",
	"Node": "",
	"Main": "",
	"Props": "",
	"Audio": "",
	"Transpiler": "",
	"Tokenizer": "",
	"VECTOR2": "",
	"Version": "",
	"SceneTree": "",
	"_ready()": "_init()",
	"_init()": "_init()",
	"_ready():": "_init():",
	"_init():": "_init():",
	"func": "def",
	"true": "True",
	"false": "False",
	"&&": "and",
	"||": "or",
	":": "",
	"extends": "",
	"class_name": "",
	"File": "",
	"OS.execute('python',['-m','xpython','-c','import": "",
	"sys;print(sys.version)'],stdout,true,false)": "stdout = [sys.version]",
	"OS.execute('python',['-m','xpython','-c',import_str1+": "",
	"OS.execute('python',['-m','xpython','-c',import_str2+": "",
	"OS.execute('python',['-m','xpython','-c',imp+": "",
	"OS.execute('python',['-c',xpy+": "",
	"OS.execute('python',['-m','xpython','-c',nuitka+": "",
	"';print(Version.getNuitkaVersion())'],stdout,true,false)":
	"stdout = [Version.getNuitkaVersion()]",
	"';print(autopep8.__version__)'],stdout,true,false)":
	"    stdout = [autopep8.__version__]",
	"';autopep8.main()'],stdout,true,false)":
	"sys.argv=['python','-i',pathstr+'py']" + "\n" + "    autopep8.main()",
	"';xpython.__main__.main()'],stdout,true,false)":
	"sys.argv=['python',pathstr+'py']" + "\n" + "    stdout = [xpython.__main__.main()]",
	"';nuitka.__main__.main()'],stdout,true,false)":
	"import os" + "\n" + "    x=" + "'" + "python" + "'" + "\n" + "    xx=" + "'" + "-m" + "'" + "\n" + "    xxx=" + "'" + "nuitka" + "'" + "\n" + "    y=pathstr+" + "'" + "py" + "'" + "\n" + "    z=" + "'" + "--onefile" + "'" + "\n" + "    args=[x,xx,xxx,y,z]" + "\n" + "    os.execvp(x, args)" + "\n" + "    stdout = []",
	"quit()": "sys.exit()",
	"self.quit()": "sys.exit()",
	"#!/usr/bin/godot": "",
	"File.new()": "",
	"self.root.has_node(player):": "False:",
	"self.root.add_child(player)": "",
	"player": "~delete~",
	"player.name": "~delete~",
	"player.stream": "~delete~",
	"player.stream.data": "data",
	"player.play()": "play(data)"
}
## Add additional python import to transpiled script if required
var py_imp: bool = false
## Print additional parsing information if true
var debug: bool = false
## Print transpiled script as output to console
var verbose: bool = false
## Add additional python code for _init() method to transpiled script if required
var init_def: bool = false
## Add additional python code for right() method to transpiled script if required
var right_def: bool = false
## Add additional python code for left() method to transpiled script if required
var left_def: bool = false
## Add additional python sys import to transpiled script if required
var sys_imp: bool = false
## Add additional python nuitka version import to transpiled script if required
var nuitka_imp: bool = false
## Add additional python autopep8 import to transpiled script if required
var autopep8_imp: bool = false
## Add additional python math import to transpiled script if required
var xpython_imp: bool = false
## Add additional python math import to transpiled script if required
var math_imp : bool = false
## Add additional python simpleaudio import to transpiled script if required
var audio_imp: bool = false
