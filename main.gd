#!/usr/bin/godot -s

extends SceneTree

func _init():
	if OS.get_cmdline_args().size() == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif OS.get_cmdline_args().size() != 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	for arg in OS.get_cmdline_args():
		if arg == '---version':
			version()
			self.quit()
			return
		if arg ==  '---help':
			help()
			self.quit()
			return
		if arg == '---test=base64_audio':
			play_base64_audio()
			return
		var path_arg : String = '---path='
		if arg.begins_with(path_arg):
			start(arg)
			self.quit()
			return
	help()
	self.quit()
	return
func start(arg : String):
	var path : String = "res://" + arg.split("=")[1]
	var args = arg.split("=")[1].split(".")
	var c : int = args.size()
	var pathstr : String = ""
	for path_str in arg.split("=")[1].split("."):
		c -= 1
		if c != 0:
			pathstr += path_str + "."
	var path2 : String = "res://" + pathstr + "py"
	var _self : String = ""
	var main = Main.new()
	var content : String = main.read(_self, path)
	var out : String = main.transpile(_self, content)
	if main.verbose:
		print(out)
	main.save(_self, path2, out)
func version():
	var info : Dictionary = Engine.get_version_info()
	var major : int = info.get("major")
	var minor : int = info.get("minor")
	var status : String = info.get("status")
	var build : String = info.get("build")
	var id : String = info.get("hash")
	print("GDScript2PythonTranspiler")
	print("Godot: " + str(major) + "." + str(minor) + "." + status + "." + build + "." + id.left(9))
	var stdout : Array = []
	OS.execute('python',['-c','import sys;print(sys.version)'],stdout,true,false)
	print("Python: " + stdout[0].split("\n")[0])
	stdout.clear()
	var import_str : String = "from nuitka import Version"
	OS.execute('python',['-c',import_str+ ';print(Version.getNuitkaVersion())'],stdout,true,false)
	print("Nuitka: " + stdout[0].split("\n")[0])
func help():
	print("Usage: main [options]")
	print()
	print("Options:")
	print("  " + '---version' + "                   " + "show program's version number and exit")
	print("  " + '---help' + "                      " + "show this help message and exit")
	print("  " + '---path=../path/to/file.gd' + "   " + "path to gdscript file")
	print("  " + '---test=base64_audio' + "         " + "play base64 encoded audio file")
