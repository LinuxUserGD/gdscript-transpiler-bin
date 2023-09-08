class_name __Main__
## GDScript Transpiler Script
##
## Wrapper script using transpiler for converting any GDScript code to Python
## (including the transpiler script)
## using search-and-replace syntax
##
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-__main__-py

## Runs once when executed, prints different output to console depending on argument
func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	var __init__ = preload("res://gdsbin/__init__.gd").new()
	for arg in OS.get_cmdline_args():
		if arg == "version":
			version_info()
			return
		if arg == "help":
			help()
			return
		if arg == "test=vector2":
			run_vector2()
			return
		if arg == "benchmark":
			run_benchmark()
			return
		if arg == "test=parser":
			run_parser()
			return
		var path_format_arg: String = "format="
		if arg.begins_with(path_format_arg) and arg.ends_with(".gd"):
			var format: bool = true
			start_stages(arg, format)
			return
		var path_exp_arg: String = "exp="
		if arg.begins_with(path_exp_arg):
			start_exp(arg)
			return
		var compile_arg = "compile="
		if arg.begins_with(compile_arg) and arg.ends_with(".gd"):
			var format: bool = true
			start_stages(arg, format)
			compile(arg)
			return
		if arg == "compile_zig":
			compile_zig()
			return
		if arg == "zig_template":
			zig_template()
			return
		var setup_arg: String = "setup="
		if arg.begins_with(setup_arg):
			var pyproject: bool = false
			setup(arg, pyproject)
			return
		var pyproject_arg: String = "pyproject="
		if arg.begins_with(pyproject_arg):
			var pyproject: bool = true
			setup(arg, pyproject)
			return
	help()
	return

## TODO: compile file with zig
func compile_zig() -> void:
	printraw("Building latest Zig toolchain from source")
	var threads = Threads.new()
	threads.start(_build)
	while(threads.is_alive()):
		OS.delay_msec(1000)
		printraw(".")
	threads.wait_to_finish()

func zig_template() -> void:
	print("Building Zig template...")
	var stdout: Array = []
	OS.execute('out/host/bin/zig',['build'],stdout,true,false)
	if(stdout.size() > 0):
		for out_str in stdout[0].split("\n"):
			if out_str.length() > 0:
				print(out_str)
	stdout = []
	OS.execute('zig-out/bin/zig-template',['test'],stdout,true,false)
	if(stdout.size() > 0):
		for out_str in stdout[0].split("\n"):
			if out_str.length() > 0:
				print(out_str)

func _build():
	var stdout: Array = []
	OS.execute('sh',['build'],stdout,true,false)


## Function for compiling python script (by path)
func compile(arg: String) -> void:
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
	nuitka += "a='"
	nuitka += "--lto=yes"
	nuitka += "';"
	nuitka += "b='"
	nuitka += "--static-libpython=no"
	nuitka += "';"
	nuitka += "c='"
	nuitka += "--clang"
	nuitka += "';"
	nuitka += "d='"
	nuitka += "--assume-yes-for-downloads"
	nuitka += "';"
	nuitka += "e='"
	# bugfix "No such file or directory: Grammar3.10.10.final.0.pickle"
	nuitka += "--include-package-data=blib2to3"
	nuitka += "';"
	nuitka += "f='"
	nuitka += "--include-package-data=ziglang"
	nuitka += "';"
	nuitka += "g='"
	nuitka += "--noinclude-data-files=ziglang/doc"
	nuitka += "';"
	nuitka += "sys.argv=[x,y,z,a,b,c,d,e,f,g]"
	var stdout: Array = []
	print("Compiling " + pathstr + "py...")
	OS.execute('python',['-c',nuitka+ ';nuitka.__main__.main()'],stdout,true,false)
	if stdout.size() > 0:
		for out_str in stdout[0].split("\n"):
			if out_str.length() > 0:
				print(out_str)

## Tokenize script (by path)
func start_exp(arg: String) -> void:
	var path_end: String = arg.split("=")[1]
	var path: String = "res://" + path_end
	var transpiler = Transpiler.new()
	var content: String = transpiler.read(path)
	var tokenizer = Tokenizer.new()
	for line in content.split("\n"):
		var tokens : Array = tokenizer.tokenize(line)
		print(tokens)

