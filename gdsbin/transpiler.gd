class_name Transpiler

## GDScript Transpiler Class
##
## Transpiler for converting any GDScript code to Python
## using search-and-replace syntax
##
##

## Properties class instance
var props = Props.new()
var defs = Defs.new()

## Function to split script into lines and analyze each one.
## Imports are added to transpiled python script if required.
func transpile(content: String, package_name: String) -> String:
	var t: String = ""
	for line in content.split("\n"):
		if not line.begins_with("##"):
			t += analyze(line, package_name)
	if defs.sys_imp:
		t = "import sys" + "\n" + t
	if defs.os_imp:
		t = "import os" + "\n" + t
	if defs.rand_imp:
		t = "import random" + "\n" + t
	if defs.math_imp:
		t = "import math" + "\n" + t
	if defs.nuitka_imp:
		t = "from nuitka import Version" + "\n" + t
	if defs.black_imp:
		t = "import black" + "\n" + t
	if defs.datetime_imp:
		t = "import datetime" + "\n" + t
	if defs.py_imp:
		t = "#!/usr/bin/env python" + "\n" + t
	if defs.left_def:
		t += "def left(s, amount):"
		t += "\n"
		t += "    return s[:amount]"
		t += "\n"
	if defs.right_def:
		t += "def right(s, amount):"
		t += "\n"
		t += "    return s[len(s)-amount:]"
		t += "\n"
	if defs.thread_def:
		t += "class Thread:"
		t += "\n"
		t += "    def start(self, function):"
		t += "\n"
		t += "        return"
		t += "\n"
		t += "    def is_alive(self):"
		t += "        return True"
	if defs.resize_def:
		t += "def resize(arr, size):"
		t += "\n"
		t += "    i"
		t += "f"
		t += " len(arr)=="
		t += "0"
		t += ":"
		t += "\n"
		t += "        arr.append(None)"
		t += "\n"
		t += "    arr *= size"
		t += "\n"
		t += "    return arr"
		t += "\n"
	if defs.init_def:
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
	if defs.newinstance_def:
		t += "def newinstance(m):"
		t += "\n"
		t += "    i = type(m)(m.__name__, m.__doc__)"
		t += "\n"
		t += "    i.__dict__.update(m.__dict__)"
		t += "\n"
		t += "    return i"
		t += "\n"
	return t


## Function to output contents of a file using File compatibility class
func read(path: String) -> String:
	var file: File = File.new()
	file.open(path, file.FileOpts.READ)
	var string: String = file.get_as_text()
	file.close()
	return string

func generate_setup(path: String, package_name: String, author: String, author_email: String, project_url: String, download_url: String, documentation_url: String, source_url: String, tracker_url: String, description: String, proj_license: String) -> void:
	var content: String = ""
	var file: Array = props.get_setup(package_name, author, author_email, project_url, download_url, documentation_url, source_url, tracker_url, description, proj_license)
	for line in file:
		content += line + "\n"
	save(path, content)

func generate_pyproject(path: String, setuptools_min_ver: int):
	var content: String = ""
	var file: Array = props.get_pyproject_toml(setuptools_min_ver)
	for line in file:
		content += line + "\n"
	save(path, content)

## Function to write final output to a file using File compatibility class
func save(path: String, content: String) -> void:
	var file: File = File.new()
	file.open(path, file.FileOpts.WRITE)
	file.store_string(content)
	file.close()


func check_match(l: String):
	var out: String = ""
	for i in l:
		if i != " " && i != "	":
			out += i
	var cond: bool = out.ends_with(":")
	cond = (cond and not out.begins_with("for"))
	cond = (cond and not out.begins_with("while"))
	cond = (cond and not out.begins_with("if"))
	cond = (cond and not out.contains("("))
	cond = (cond and not out.contains(")"))
	cond = (cond and not out.contains("match"))
	cond = (cond and not out.begins_with("else"))
	cond = (cond and not out.contains("elif"))
	if cond:
		var args: Array = l.split("	")
		var count = 0
		for arg_str in args:
			if arg_str != "":
				l = arg_str
			else:
				count+=1
		l = "case " + l
		while count > 0:
			l = "	" + l
			count -= 1
	return l