class Main:
	var types : Array = [ "AABB", "Array", "Basis", "bool", "Callable", "Color", "Dictionary", "float", "int", "max", "nil", "NodePath", "Object", "PackedByteArray", "PackedColorArray", "PackedFloat32Array", "PackedFloat64Array", "PackedInt32Array", "PackedInt64Array", "PackedStringArray", "PackedVector2Array", "PackedVector3Array", "Plane", "Quaternion", "Rect2", "Rect2i", "RID", "Signal", "String", "StringName", "Transform2D", "Transform3D", "Vector2", "Vector2i", "Vector3", "Vector3i"] 
	var op : Array = [ "", ",", "[", "]", "+", "-", "*", "/", "+=", "-=", "*=", "/=", "=", "==", "!=", ">", "<", ">=", "<=" ]
	var repl_dict : Dictionary = {"-s":"","var":"","Node":"","SceneTree":"","_ready():":"_init():","func":"def","true":"True","false":"False","&&":"and","||":"or",":":"","extends":"","File":"","OS.execute('python',['-c','import":"","sys;print(sys.version)'],stdout,true,false)":"stdout = [sys.version]","OS.execute('python',['-c',import_str+":"","';print(Version.getNuitkaVersion())'],stdout,true,false)":"stdout = [Version.getNuitkaVersion()]","quit()":"sys.exit()","#!/usr/bin/godot":"#!/usr/bin/env python","File.new()":"","self.quit()":"quit()","(self.root.has_node(player)):":"False:","self.root.add_child(player)":"","player":"~delete~","player.name":"~delete~","player.stream":"~delete~","player.stream.data":"data","player.play()":"~audio~",}
	var debug : bool = true
	var right_def : bool = false
	var left_def : bool = false
	var sys_imp : bool = true
	var nuitka_imp : bool = true
	var audio_imp : bool = true
	var verbose : bool = false
	func transpile(_self : String, content : String):
		self.types.sort()
		var t = ""
		for line in content.split("\n"):
			t += self.analyze(_self, line)
		if self.left_def:
			t += "def left(s, amount):"
			t += "\n"
			t += "   return s[:amount]"
			t += "\n"
		if self.right_def:
			t += "def right(s, amount):"
			t += "\n"
			t += "   return s[len(s)-amount:]"
			t += "\n"
		t += "i"
		t += "f"
		t += " __name__=="
		t += "\""
		t += "__main__"
		t += "\""
		t += ":"
		t += "\n"
		t += "   _init()"
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
			if out.ends_with(" "):
				out = out.left(out.length()-1)
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
		if arg in self.types:
			return e
		elif arg in ["-s", "var", "Node", "SceneTree", "extends", "File"]:
			e += self.repl_dict[arg]
			return e
		elif arg in ["_ready():", "func", "true", "false", "&&", "||", "sys;print(sys.version)'],stdout,true,false)", "';print(Version.getNuitkaVersion())'],stdout,true,false)", "self.quit()", "(self.root.has_node(player)):", "self.root.add_child(player)", "player", "player.name", "player.stream", "player.stream.data", "player.play()"]:
			e += self.repl_dict[arg]
			e += " "
			return e
		elif arg == "OS.execute('python',['-c','import":
			e += self.repl_dict[arg]
			self.sys_imp = true
			return e
		elif arg == "OS.execute('python',['-c',import_str+":
			e += self.repl_dict[arg]
			self.nuitka_imp = true
			return e
		elif arg == "quit()":
			e += self.repl_dict[arg]
			e += " "
			self.sys_imp = true
			return e
		elif arg == "#!/usr/bin/godot":
			e += self.repl_dict[arg]
			if self.sys_imp:
				e += "\n"
				e += "import sys"
			if self.nuitka_imp:
				e += "\n"
				e += "from nuitka import Version"
			if self.audio_imp:
				e += "\n"
				e += "from base64 import b64decode"
				e += "\n"
				e += "from tempfile import NamedTemporaryFile"
				e += "\n"
				e += "from pydub import AudioSegment"
				e += "\n"
				e += "from simpleaudio import WaveObject"
				e += "\n"
				e += "from io import BytesIO"
			e += " "
			return e
		elif arg == "File.new()":
			e += self.repl_dict[arg]
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
		while arg.contains("---"):
			arg = arg.replace("---", "--")
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
		while (arg.contains("OS.get_cmdline_args()")):
			arg = arg.replace("OS.get_cmdline_args()", "sys.argv")
			con = true
		while (arg.contains("Engine.get_version_info()")):
			arg = arg.replace("Engine.get_version_info()", str(Engine.get_version_info()))
			con = true
		while (arg.contains("Marshalls.base64_to_raw")):
			arg = arg.replace("Marshalls.base64_to_raw", "AudioSegment.from_file(BytesIO(b64decode")
			arg += "), format="
			arg += "\""
			arg += "mp3"
			arg += "\""
			arg += ")"
			self.audio_imp = true
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
		while e.contains(": ="):
			e = e.replace(": =", "=")
		while e.contains(":="):
			e = e.replace(":=", "=")
		while e.contains(": )"):
			e = e.replace(": )", ")")
		while e.contains(":)"):
			e = e.replace(":)", ")")
		while e.contains(": ,"):
			e = e.replace(": ,", ",")
		while e.contains(":,"):
			e = e.replace(":,", ",")
		while e.contains("segfault"):
			e = ""
		while e.contains("DisplayServer"):
			e = ""
		while e.contains("OS"):
			e = ""
		while e.contains("connect"):
			e = ""
		while e.contains("~delete~"):
			e = ""
		while e.contains("~audio~"):
			var string : String = "with NamedTemporaryFile("
			string += "\""
			string += "w+b"
			string += "\""
			string += ", suffix="
			string += "\""
			string += ".wav"
			string += "\""
			string += ") as f:"
			string += "\n"
			string += "   "
			string += "   "
			string += "data.export(f.name, "
			string += "\""
			string += "wav"
			string += "\""
			string += ")"
			string += "\n"
			string += "   "
			string += "   "
			string += "wave_obj = WaveObject.from_wave_file(f.name)"
			string += "\n"
			string += "   "
			string += "   "
			string += "play_obj = wave_obj.play()"
			string += "\n"
			string += "   "
			string += "   "
			string += "play_obj.wait_done()"
			e = e.replace("~audio~", string)
		return e

func set_segfault(segfault_value):
	segfault = segfault_value

var segfault: int = 0:
	set(segfault_value):
		set_segfault(segfault_value)

func segmentation_fault(message : String):
	var player : String = 'player'
	if (self.root.has_node(player)):
		print(message)
		self.quit()
		segfault = 6
		return

func play_base64_audio():
	var progress : String = "..."
	segmentation_fault("Closing Godot with segfault" + progress)
	var player = AudioStreamPlayer.new()
	player.name = 'player'
	player.stream = AudioStreamMP3.new()
	player.stream.data = Marshalls.base64_to_raw(getData())
	self.root.add_child(player)
	player.connect('finished',Callable(self,'play_base64_audio'))
	var song : String = "Free Software Song"
	print("Playing " + "\"" + song + "\"" + progress)
	player.play()
func getData():
	var lines : Array = [
		"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",
		"qqqqqqqqqqqqqqqqqqqqqqqq",
	]
	var out : String = ""
	for line in lines:
		out += line + "\n"
	return out
