#!/usr/bin/godot -s

extends SceneTree
class_name Main

## GDScript Transpiler Script
##
## Wrapper script using transpiler for converting any GDScript code to Python
## (including the transpiler script)
## using search-and-replace syntax
##
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-__main__-py


## Runs once when executed, prints different output to console depending on argument
func _init() -> void:
	var editor: String = OS.get_cmdline_args()[0]
	var editor_compare: String = "res://main.tscn"
	if editor == editor_compare && OS.get_cmdline_args().size() == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif OS.get_cmdline_args().size() != 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	var index: int = -1
	for arg in OS.get_cmdline_args():
		index += 1
		if arg == "version":
			version_info()
			self.quit()
			return
		if arg == "help":
			help()
			self.quit()
			return
		if arg == "test=base64_audio":
			play_base64_audio()
			return
		if arg == "test=vector2":
			run_vector2()
			self.quit()
			return
		var path_arg: String = "run="
		if arg.begins_with(path_arg):
			start(arg)
			run(arg, index)
			self.quit()
			return
		var path_exp_arg: String = "path_exp="
		if arg.begins_with(path_exp_arg):
			start_exp(arg)
			self.quit()
			return
		var compile_arg = "compile="
		if arg.begins_with(compile_arg):
			start(arg)
			compile(arg, index)
			self.quit()
			return
	help()
	self.quit()
	return

## Function for compiling python script (by path)
func compile(arg: String, index: int) -> void:
	var path_end: String = arg.split("=")[1]
	var args = path_end.split(".")
	var c: int = args.size()
	var pathstr: String = ""
	for path_str in args:
		c -= 1
		if c != 0:
			pathstr += path_str + "."
	var nuitka: String = "import nuitka.__main__;"
	nuitka += "import sys;"
	nuitka += "x='python';"
	nuitka += "y='"
	nuitka += pathstr
	nuitka += "py"
	nuitka += "';"
	nuitka += "z='"
	nuitka += "--onefile"
	nuitka += "';"
	nuitka += "sys.argv=[x,y,z]"
	var stdout: Array = []
	print("Compiling " + pathstr + "py...")
	OS.execute('python',['-m','xpython','-c',nuitka+ ';nuitka.__main__.main()'],stdout,true,false)
	if stdout.size() > 0:
		for out_str in stdout[0].split("\n"):
			if out_str.length() > 0:
				print(out_str)

## Function for running python script (by path)
func run(arg: String, index: int) -> void:
	var path_end: String = arg.split("=")[1]
	var args = path_end.split(".")
	var c: int = args.size()
	var pathstr: String = ""
	for path_str in args:
		c -= 1
		if c != 0:
			pathstr += path_str + "."
	print("Running " + pathstr + "py...")
	var xpy: String = "import xpython.__main__;"
	xpy += "import sys;"
	xpy += "x='python';"
	xpy += "y='"
	xpy += pathstr
	xpy += "py"
	xpy += "';"
	xpy += "sys.argv=[x,y"
	var add_args: Array = []
	var new_args: Array = OS.get_cmdline_args()
	while (new_args.size()-1 > index):
		index += 1
		add_args.append(OS.get_cmdline_args()[index])
	for some_arg in add_args:
		xpy += ","
		xpy += "'"
		xpy += some_arg
		xpy += "'"
	xpy += "]"
	var stdout: Array = []
	OS.execute('python',['-c',xpy+ ';xpython.__main__.main()'],stdout,true,false)
	for out_str in stdout[0].split("\n"):
		if out_str.length() > 0:
			print(out_str)

## Alternative function for transpiling script (by path)
func start_exp(arg: String) -> void:
	var path_end: String = arg.split("=")[1]
	var path: String = "res://" + path_end
	var transpiler = Transpiler.new()
	var content: String = transpiler.read(path)
	var tokenizer = Tokenizer.new()
	for line in content.split("\n"):
		var tokens : Array = tokenizer.tokenize(line)
		print(tokens)

## Function for transpiling script (by path)
func start(arg: String) -> void:
	var path_end: String = arg.split("=")[1]
	var path: String = "res://" + path_end
	var args = path_end.split(".")
	var c: int = args.size()
	var pathstr: String = ""
	for path_str in args:
		c -= 1
		if c != 0:
			pathstr += path_str + "."
	print("Transpiling " + pathstr + "gd...")
	var path2: String = "res://" + pathstr + "py"
	var transpiler = Transpiler.new()
	var content: String = transpiler.read(path)
	var out: String = transpiler.transpile(content)
	if transpiler.props.verbose:
		print(out)
	transpiler.save(path2, out)
	print("Formatting " + pathstr + "py...")
	var stdout: Array = []
	var imp: String = "import autopep8;"
	imp += "import sys;"
	imp += "x='python';"
	imp += "y='-i';"
	imp += "z='"
	imp += pathstr
	imp += "py"
	imp += "';"
	imp += "sys.argv=[x,y,z]"
	OS.execute('python',['-m','xpython','-c',imp+ ';autopep8.main()'],stdout,true,false)