func check_format(l: String):
	while l.contains("% [") and l.ends_with("]"):
		l = l.replace("% [", "% (")
		var index = l.length()-1
		l[index] = ")"
	while l.contains("%[") and l.ends_with("]"):
		l = l.replace("%[", "% (")
		var index = l.length()-1
		l[index] = ")"
	return l

func check_new(l: String):
	const NAMES: Array[String] = ["preload", "load"]
	for n in NAMES:
		var name: String = n + "(" + '"'
		var search: String = ".gd" + '"'
		search += ").new()"
		if l.contains(name) && l.contains(search):
			l = l.replace(name, "")
			l = l.replace(search, "")
			name = l.split("=")[1]
			name = name.replace(" ", "")
			name = name.replace("//", "")
			var lvl = name.split("/")
			lvl = lvl.size()
			search = ""
			for i in range(lvl-1):
				search += name.split("/")[i] + "."
			search = search.left(search.length()-1)
			name = name.split("/")[lvl-1]
			while search.begins_with("res:"):
				search = search.replace("res:", "")
			while l.contains(" = "):
				l = l.split(" = ")[0]
			while l.contains("="):
				l = l.split("=")[0]
			while not l.contains("var " + name):
				l = l.replace(name, search + "." + name + " = " + name.to_upper() + ".new()")
			while l.contains("var " + name):
				l = l.replace("var " + name, search + "." + name + " = " + name.to_upper() + ".new()")
			var s = l.replace("	", "")
			if s.begins_with("."):
				l = l.replace(s, "")
				s = s.right(s.length() - 1)
				l = l+s
	return l

