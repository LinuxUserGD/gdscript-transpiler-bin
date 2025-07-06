class_name Application

## GDScript Execute compatibility class
##
## GDScript Wrapper class for OS execute

func execute(program: String, args: Array) -> Array:
	var stdout: Array = []
	OS.execute(program,args,stdout)
	return stdout

func execute_pipe(program: String, args: Array) -> void:
	var info: Dictionary = OS.execute_with_pipe(program,args)
	if info["stdio"]:
		_create_thread(info["stdio"])

func _create_thread(pipe: Object):
	var main: Callable = Callable(self, "_start_thread").bind(pipe)
	var thread: Thread  = Thread.new()
	thread.start(main)
	thread.wait_to_finish()
	pipe.close()

func _start_thread(pipe: Object) -> void:
	var line: String = ""
	while pipe.is_open() and pipe.get_error() == OK:
		var c: String = char(pipe.get_8())
		if c == "\n":
			print(line)
			line = ""
		else:
			line += c