## Prints Python and Godot Engine version information to console
func version_info() -> void:
	var info: Dictionary = Engine.get_version_info()
	var major: int = info.get("major")
	var minor: int = info.get("minor")
	var status: String = info.get("status")
	var build: String = info.get("build")
	var id: String = info.get("hash")
	var version = Version.new()
	print("GDScript2PythonTranspiler " + version.__version__ + "\n")
	print("Godot " + str(major) + "." + str(minor) + "." + status + "." + build + "." + id.left(9))
	var stdout: Array = []
	
	OS.execute('python',['-m','xpython','-c','import sys;print(sys.version)'],stdout,true,false)
	print("Python " + stdout[0].split("\n")[0])
	stdout.clear()
	var import_str1: String = "from nuitka import Version"
	OS.execute('python',['-m','xpython','-c',import_str1+ ';print(Version.getNuitkaVersion())'],stdout,true,false)
	print("Nuitka " + stdout[0].split("\n")[0])
	stdout.clear()
	var import_str2: String = "import autopep8"
	OS.execute('python',['-m','xpython','-c',import_str2+ ';print(autopep8.__version__)'],stdout,true,false)
	print("autopep8 " + stdout[0].split("\n")[0])
	stdout.clear()

## Help function which prints all possible commands
func help() -> void:
	print("Usage: gds [options]")
	print("\n")
	print("Options:")
	print("  " + "version" + "                   " + "show program's version number and exit")
	print("  " + "help" + "                      " + "show this help message and exit")
	print("  " + "run=../path/to/file.gd" + "   " + "run GDScript file directly using x-python")
	print("  " + "compile=../path/to/file.gd" + "   " + "compile GDScript file to binary using GCC/Nuitka")
	print("  " + "test=base64_audio" + "         " + "play base64 encoded audio file")
	print("  " + "test=vector2" + "              " + "testing Vector2 implementation")


## Function for setting the value which segfaults Godot
func set_segfault(segfault_value) -> void:
	segfault = segfault_value


## Hack to quit Godot using segfault bug
var segfault: int = 0:
	set(segfault_value):
		set_segfault(segfault_value)


## Godot quits with segfault if function is run twice
func segmentation_fault(message: String) -> void:
	var player: String = "player"
	if self.root.has_node(player):
		print(message)
		self.quit()
		segfault = 6
		return

## Testing Vector2 implementation
func run_vector2() -> void:
	var vector2 = VECTOR2.new()
	vector2.x = 3
	print("x -> " + str(vector2.x))
	vector2.y = 5
	print("y -> " + str(vector2.y))
	print("angle() -> " + str(vector2.angle()))
	var vector2_res = vector2.from_angle(30)
	print("from_angle(30) -> " + "(" + str(vector2_res.x) + ", " + str(vector2_res.y) + ")")
	print("vec_length() -> " + str(vector2.vec_length()))
	print("length_squared() -> " + str(vector2.length_squared()))
	# Class instance not working yet in Python, see https://stackoverflow.com/a/7616959
	vector2.x = 3
	vector2.y = 5
	var vector2_res2 = vector2.normalized()
	print("normalized() -> " + "(" + str(vector2_res2.x) + ", " + str(vector2_res2.y) + ")")
	print("is_normalized() -> " + str(vector2_res2.is_normalized()))
	print("distance_to() -> " + str(vector2.distance_to(vector2)))
	print("distance_squared_to() -> " + str(vector2.distance_squared_to(vector2)))
	print("angle_to() -> " + str(vector2.angle_to(vector2, vector2)))
	print("angle_to_point() -> " + str(vector2.angle_to_point(vector2, vector2)))
	vector2.x = 3
	vector2.y = 5
	print("dot() -> " + str(vector2.dot(vector2, vector2)))
	print("cross() -> " + str(vector2.cross(vector2, vector2)))
	var vec_rot = vector2.rotated(vector2, 1)
	print("rotated() -> " + "(" + str(vec_rot.x) + ", " + str(vec_rot.y) + ")")
	vector2.x = 3
	vector2.y = 5
	var vec_proj = vector2.project(vector2, vector2)
	print("project() -> " + "(" + str(vec_proj.x) + ", " + str(vec_proj.y) + ")")
	vector2.x = 3
	vector2.y = 5
	var vec_lim = vector2.limit_length(vector2, 2)
	print("limit_length() -> " + "(" + str(vec_lim.x) + ", " + str(vec_lim.y) + ")")


## Method for decoding and playing base64 audio
func play_base64_audio() -> void:
	var progress: String = "..."
	segmentation_fault("Closing Godot with segfault" + progress)
	var player = AudioStreamPlayer.new()
	player.name = 'player'
	player.stream = AudioStreamMP3.new()
	var audio = Audio.new()
	player.stream.data = Marshalls.base64_to_raw(audio.getData())
	self.root.add_child(player)
	player.connect('finished',Callable(self,'play_base64_audio'))
	var song: String = "Free Software Song"
	print("Playing " + '"' + song + '"' + progress)
	player.play()