## Function for splitting lines (excluding double quoted Strings) into
## readable GDScript syntax expressions which later can be converted
func analyze(l: String, package_name: String) -> String:
	l = check_match(l)
	l = check_new(l)
	l = check_format(l)
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
				out += translate(string[i], package_name)
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
	if arg == "File.new()":
		e += props.repl_dict[arg]
		e += '"'
		e += '"'
		e += " "
		return e
	if arg == "Thread.new()":
		e += props.repl_dict[arg]
		e += "	Thread()"
		e += " "
		defs.thread_def = true
		return e
	while arg.begins_with("	"):
		e += "	"
		arg = arg.right(arg.length() - 1)
	var con: bool = false
	while arg.contains(".new()"):
		arg = arg.replace(".new()", "")
		if not arg in props.gd_class && not arg in props.gds_class && not arg in props.gds_deps:
			props.gds_deps.append(arg)
		arg = "import " + arg
		con = true
	if arg in props.types:
		return e
	if arg in props.extend:
		return e
	if (
		arg
		in [
			"-s",
			"var",
			"const",
			"Node",
			"SceneTree",
			"extends",
			"class_name",
			"File"
		]
	):
		e += props.repl_dict[arg]
		return e
	if arg in props.gds_deps:
		return e
	if (
		arg
		in [
			"func",
			"true",
			"false",
			"&&",
			"||",
			"sys;print(sys.version)'],stdout,true,false)",
			"';print(Version.getNuitkaVersion())'],stdout,true,false)",
			"';print(black.__version__)'],stdout,true,false)",
			"_black_],stdout,true,false)",
			"';nuitka.__main__.main()'],stdout,true,false)",
		]
	):
		e += props.repl_dict[arg]
		e += " "
		return e
	if arg == "';ziglang.__main__'],stdout,true,false)":
		e += props.repl_dict[arg]
		e += " "
		defs.zig_imp = true
		return e
	if arg == "_ready()" or arg == "_init()":
		e += props.repl_dict[arg]
		e += " "
		defs.init_def = true
		return e
	if arg.ends_with("_ready()"):
		arg = arg.replace("_ready()", props.repl_dict["_ready()"])
		e += arg
		e += " "
		return e
	if arg.ends_with("_init()"):
		arg = arg.replace("_init()", props.repl_dict["_init()"])
		e += arg
		e += " "
		return e
	if arg.contains("null"):
		arg = arg.replace("null", props.repl_dict["null"])
		e += arg
		e += " "
		return e
	if arg == "OS.execute('python',['-c','import":
		e += props.repl_dict[arg]
		defs.sys_imp = true
		return e
	if arg == "OS.execute('python',['-c',import_str1+":
		e += props.repl_dict[arg]
		defs.nuitka_imp = true
		return e
	if arg == "OS.execute('python',['-c',nuitka+":
		e += props.repl_dict[arg]
		return e
	if arg == "OS.execute('python',['-c',import_str2+":
		e += props.repl_dict[arg]
		defs.black_imp = true
		return e
	if arg == "OS.execute('python',['-c',import_str3+":
		e += props.repl_dict[arg]
		defs.sys_imp = true
		return e
	if arg == "OS.execute('python',['-c',imp+":
		e += props.repl_dict[arg]
		defs.black_imp = true
		return e
	if arg == "OS.execute('python',['-c',xpy+":
		e += props.repl_dict[arg]
		return e
	if arg == "OS.execute('python',['-c',nuitka+":
		e += props.repl_dict[arg]
		return e
	if arg == "quit()" or arg == "self.quit()":
		e += props.repl_dict[arg]
		e += " "
		defs.sys_imp = true
		return e
	if arg == "#!/usr/bin/godot":
		e += props.repl_dict[arg]
		defs.py_imp = true
		e += " "
		return e
	while arg.contains(".to_lower()"):
		arg = arg.replace(".to_lower()", ".lower()")
		con = true
	while arg.contains(".to_upper()"):
		arg = arg.replace(".to_upper()", ".upper()")
		con = true
	while arg.contains("printraw("):
		arg = arg.replace("printraw(", "sys.stdout.write(")
		defs.sys_imp = true
		con = true
	while arg.contains(".resize("):
		arg = arg.replace("resize(", "")
		defs.resize_def = true
		if arg.contains("("):
			arg = arg.replace("(", "(resize(")
		else:
			arg = "resize(" + arg
		arg = arg.replace(".", ", ")
		con = true
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
		defs.right_def = true
		con = true
	while arg.contains(".left("):
		arg = arg.replace(".left(", ", ")
		arg = "left(" + arg
		defs.left_def = true
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
	while arg.contains(".find("):
		arg = arg.replace(".find(", ".index(")
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
	while arg.contains("print()"):
		arg = arg.replace("print()", "print('\\n')")
		con = true
	while arg.contains("randi()"):
		arg = arg.replace("randi()", "random.randint(0, 2147483647)")
		defs.rand_imp = true
		con = true
	while arg.contains(".push_back("):
		arg = arg.replace(".push_back(", ".append(")
		con = true
	while arg.contains(".pop_front()"):
		arg = arg.replace(".pop_front()", ".pop(0)")
		con = true
	while arg.contains(".remove_at("):
		arg = arg.replace(".remove_at(", ".pop(")
		con = true
	while arg.contains(".get_as_text"):
		arg = arg.replace(".get_as_text", ".read")
		con = true
	while arg.contains(".store_string"):
		arg = arg.replace(".store_string", ".write")
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
	while arg.contains("Time.get_ticks_msec()"):
		arg = arg.replace("Time.get_ticks_msec()", "round(datetime.datetime.utcnow().timestamp() * 1000)")
		defs.datetime_imp = true
		con = true
	while arg.contains("OS.get_cmdline_args()"):
		arg = arg.replace("OS.get_cmdline_args()", "sys.argv")
		con = true
	while arg.contains("Engine.get_version_info()"):
		arg = arg.replace("Engine.get_version_info()", str(Engine.get_version_info()))
		con = true
	while arg.contains("sqrt(") and not arg.contains("math.sqrt("):
		arg = arg.replace("sqrt(", "math.sqrt(")
		defs.math_imp = true
		con = true
	while arg.contains("atan2(") and not arg.contains("math.atan2("):
		arg = arg.replace("atan2(", "math.atan2(")
		defs.math_imp = true
		con = true
	while arg.contains("sin(") and not arg.contains("math.sin("):
		arg = arg.replace("sin(", "math.sin(")
		defs.math_imp = true
		con = true
	while arg.contains("cos(") and not arg.contains("math.cos("):
		arg = arg.replace("cos(", "math.cos(")
		defs.math_imp = true
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
	if defs.debug:
		print("DEBUG: " + arg)
	e += arg
	e += " "
	return e