## Wrapper function for start()
func start_stages(argum: String, format: bool) -> void:
	var f: bool = false
	start(argum, f)
	start(argum, format)

## Format function
func form(stdout: Array, imp: String, _imp_string: String):
	OS.execute('python',['-c',imp+ ';black.reformat_one(src=src,fast=False,write_back=write_back,mode=mode,report=report)'],stdout,true,false)
	return stdout

## Function for saving setup.py
func setup(arg: String, pyproject_toml: bool) -> void:
	var path_end: String = arg.split("=")[1]
	var args = path_end.split(".")
	var c: int = args.size()
	var pathstr: String = ""
	for path_str in args:
		c -= 1
		if c != 0:
			pathstr += path_str + "."
	if pathstr.contains("/.."):
		var paths: Array = pathstr.split("/")
		pathstr = ""
		var index: int = 0
		for path_arg in paths:
			if path_arg == ".." and index > 0:
				var path_size: int = pathstr.length()
				var previous: String = paths[index-1]
				var previous_size: int = previous.length()
				# remove "/"
				pathstr = pathstr.left(path_size-1)
				path_size = pathstr.length()
				# remove previous path
				pathstr = pathstr.left(path_size-previous_size)
			else:
				pathstr += path_arg
				pathstr += "/"
			index += 1
		pathstr = pathstr.left(pathstr.length()-1)
	var transpiler = Transpiler.new()
	if pyproject_toml:
		var path2: String = "res://" + pathstr + "toml"
		transpiler.generate_setup(path2, pyproject_toml)
	else:
		var path2: String = "res://" + pathstr + "py"
		transpiler.generate_setup(path2, pyproject_toml)


## Function for transpiling script (by path)
func start(arg: String, stage2: bool) -> void:
	var path_end: String = arg.split("=")[1]
	var path: String = "res://" + path_end
	var args = path_end.split(".")
	var c: int = args.size()
	var pathstr: String = ""
	for path_str in args:
		c -= 1
		if c != 0:
			pathstr += path_str + "."
	if pathstr.contains("/.."):
		var paths: Array = pathstr.split("/")
		pathstr = ""
		var index: int = 0
		for path_arg in paths:
			if path_arg == ".." and index > 0:
				var path_size: int = pathstr.length()
				var previous: String = paths[index-1]
				var previous_size: int = previous.length()
				# remove "/"
				pathstr = pathstr.left(path_size-1)
				path_size = pathstr.length()
				# remove previous path
				pathstr = pathstr.left(path_size-previous_size)
			else:
				pathstr += path_arg
				pathstr += "/"
			index += 1
		pathstr = pathstr.left(pathstr.length()-1)
	if stage2:
		print("Transpiling " + pathstr + "gd...")
	var path2: String = "res://" + pathstr + "py"
	var transpiler = Transpiler.new()
	var content: String = transpiler.read(path)
	var out: String = transpiler.transpile(content)
	if transpiler.props.verbose:
		print(out)
	transpiler.save(path2, out)
	var deps : Array = []
	for dep in transpiler.props.gds_deps:
		deps.append(dep)
	transpiler.props.gds_deps.clear()
	if stage2:
		print("Formatting " + pathstr + "py...")
	var stdout: Array = []
	var imp_string: String = "import black"
	imp_string += ";versions=set()"
	imp_string += ";mode=black.mode.Mode(target_versions=versions,line_length=black.const.DEFAULT_LINE_LENGTH,is_pyi=False,is_ipynb=False,skip_source_first_line=False,string_normalization=True,magic_trailing_comma=True,experimental_string_processing=False,preview=False,python_cell_magics=set(black.handle_ipynb_magics.PYTHON_CELL_MAGICS),)"
	imp_string += ";write_back = black.WriteBack.from_configuration"
	imp_string += "("
	imp_string += "check="
	imp_string += "False"
	imp_string += ","
	imp_string += "di"
	imp_string += "ff"
	imp_string += "=False,color="
	imp_string += "False);report=black.report.Report"
	imp_string += "("
	imp_string += "check="
	imp_string += "False"
	imp_string += ","
	imp_string += "di"
	imp_string += "ff"
	imp_string += "=False,quiet="
	imp_string += "True,verbose="
	imp_string += "False);src=black.Path"
	imp_string += "("
	imp_string += "'"
	imp_string += pathstr
	imp_string += "'"
	imp_string += "+'py"
	imp_string += "')"
	
	if stage2:
		stdout = form(stdout, imp_string, pathstr)
	for dep in deps:
		if dep != deps[0]:
			var path_arr : Array = pathstr.split("/")
			var size : int = path_arr.size()
			path_arr[size-1] = dep.to_lower() + "."
			var result_str = ""
			for string in path_arr:
				result_str += string
				result_str += "/"
			result_str = result_str.left(result_str.length()-1)
			result_str += "gd"
			start("dep=" + result_str, stage2)


