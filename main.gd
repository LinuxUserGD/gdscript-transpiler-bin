#!/usr/bin/godot -s

extends SceneTree


func _init():
	var main = Main.new()
	var path : String = "res://main.gd"
	var path2 : String = "res://main.py"
	var _self : String = ""
	var content : String = main.read(_self, path)
	var out : String = main.transpile(_self, content)
	if main.verbose:
		print(out)
	main.save(_self, path2, out)
	quit()

class Main:
	var types : Array = [ "AABB", "Array", "Basis", "bool", "Callable", "Color", "Dictionary", "float", "int", "max", "nil", "NodePath", "Object", "PackedByteArray", "PackedColorArray", "PackedFloat32Array", "PackedFloat64Array", "PackedInt32Array", "PackedInt64Array", "PackedStringArray", "PackedVector2Array", "PackedVector3Array", "Plane", "Quaternion", "Rect2", "Rect2i", "RID", "Signal", "String", "StringName", "Transform2D", "Transform3D", "Vector2", "Vector2i", "Vector3", "Vector3i"] 
	var op : Array = [ "", ",", "[", "]", "+", "-", "*", "/", "+=", "-=", "*=", "/=", "=", "==", "!=", ">", "<", ">=", "<=" ]
	var debug : bool = false
	var right_def : bool = false
	var left_def : bool = false
	var sys_imp : bool = true
	var verbose : bool = false
	
	func transpile(_self : String, content : String):
		self.types.sort()
		var t = ""
		for line in content.split("\n"):
			t += self.analyze(_self, line)
		
		if self.left_def:
			t += "def left(s, amount):"
			t += "\n"
			t += "	return s[:amount]"
			t += "\n"
		if self.right_def:
			t += "def right(s, amount):"
			t += "\n"
			t += "	return s[len(s)-amount:]"
			t += "\n"
		
		t += "i"
		t += "f"
		t += " __name__=="
		t += "\""
		t += "__main__"
		t += "\""
		t += ":"
		t += "\n"
		t += "	_init()"
		t += "\n"
		return t

	func read(_self : String, path : String):
		var file : File = File.new()
		file.open(path, File.READ)
		var string : String = file.get_as_text()
		file.close()
		return string

	func save(_self : String, path : String, content : String):
		var file : File = File.new()
		file.open(path, File.WRITE)
		file.store_string(content)
		file.close()
		
	func analyze(_self : String, l : String):
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
				else:
					out += self.translate(_self, string[i])
				c+=1
		if out.length() > 0:
			var res : String = "res"
			res += "://"
			while out.contains(res):
				out = out.replace(res, "")
			while out.contains("if") and out.ends_with("\""):
				out += ":"
			out += "\n"
		return out
	
	func dict(_self : String, arg : String):
		var e : String = ""
		if arg.length()==0:
			return e
		if arg in self.op:
			e += arg
			e += " "
			return e
		while (arg.begins_with("	")):
			e += "	"
			arg = arg.right(arg.length()-1)
		if arg == "-s":
			return e
		if arg in self.types:
			return e
		if arg == "var":
			return e
		if arg == "Node":
			return e
		if arg == "SceneTree":
			return e
		if arg == "func":
			e += "def"
			e += " "
			return e
		if arg == "true":
			e += "True"
			e += " "
			return e
		if arg == "false":
			e += "False"
			e += " "
			return e
		if arg == ":":
			return e
		if arg == "extends":
			return e
		if arg == "File":
			return e
		if arg == "quit()":
			e += "sys.exit()"
			e += " "
			self.sys_imp = true
			return e
		if arg == "#!/usr/bin/godot":
			e += "#!/usr/bin/env python"
			if self.sys_imp:
				e += "\n"
				e += "import sys"
			e += " "
			return e
		if arg == "File.new()":
			e += "\""
			e += "\""
			e += " "
			return e
		var con : bool = false
		while arg.contains(".size()"):
			arg = arg.replace(".size()", ")")
			if arg.contains("("):
				arg = arg.replace("(", "(len(")
			else:
				arg = "len(" + arg
			con = true
		while arg.contains(".length()"):
			arg = arg.replace(".length()", ")")
			if arg.contains("("):
				arg = arg.replace("(", "(len(")
			else:
				arg = "len(" + arg
			con = true
		while arg.contains(".right("):
			arg = arg.replace(".right(", ", ")
			arg = "right(" + arg
			self.right_def = true
			con = true
		while arg.contains(".left("):
			arg = arg.replace(".left(", ", ")
			arg = "left(" + arg
			self.left_def = true
			con = true
		while arg.contains(".open"):
			arg = arg.replace(".open", " = open")
			con = true
		while arg.contains(".begins_with"):
			arg = arg.replace(".begins_with", ".startswith")
			con = true
		while arg.contains(".ends_with"):
			arg = arg.replace(".ends_with", ".endswith")
			con = true
		while arg.contains(".contains"):
			arg = arg.replace(".contains", ".find")
			arg = "0 <= " + arg
			con = true
		while arg.contains("File.READ"):
			var r : String = ""
			r += "\""
			r += "r"
			r += "\""
			arg = arg.replace("File.READ", r)
			con = true
		while arg.contains("File.WRITE"):
			var w : String = ""
			w += "\""
			w += "w"
			w += "\""
			arg = arg.replace("File.WRITE", w)
			con = true
		while arg.contains(".get_as_text"):
			arg = arg.replace(".get_as_text", ".read")
			con = true
		while arg.contains(".store_string"):
			arg = arg.replace(".store_string", ".write")
			con = true
		while (arg.contains(".new()")):
			arg = arg.replace(".new()", "()")
			con = true
		while (arg.contains("_self,")):
			arg = arg.replace("_self,", "")
			con = true
		while (arg.contains("_self")):
			arg = arg.replace("_self", "self")
			con = true
		var found : bool = false
		for type in self.types:
			while arg.begins_with(type):
				found = true
				arg = arg.replace(type, "")
				break
		if found:
			e += arg
			e += " "
			return e
		if con:
			e += arg
			e += " "
			return e
		if self.debug:
			print("DEBUG: " + arg)
		e += arg
		e += " "
		return e

	func translate(_self : String, e : String):
		if (e == ","):
			return ","
		if (e == ""):
			return ""
		var args : Array = e.split(" ")
		e = ""
		for arg in args:
			e += self.dict(_self, arg)
		while e.contains("	"):
			e = e.replace("	", "   ")
		return e
