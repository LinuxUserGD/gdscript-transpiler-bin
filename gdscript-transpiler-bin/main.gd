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
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d


## Runs once when executed, prints different output to console depending on argument
func _init() -> void:
	var editor: String = OS.get_cmdline_args()[0]
	var editor_compare: String = "res://main.tscn"
	if editor == editor_compare && OS.get_cmdline_args().size() == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif OS.get_cmdline_args().size() != 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	for arg in OS.get_cmdline_args():
		if arg == "--version":
			version()
			self.quit()
			return
		if arg == "--help":
			help()
			self.quit()
			return
		if arg == "--test=base64_audio":
			play_base64_audio()
			return
		if arg == "--test=vector2":
			run_vector2()
			self.quit()
			return
		var path_arg: String = "--path="
		if arg.begins_with(path_arg):
			start(arg)
			self.quit()
			return
	help()
	self.quit()
	return


## Function for transpiling script (by path)
func start(arg: String) -> void:
	var path: String = "res://" + arg.split("=")[1]
	var args = arg.split("=")[1].split(".")
	var c: int = args.size()
	var pathstr: String = ""
	for path_str in arg.split("=")[1].split("."):
		c -= 1
		if c != 0:
			pathstr += path_str + "."
	var path2: String = "res://" + pathstr + "py"
	var transpiler = Transpiler.new()
	var content: String = transpiler.read(path)
	var out: String = transpiler.transpile(content)
	if transpiler.props.verbose:
		print(out)
	transpiler.save(path2, out)


## Prints Python and Godot Engine version information to console
func version() -> void:
	var info: Dictionary = Engine.get_version_info()
	var major: int = info.get("major")
	var minor: int = info.get("minor")
	var status: String = info.get("status")
	var build: String = info.get("build")
	var id: String = info.get("hash")
	print("GDScript2PythonTranspiler")
	print("Godot: " + str(major) + "." + str(minor) + "." + status + "." + build + "." + id.left(9))
	var stdout: Array = []
	OS.execute('python',['-c','import sys;print(sys.version)'],stdout,true,false)
	print("Python: " + stdout[0].split("\n")[0])
	stdout.clear()
	var import_str: String = "from nuitka import Version"
	OS.execute('python',['-c',import_str+ ';print(Version.getNuitkaVersion())'],stdout,true,false)
	print("Nuitka: " + stdout[0].split("\n")[0])


## Help function which prints all possible commands
func help() -> void:
	print("Usage: main [options]")
	print("\n")
	print("Options:")
	print("  " + "--version" + "                   " + "show program's version number and exit")
	print("  " + "--help" + "                      " + "show this help message and exit")
	print("  " + "--path=../path/to/file.gd" + "   " + "path to GDScript file")
	print("  " + "--test=base64_audio" + "         " + "play base64 encoded audio file")
	print("  " + "--test=vector2" + "              " + "testing Vector2 implementation")


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