## Prints Python and Godot Engine version information to console
func version_info() -> void:
	var info: Dictionary = Engine.get_version_info()
	var major: int = info.get("major")
	var minor: int = info.get("minor")
	var patch: int = info.get("patch")
	var status: String = info.get("status")
	var build: String = info.get("build")
	var id: String = info.get("hash")
	var version = Version.new()
	print("GDScript Transpiler " + version.__version__ + "\n")
	print("Compatible with Godot" + "\n" + str(major) + "." + str(minor) + "." + str(patch) + "." + status + "." + build + "." + id.left(9))
	var stdout: Array = []
	OS.execute('python',['-c','import sys;print(sys.version)'],stdout,true,false)
	print("Python" + "\n" + stdout[0].split("\n")[0])
	stdout.clear()
	var import_str1: String = "from nuitka import Version"
	OS.execute('python',['-c',import_str1+ ';print(Version.getNuitkaVersion())'],stdout,true,false)
	print("Nuitka" + "\n" + stdout[0].split("\n")[0])
	stdout.clear()
	var import_str2: String = "import black"
	OS.execute('python',['-c',import_str2+ ';print(black.__version__)'],stdout,true,false)
	print("Black" + "\n" + stdout[0].split("\n")[0])
	stdout.clear()
	var import_str3: String = "import sys; sys.argv=['zig', 'version']; import ziglang.__main__"
	print("Zig")
	OS.execute('python',['-c',import_str3+ ';ziglang.__main__'],stdout,true,false)
	print(stdout[0].split("\n")[0])
	stdout.clear()

## Help function which prints all possible commands
func help() -> void:
	print("Usage: gds [options]")
	print()
	print("Options:")
	print("  " + "version                           " + "show program's version number and exit")
	print("  " + "help                              " + "show this help message and exit")
	print("  " + "format=../path/to/file.gd         " + "transpile and format GDScript files recursively")
	print("  " + "run=../path/to/file.gd            " + "run GDScript file directly using x-python")
	print("  " + "compile=../path/to/file.gd        " + "compile GDScript file to binary using Clang/Nuitka")
	print("  " + "exp=../path/to/file.gd            " + "experimental option to tokenize GDScript file")
	print("  " + "setup=../path/setup.py            " + "output a setup.py file to install python project")
	print("  " + "pyproject=../path/pyproject.toml  " + "output a pyproject.toml file to install python project")
	print("  " + "test=vector2                      " + "testing Vector2 implementation")
	print("  " + "test=parser                       " + "running GDScript tests (not working yet)")
	print("  " + "benchmark                         " + "running benchmark to compare performance")
	print("  " + "compile_zig                       " + "build latest Zig toolchain from source")

## Testing benchmark
func run_benchmark() -> void:
	var test: Dictionary = {}
	test.benchmark = Benchmark.new()
	test.benchmark.run()

