extends Node

var types : Array = [ "var", "AABB", "Array", "Basis", "bool", "Callable", "Color", "Dictionary", "float", "int", "max", "nil", "NodePath", "Object", "PackedByteArray", "PackedColorArray", "PackedFloat32Array", "PackedFloat64Array", "PackedInt32Array", "PackedInt64Array", "PackedStringArray", "PackedVector2Array", "PackedVector3Array", "Plane", "Quaternion", "Rect2", "Rect2i", "RID", "Signal", "String", "StringName", "Transform2D", "Transform3D", "Vector2", "Vector2i", "Vector3", "Vector3i"] 

func _ready():
	var path : String = "res://main.gd"
	var content : String = read(path)
	var out : String = transpile(content)
	print(out)
func transpile(content : String):
	types.sort_custom(Callable(self, "customComparison"))
	var translated = ""
	for line in content.split("\n"):
		translated += analyze(line) + "\n"
	return translated
func customComparison(a, b):
	return a.length() > b.length()
func read(path : String):
	var file : File = File.new()
	file.open(path, File.READ)
	return file.get_as_text()
func analyze(l : String):
	var out : String = ""
	var string_prev : Array = l.split("\"" + "\\" + "\"" + "\"")
	var c : int = 0
	for ii in range(0, string_prev.size()):
		var string : Array = string_prev[ii].split("\"")
		if ii > 0:
			out += "\"" + "\\" + "\"" + "\""
		for i in range(0, string.size()):
			if ii > 0:
				if string[i] == "\\" + "\\":
					out += "\"" + string[i] + "\""
				else:
					out += string[i]
			elif c ^ 1 != c + 1:
				out += "\"" + string[i] + "\""
			else :
				out += translate(string[i])
			c+=1
	return out
func translate(e : String):
	var old_args : Array = e.split(" ")
	e = ""
	var args : Array = e.split(" ")
	for arg in old_args:
		if arg.length()>0:
			args.append(arg)
	if args.size() > 0:
		for i in range(0, args.size()):
			if args[i] != "":
				if args[i] == "extends":
					args[i] = "import"
				elif args[i] == "func":
					args[i] = "def"
				for type in types:
					if args[i].contains(":" + type):
						args[i] = args[i].replace(":" + type, "")
					elif args[i].contains(type + ")"):
						args[i] = args[i].replace(type + ")", ")")
					elif args[i] == type:
						args[i] = ""
					elif args[i] == ":" and i < args.size()-1:
						args[i] = ""
				if args[i].length() > 0 and i > 0 and !args[i].begins_with(")"):
					e += " " + args[i]
				else:
					e += args[i]
		if old_args[old_args.size()-1] == "":
			e += " "
	return e
