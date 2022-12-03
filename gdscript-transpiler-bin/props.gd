class_name Props

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d

## Godot built-in types
var types : Array = [ "AABB", "Array", "Basis", "bool", "Callable", "Color", "Dictionary", "float", "int", "max", "nil", "NodePath", "Object", "PackedByteArray", "PackedColorArray", "PackedFloat32Array", "PackedFloat64Array", "PackedInt32Array", "PackedInt64Array", "PackedStringArray", "PackedVector2Array", "PackedVector3Array", "Plane", "Quaternion", "Rect2", "Rect2i", "RID", "Signal", "String", "StringName", "Transform2D", "Transform3D", "Vector2", "Vector2i", "Vector3", "Vector3i"] 
## Common gdscript operations (for parsing)
var op : Array = [ "", ",", "[", "]", "+", "-", "*", "/", "+=", "-=", "*=", "/=", "=", "==", "!=", ">", "<", ">=", "<=" ]
## Dictionary to replace GDScript syntax with valid Python code
var repl_dict : Dictionary = {
	"-s": "",
	"var": "",
	"Node": "",
	"Main": "",
	"main": "",
	"Props": "",
	"props": "",
	"Audio": "",
	"audio": "",
	"Transpiler": "",
	"transpiler": "",
	"SceneTree": "",
	"_ready():": "_init():",
	"func": "def",
	"true": "True",
	"false": "False",
	"&&": "and",
	"||": "or",
	":": "",
	"extends": "",
	"class_name": "",
	"File": "",
	"OS.execute('python',['-c','import": "",
	"sys;print(sys.version)'],stdout,true,false)": "stdout = [sys.version]",
	"OS.execute('python',['-c',import_str+": "",
	"';print(Version.getNuitkaVersion())'],stdout,true,false)": "stdout = [Version.getNuitkaVersion()]",
	"quit()": "sys.exit()",
	"self.quit()": "sys.exit()",
	"#!/usr/bin/godot": "#!/usr/bin/env python",
	"File.new()": "",
	"(self.root.has_node(player)):": "False:",
	"self.root.add_child(player)": "",
	"player": "~delete~",
	"player.name": "~delete~",
	"player.stream": "~delete~",
	"player.stream.data": "data",
	"player.play()": "play(data)"
	}
## Print additional parsing information if true
var debug : bool = true
## Print transpiled script as output to console
var verbose : bool = false
## Add additional python code for right() method to transpiled script if required
var right_def : bool = false
## Add additional python code for left() method to transpiled script if required
var left_def : bool = false
## Add additional python sys import to transpiled script if required
var sys_imp : bool = true
## Add additional python nuitka import to transpiled script if required
var nuitka_imp : bool = true
## Add additional python simpleaudio import to transpiled script if required
var audio_imp : bool = true