## GDScript parser tests
func run_parser() -> void:
	var test: Dictionary = {}
	test.advanced_expression_matching = Advanced_expression_matching.new()
	test.advanced_expression_matching.test()
	test.arrays = Arrays.new()
	test.arrays.test()
	test.arrays_dictionaries_nested_const = Arrays_dictionaries_nested_const.new()
	test.arrays_dictionaries_nested_const.test()
	test.basic_expression_matching = Basic_expression_matching.new()
	test.basic_expression_matching.test()
	test.bitwise_operators = Bitwise_operators.new()
	test.bitwise_operators.test()
	test.concatenation = Concatenation.new()
	test.concatenation.test()
	test.constants = Constants.new()
	test.constants.test()
	test.dictionaries = Dictionaries.new()
	test.dictionaries.test()
	test.dictionary_lua_style = Dictionary_lua_style.new()
	test.dictionary_lua_style.test()
	test.dictionary_mixed_syntax = Dictionary_mixed_syntax.new()
	test.dictionary_mixed_syntax.test()
	test.dollar_and_percent_get_node = Dollar_and_percent_get_node.new()
	test.dollar_and_percent_get_node.test()
	test.dollar_node_paths = Dollar_node_paths.new()
	test.dollar_node_paths.test()
	test.enums = Enums.new()
	test.enums.test()
	test.export_variable = Export_variable.new()
	test.export_variable.test()
	test.float_notation = Float_notation.new()
	test.float_notation.test()
	test.for_range = For_range.new()
	test.for_range.test()
	test.function_default_parameter_type_inference = Function_default_parameter_type_inference.new()
	test.function_default_parameter_type_inference.test()
	test.function_many_parameters = Function_many_parameters.new()
	test.function_many_parameters.test()
	test.if_after_lambda = If_after_lambda.new()
	test.if_after_lambda.test()
	test.ins = Ins.new()
	test.ins.test()
	test.lambda_callable = Lambda_callable.new()
	test.lambda_callable.test()
	test.lambda_capture_callable = Lambda_capture_callable.new()
	test.lambda_capture_callable.test()
	test.lambda_default_parameter_capture = Lambda_default_parameter_capture.new()
	test.lambda_default_parameter_capture.test()
	test.lambda_named_callable = Lambda_named_callable.new()
	test.lambda_named_callable.test()
	test.matches = Matches.new()
	test.matches.test()
	test.match_bind_unused = Match_bind_unused.new()
	test.match_bind_unused.test()
	test.match_dictionary = Match_dictionary.new()
	test.match_dictionary.test()
	test.match_multiple_patterns_with_array = Match_multiple_patterns_with_array.new()
	test.match_multiple_patterns_with_array.test()
	test.match_multiple_variable_binds_in_pattern = Match_multiple_variable_binds_in_pattern.new()
	test.match_multiple_variable_binds_in_pattern.test()
	test.multiline_arrays = Multiline_arrays.new()
	test.multiline_arrays.test()
	test.multiline_dictionaries = Multiline_dictionaries.new()
	test.multiline_dictionaries.test()
	test.multiline_if = Multiline_if.new()
	test.multiline_if.test()
	test.multiline_strings = Multiline_strings.new()
	test.multiline_strings.test()
	test.multiline_vector = Multiline_vector.new()
	test.multiline_vector.test()
	test.nested_arithmetic = Nested_arithmetic.new()
	test.nested_arithmetic.test()
	test.nested_array = Nested_array.new()
	test.nested_array.test()
	test.nested_dictionary = Nested_dictionary.new()
	test.nested_dictionary.test()
	test.nested_function_calls = Nested_function_calls.new()
	test.nested_function_calls.test()
	test.nested_if = Nested_if.new()
	test.nested_if.test()
	test.nested_match = Nested_match.new()
	test.nested_match.test()
	test.nested_parentheses = Nested_parentheses.new()
	test.nested_parentheses.test()
	test.number_separators = Number_separators.new()
	test.number_separators.test()
	test.operator_assign = Operator_assign.new()
	test.operator_assign.test()
	test.property_setter_getter = Property_setter_getter.new()
	test.property_setter_getter.test()
	test.semicolon_as_end_statement = Semicolon_as_end_statement.new()
	test.semicolon_as_end_statement.test()
	test.semicolon_as_terminator = Semicolon_as_terminator.new()
	test.semicolon_as_terminator.test()
	test.signal_declaration = Signal_declaration.new()
	test.signal_declaration.test()
	test.static_typing = Static_typing.new()
	test.static_typing.test()
	test.string_formatting = String_formatting.new()
	test.string_formatting.test()
	test.str_preserves_case = Str_preserves_case.new()
	test.str_preserves_case.test()
	test.trailing_comma_in_function_args = Trailing_comma_in_function_args.new()
	test.trailing_comma_in_function_args.test()
	test.truthiness = Truthiness.new()
	test.truthiness.test()
	test.typed_arrays = Typed_arrays.new()
	test.typed_arrays.test()
	test.variable_declaration = Variable_declaration.new()
	test.variable_declaration.test()
	test.whiles = Whiles.new()
	test.whiles.test()

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