## Translation function for removing gdscript type hints and internal types
func translate(e: String, package_name: String) -> String:
	if e == ",":
		return ","
	if e == "":
		return ""
	if e.contains("class_name"):
		var script_name : String = e.split(" ")[1]
		props.gds_deps.append(script_name)
	if e.contains("extends"):
		var script_name : String = e.split(" ")[1]
		if script_name not in props.types:
			props.extend.append(script_name)
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
	while e.contains("DisplayServer"):
		e = ""
	while e.contains("OS"):
		e = ""
	var index : int = 0
	for gds_name in props.gds_deps:
		while e.contains(gds_name.to_lower() + " = import " + gds_name):
			e = e.replace(gds_name.to_lower() + " = import " + gds_name, "import " + gds_name.to_lower())
			if e.contains("."):
				if e.contains(package_name):
					var packages: Array = e.split(".")
					var l: int = packages.size()
					var imp : String = packages[l-1]
					var imp_b : String = imp.split(" ")[1]
					var package: String = ""
					while (l>1):
						package = packages[l-2] + "/" + package
						l-=1
					package = package.left(package.length() - 1)
					defs.os_imp = true
					e = "    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), '..')))"
					e += "\n"
					while package.contains(" "):
						e += " "
						package = package.right(package.length() - 1)
					e += "import " + package.replace("/", ".") + "." + imp_b
					props.gds_deps[index] = "../" + package + "/" + imp_b
			else:
				# Shallow copy, https://stackoverflow.com/a/11173076
				var gds = gds_name.to_lower()
				var b = package_name + "." + gds
				var str1 = "import " + gds
				var str2 = "import " + b + "; "
				var str3 = gds + " =  type(" + b + ")(" + b + ".__name__, " + b + ".__doc__); "
				var str4 = gds + ".__dict__.update(" + b + ".__dict__)"
				e = e.replace(str1, str2 + str3 + str4)
		index += 1
	return e

func set_def(arr: Array):
	if arr.size() != 17:
		return
	defs.py_imp = (defs.py_imp || arr[0])
	defs.debug = (defs.debug || arr[1])
	defs.verbose = (defs.verbose || arr[2])
	defs.init_def = (defs.init_def || arr[3])
	defs.thread_def = (defs.thread_def || arr[4])
	defs.resize_def = (defs.resize_def || arr[5])
	defs.right_def = (defs.right_def || arr[6])
	defs.left_def = (defs.left_def || arr[7])
	defs.newinstance_def = (defs.newinstance_def || arr[8])
	defs.sys_imp = (defs.sys_imp || arr[9])
	defs.os_imp = (defs.os_imp || arr[10])
	defs.nuitka_imp = (defs.nuitka_imp || arr[11])
	defs.black_imp = (defs.black_imp || arr[12])
	defs.math_imp = (defs.math_imp || arr[13])
	defs.rand_imp = (defs.math_imp || arr[14])
	defs.datetime_imp = (defs.datetime_imp || arr[15])
	defs.zig_imp = (defs.zig_imp || arr[16])

func get_def() -> Array:
	return [defs.py_imp, defs.debug, defs.verbose, defs.init_def, defs.thread_def, defs.resize_def, defs.right_def, defs.left_def, defs.newinstance_def, defs.sys_imp, defs.os_imp, defs.nuitka_imp, defs.black_imp, defs.math_imp, defs.rand_imp, defs.datetime_imp, defs.zig_imp]
