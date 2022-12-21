class_name Transpiler

## GDScript Transpiler Class
##
## Transpiler for converting any GDScript code to Python
## using search-and-replace syntax
##
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-transpiler-py

## Properties class instance
var props = Props.new()


## Function to split script into lines and analyze each one.
## Imports are added to transpiled python script if required.
func transpile(content: String) -> String:
	props.types.sort()
	var t = ""
	for line in content.split("\n"):
		if not line.begins_with("##"):
			t += analyze(line)
	if props.math_imp:
		t = "import math" + "\n" + t
	if props.left_def:
		t += "def left(s, amount):"
		t += "\n"
		t += "    return s[:amount]"
		t += "\n"
	if props.right_def:
		t += "def right(s, amount):"
		t += "\n"
		t += "    return s[len(s)-amount:]"
		t += "\n"
	if props.init_def:
		t += "i"
		t += "f"
		t += " __name__=="
		t += '"'
		t += "__main__"
		t += '"'
		t += ":"
		t += "\n"
		t += "    _init()"
		t += "\n"
	return t


## Function to output contents of a file using File compatibility class
func read(path: String) -> String:
	var file: File = File.new()
	file.open(path, file.FileOpts.READ)
	var string: String = file.get_as_text()
	file.close()
	return string


## Function to write final output to a file using File compatibility class
func save(path: String, content: String) -> void:
	var file: File = File.new()
	file.open(path, file.FileOpts.WRITE)
	file.store_string(content)
	file.close()


## Function for splitting lines (excluding double quoted Strings) into readable GDScript syntax expressions which later can be converted
func analyze(l: String) -> String:
	var out: String = ""
	var quote: String = "'"
	quote += '"'
	quote += "'"
	var string_prev: Array = l.split(quote)
	var c: int = 0
	for ii in range(0, string_prev.size()):
		var string: Array = string_prev[ii].split('"')
		if ii > 0:
			out += "'"
			out += '"'
			out += "'"
		for i in range(0, string.size()):
			if ii > 0:
				out += string[i]
			elif c ^ 1 != c + 1:
				out += '"' + string[i] + '"'
			else:
				out += translate(string[i])
			c += 1
	if out.length() > 0:
		var res: String = "res"
		res += "://"
		while out.contains(res):
			out = out.replace(res, "")
		while out.contains("if") and out.ends_with('"'):
			out += ":"
		if out.ends_with(" "):
			out = out.left(out.length() - 1)
		out += "\n"
	return out


## Dictionary function which converts known GDScript arguments
func dict(arg: String) -> String:
	var e: String = ""
	if arg.length() == 0:
		return e
	if arg in props.op:
		e += arg
		e += " "
		return e
	while arg.begins_with("	"):
		e += "	"
		arg = arg.right(arg.length() - 1)
	if arg in props.types:
		return e
	elif (
		arg
		in [
			"-s",
			"var",
			"Node",
			"SceneTree",
			"Main",
			"Props",
			"Audio",
			"Version",
			"Transpiler",
			"VECTOR2",
			"extends",
			"class_name",
			"File"
		]
	):
		e += props.repl_dict[arg]
		return e
	elif (
		arg
		in [
			"func",
			"true",
			"false",
			"&&",
			"||",
			"sys;print(sys.version)'],stdout,true,false)",
			"';print(Version.getNuitkaVersion())'],stdout,true,false)",
			"';print(autopep8.__version__)'],stdout,true,false)",
			"';autopep8.main()'],stdout,true,false)",
			"';xpython.__main__.main()'],stdout,true,false)",
			"self.root.has_node(player):",
			"self.root.add_child(player)",
			"player",
			"player.name",
			"player.stream",
			"player.stream.data",
			"player.play()"
		]
	):
		e += props.repl_dict[arg]
		e += " "
		return e
	elif arg.begins_with("_ready()") or arg.begins_with("_init()"):
		e += props.repl_dict[arg]
		e += " "
		props.init_def = true
		return e
	elif arg == "OS.execute('python',['-c','import":
		e += props.repl_dict[arg]
		props.sys_imp = true
		return e
	elif arg == "OS.execute('python',['-c',import_str1+":
		e += props.repl_dict[arg]
		props.nuitka_imp = true
		return e
	elif arg == "OS.execute('python',['-c',import_str2+":
		e += props.repl_dict[arg]
		props.autopep8_imp = true
		return e
	elif arg == "OS.execute('python',['-c',imp+":
		e += props.repl_dict[arg]
		props.autopep8_imp = true
		return e
	elif arg == "OS.execute('python',['-c',xpy+":
		e += props.repl_dict[arg]
		props.xpython_imp = true
		return e
	elif arg == "quit()" or arg == "self.quit()":
		e += props.repl_dict[arg]
		e += " "
		props.sys_imp = true
		return e
	elif arg == "#!/usr/bin/godot":
		e += props.repl_dict[arg]
		if props.sys_imp:
			e += "\n"
			e += "import sys"
		if props.nuitka_imp:
			e += "\n"
			e += "from nuitka import Version"
		if props.autopep8_imp:
			e += "\n"
			e += "import autopep8"
		if props.xpython_imp:
			e += "\n"
			e += "import xpython.__main__"
		if props.audio_imp:
			e += "\n"
			e += "from os import remove"
			e += "\n"
			e += "from base64 import b64decode"
			e += "\n"
			e += "from pydub import AudioSegment"
			e += "\n"
			e += "from pydub.playback import play"
			e += "\n"
			e += "from io import BytesIO"
		e += " "
		return e
	elif arg == "File.new()":
		e += props.repl_dict[arg]
		e += '"'
		e += '"'
		e += " "
		return e
	var con: bool = false
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
		props.right_def = true
		con = true
	while arg.contains(".left("):
		arg = arg.replace(".left(", ", ")
		arg = "left(" + arg
		props.left_def = true
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
	while arg.contains("file.FileOpts.READ"):
		var r: String = ""
		r += '"'
		r += "r"
		r += '"'
		arg = arg.replace("file.FileOpts.READ", r)
		con = true
	while arg.contains("file.FileOpts.WRITE"):
		var w: String = ""
		w += '"'
		w += "w"
		w += '"'
		arg = arg.replace("file.FileOpts.WRITE", w)
		con = true
	while arg.contains(".get_as_text"):
		arg = arg.replace(".get_as_text", ".read")
		con = true
	while arg.contains(".store_string"):
		arg = arg.replace(".store_string", ".write")
		con = true
	while arg.contains(".new()"):
		arg = arg.replace(".new()", "")
		arg = "import " + arg
		con = true
	while arg.contains(".clear()"):
		arg = arg.replace(".clear()", " = []")
		con = true
	while arg.contains("_self,"):
		arg = arg.replace("_self,", "")
		con = true
	while arg.contains("_self"):
		arg = arg.replace("_self", "self")
		con = true
	while arg.contains("OS.get_cmdline_args()"):
		arg = arg.replace("OS.get_cmdline_args()", "sys.argv")
		con = true
	while arg.contains("Engine.get_version_info()"):
		arg = arg.replace("Engine.get_version_info()", str(Engine.get_version_info()))
		con = true
	while arg.contains("sqrt(") and not arg.contains("math.sqrt("):
		arg = arg.replace("sqrt(", "math.sqrt(")
		props.math_imp = true
		con = true
	while arg.contains("atan2(") and not arg.contains("math.atan2("):
		arg = arg.replace("atan2(", "math.atan2(")
		props.math_imp = true
		con = true
	while arg.contains("sin(") and not arg.contains("math.sin("):
		arg = arg.replace("sin(", "math.sin(")
		props.math_imp = true
		con = true
	while arg.contains("cos(") and not arg.contains("math.cos("):
		arg = arg.replace("cos(", "math.cos(")
		props.math_imp = true
		con = true
	while arg.contains("Marshalls.base64_to_raw"):
		arg = arg.replace("Marshalls.base64_to_raw", "AudioSegment.from_file(BytesIO(b64decode")
		arg += "), format="
		arg += '"'
		arg += "mp3"
		arg += '"'
		arg += ")"
		props.audio_imp = true
		con = true
	var found: bool = false
	for type in props.types:
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
	if props.debug:
		print("DEBUG: " + arg)
	e += arg
	e += " "
	return e


## Translation function for removing gdscript type hints and internal types
func translate(e: String) -> String:
	if e == ",":
		return ","
	if e == "":
		return ""
	var args: Array = e.split(" ")
	e = ""
	for arg in args:
		e += dict(arg)
	while e.contains("	"):
		e = e.replace("	", "    ")
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
	while e.contains(" -> "):
		e = e.replace(" -> ", "")
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
	while e.contains("transpiler = import Transpiler"):
		e = e.replace("transpiler = import Transpiler", "import transpiler")
	while e.contains("props = import Props"):
		e = e.replace("props = import Props", "import props")
	while e.contains("audio = import Audio"):
		e = e.replace("audio = import Audio", "import audio")
	while e.contains("version = import Version"):
		e = e.replace("version = import Version", "import version")
	while e.contains("vector2 = import VECTOR2"):
		e = e.replace("vector2 = import VECTOR2", "import vector2")
	return e
