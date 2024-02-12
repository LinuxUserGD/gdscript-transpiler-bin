class_name __Main__
## GDScript Transpiler Script
##
## Wrapper script using transpiler for converting any GDScript code to Python
## (including the transpiler script)
## using search-and-replace syntax
##
##

## Runs once when executed, prints different output to console depending on argument
func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	var __init__ = preload("__init__.gd").new()
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
			const format: bool = true
			start_stages(arg, format, __init__.package_name)
			return
		var path_exp_arg: String = "exp="
		if arg.begins_with(path_exp_arg):
			start_exp(__init__.package_name)
			return
		var compile_arg = "compile="
		if arg.begins_with(compile_arg) and arg.ends_with(".gd"):
			const format: bool = true
			start_stages(arg, format, __init__.package_name)
			compile(arg)
			return
		var setup_arg: String = "setup="
		if arg.begins_with(setup_arg):
			setup(__init__.setuptools_min_ver, __init__.package_name, __init__.author, __init__.author_email, __init__.project_url, __init__.download_url, __init__.documentation_url, __init__.source_url, __init__.tracker_url, __init__.description, __init__.proj_license)
			return
	help()
	return

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
	var con: Array = content.split("\n")
	var unit: Array = []
	for line in con:
		var tokens : Array = tokenizer.tokenize(line)
		unit.append(tokens)
	var ast = Ast.new()
	var root = Root.new()
	var ast_res = ast.ast(0, unit.size(), 0, root, unit, con)
	var parsertree = Parsertree.new()
	var string_res = parsertree.printpt(ast_res, 0)
	print(string_res)

## Wrapper function for start()
func start_stages(argum: String, format: bool, package_name: String) -> void:
	const f: bool = false
	start(argum, f, package_name)
	start(argum, format, package_name)

## Format function
func form(stdout: Array, imp: String, _imp_string: String):
	const args: Dictionary = {
		"src": "src",
		"fast": "False",
		"write_back": "write_back",
		"mode": "mode",
		"report": "report"
	}
	var args_str: String = ""
	for arg in args:
		args_str += arg + "=" + args[arg] + ","
	args_str = args_str.left(args_str.length()-1)
	var _black_ = ";black.reformat_one(" + args_str + ")"
	OS.execute('python',['-c',imp+ _black_],stdout,true,false)
	return stdout

## Function for saving setup.py
func setup(setuptools_min_ver: int, package_name: String, author: String, author_email: String, project_url: String, download_url: String, documentation_url: String, source_url: String, tracker_url: String, description: String, proj_license: String) -> void:
	var transpiler = Transpiler.new()
	const pyproject_path: String = "res://" + "pyproject" + "." + "toml"
	transpiler.generate_pyproject(pyproject_path, setuptools_min_ver)
	const setup_path = "res://" + "setup" + "." + "py"
	transpiler.generate_setup(setup_path, package_name, author, author_email, project_url, download_url, documentation_url, source_url, tracker_url, description, proj_license)


## Function for transpiling script (by path)
func start(arg: String, stage2: bool, package_name: String) -> void:
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
	var out: String = transpiler.transpile(content, package_name)
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
	var bl: String = ";mode=black.mode.Mode(target_versions=versions,"
	bl += "line_length=black.const.DEFAULT_LINE_LENGTH,is_pyi=False,is_ipynb=False,"
	bl += "skip_source_first_line=False,string_normalization=True,magic_trailing_comma=True,"
	bl += "preview=False,"
	bl += "python_cell_magics=set(black.handle_ipynb_magics.PYTHON_CELL_MAGICS),)"
	imp_string += ";versions=set()"
	imp_string += bl
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
			start("dep=" + result_str, stage2, package_name)


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
	var GDV: String = str(major) + "." + str(minor) + "." + str(patch)
	print("Compatible with Godot" + "\n" + GDV + "." + status + "." + build + "." + id.left(9))
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
	const VER_DESC: String = "show program's version number and exit"
	const HELP_DESC: String = "show this help message and exit"
	const FMT_DESC: String = "transpile and format GDScript files recursively"
	const COMP_DESC: String = "compile GDScript file to binary using Clang/Nuitka"
	const EXP_DESC: String = "experimental option to tokenize GDScript file"
	const SETUP_DESC: String = "generate a setup.py and pyproject.toml file to install Python project"
	const VEC2_DESC: String = "testing Vector2 implementation"
	const PARSER_DESC: String = "running GDScript tests (not working yet)"
	const BENCH_DESC: String = "running benchmark to compare performance"
	print("Usage: gds [options]")
	print()
	print("Options:")
	print("  " + "version                           " + VER_DESC)
	print("  " + "help                              " + HELP_DESC)
	print("  " + "format=../path/to/file.gd         " + FMT_DESC)
	print("  " + "compile=../path/to/file.gd        " + COMP_DESC)
	print("  " + "exp=../path/to/file.gd            " + EXP_DESC)
	print("  " + "setup=../path/setup.py            " + SETUP_DESC)
	print("  " + "test=vector2                      " + VEC2_DESC)
	print("  " + "test=parser                       " + PARSER_DESC)
	print("  " + "benchmark                         " + BENCH_DESC)
## Testing benchmark
func run_benchmark() -> void:
	var gdsbin: Dictionary = {}
	gdsbin.test.benchmark = Benchmark.new()
	gdsbin.test.benchmark.run()

## GDScript parser tests
func run_parser() -> void:
	var gdsbin: Dictionary = {}
	gdsbin.test.advanced_expression_matching = Advanced_expression_matching.new()
	gdsbin.test.advanced_expression_matching.test()
	gdsbin.test.arrays = Arrays.new()
	gdsbin.test.arrays.test()
	gdsbin.test.arrays_dictionaries_nested_const = Arrays_dictionaries_nested_const.new()
	gdsbin.test.arrays_dictionaries_nested_const.test()
	gdsbin.test.basic_expression_matching = Basic_expression_matching.new()
	gdsbin.test.basic_expression_matching.test()
	gdsbin.test.bitwise_operators = Bitwise_operators.new()
	gdsbin.test.bitwise_operators.test()
	gdsbin.test.concatenation = Concatenation.new()
	gdsbin.test.concatenation.test()
	gdsbin.test.constants = Constants.new()
	gdsbin.test.constants.test()
	gdsbin.test.dictionaries = Dictionaries.new()
	gdsbin.test.dictionaries.test()
	gdsbin.test.dictionary_lua_style = Dictionary_lua_style.new()
	gdsbin.test.dictionary_lua_style.test()
	gdsbin.test.dictionary_mixed_syntax = Dictionary_mixed_syntax.new()
	gdsbin.test.dictionary_mixed_syntax.test()
	gdsbin.test.dollar_and_percent_get_node = Dollar_and_percent_get_node.new()
	gdsbin.test.dollar_and_percent_get_node.test()
	gdsbin.test.dollar_node_paths = Dollar_node_paths.new()
	gdsbin.test.dollar_node_paths.test()
	gdsbin.test.enums = Enums.new()
	gdsbin.test.enums.test()
	gdsbin.test.export_variable = Export_variable.new()
	gdsbin.test.export_variable.test()
	gdsbin.test.float_notation = Float_notation.new()
	gdsbin.test.float_notation.test()
	gdsbin.test.for_range = For_range.new()
	gdsbin.test.for_range.test()
	gdsbin.test.function_default_parameter_type_inference = Function_default_parameter_type_inference.new()
	gdsbin.test.function_default_parameter_type_inference.test()
	gdsbin.test.function_many_parameters = Function_many_parameters.new()
	gdsbin.test.function_many_parameters.test()
	gdsbin.test.if_after_lambda = If_after_lambda.new()
	gdsbin.test.if_after_lambda.test()
	gdsbin.test.ins = Ins.new()
	gdsbin.test.ins.test()
	gdsbin.test.lambda_callable = Lambda_callable.new()
	gdsbin.test.lambda_callable.test()
	gdsbin.test.lambda_capture_callable = Lambda_capture_callable.new()
	gdsbin.test.lambda_capture_callable.test()
	gdsbin.test.lambda_default_parameter_capture = Lambda_default_parameter_capture.new()
	gdsbin.test.lambda_default_parameter_capture.test()
	gdsbin.test.lambda_named_callable = Lambda_named_callable.new()
	gdsbin.test.lambda_named_callable.test()
	gdsbin.test.matches = Matches.new()
	gdsbin.test.matches.test()
	gdsbin.test.match_bind_unused = Match_bind_unused.new()
	gdsbin.test.match_bind_unused.test()
	gdsbin.test.match_dictionary = Match_dictionary.new()
	gdsbin.test.match_dictionary.test()
	gdsbin.test.match_multiple_patterns_with_array = Match_multiple_patterns_with_array.new()
	gdsbin.test.match_multiple_patterns_with_array.test()
	gdsbin.test.match_multiple_variable_binds_in_pattern = Match_multiple_variable_binds_in_pattern.new()
	gdsbin.test.match_multiple_variable_binds_in_pattern.test()
	gdsbin.test.multiline_arrays = Multiline_arrays.new()
	gdsbin.test.multiline_arrays.test()
	gdsbin.test.multiline_dictionaries = Multiline_dictionaries.new()
	gdsbin.test.multiline_dictionaries.test()
	gdsbin.test.multiline_if = Multiline_if.new()
	gdsbin.test.multiline_if.test()
	gdsbin.test.multiline_strings = Multiline_strings.new()
	gdsbin.test.multiline_strings.test()
	gdsbin.test.multiline_vector = Multiline_vector.new()
	gdsbin.test.multiline_vector.test()
	gdsbin.test.nested_arithmetic = Nested_arithmetic.new()
	gdsbin.test.nested_arithmetic.test()
	gdsbin.test.nested_array = Nested_array.new()
	gdsbin.test.nested_array.test()
	gdsbin.test.nested_dictionary = Nested_dictionary.new()
	gdsbin.test.nested_dictionary.test()
	gdsbin.test.nested_function_calls = Nested_function_calls.new()
	gdsbin.test.nested_function_calls.test()
	gdsbin.test.nested_if = Nested_if.new()
	gdsbin.test.nested_if.test()
	gdsbin.test.nested_match = Nested_match.new()
	gdsbin.test.nested_match.test()
	gdsbin.test.nested_parentheses = Nested_parentheses.new()
	gdsbin.test.nested_parentheses.test()
	gdsbin.test.number_separators = Number_separators.new()
	gdsbin.test.number_separators.test()
	gdsbin.test.operator_assign = Operator_assign.new()
	gdsbin.test.operator_assign.test()
	gdsbin.test.property_setter_getter = Property_setter_getter.new()
	gdsbin.test.property_setter_getter.test()
	gdsbin.test.semicolon_as_end_statement = Semicolon_as_end_statement.new()
	gdsbin.test.semicolon_as_end_statement.test()
	gdsbin.test.semicolon_as_terminator = Semicolon_as_terminator.new()
	gdsbin.test.semicolon_as_terminator.test()
	gdsbin.test.signal_declaration = Signal_declaration.new()
	gdsbin.test.signal_declaration.test()
	gdsbin.test.static_typing = Static_typing.new()
	gdsbin.test.static_typing.test()
	gdsbin.test.string_formatting = String_formatting.new()
	gdsbin.test.string_formatting.test()
	gdsbin.test.str_preserves_case = Str_preserves_case.new()
	gdsbin.test.str_preserves_case.test()
	gdsbin.test.trailing_comma_in_function_args = Trailing_comma_in_function_args.new()
	gdsbin.test.trailing_comma_in_function_args.test()
	gdsbin.test.truthiness = Truthiness.new()
	gdsbin.test.truthiness.test()
	gdsbin.test.typed_arrays = Typed_arrays.new()
	gdsbin.test.typed_arrays.test()
	gdsbin.test.variable_declaration = Variable_declaration.new()
	gdsbin.test.variable_declaration.test()
	gdsbin.test.whiles = Whiles.new()
	gdsbin.test.whiles.test()

## Testing Vector2 implementation
func run_vector2() -> void:
	var vector2 = VECTOR2.new()
	vector2.x = 3
	vector2.y = 5
	print("x -> " + str(vector2.x))
	print("y -> " + str(vector2.y))
	print("angle() -> " + str(vector2.angle(vector2)))
	var vector2_res = vector2.from_angle(30)
	print("from_angle(30) -> " + "(" + str(vector2_res.x) + ", " + str(vector2_res.y) + ")")
	print("vec_length() -> " + str(vector2.vec_length(vector2)))
	print("length_squared() -> " + str(vector2.length_squared(vector2)))
	var vector2_res2 = vector2.normalized(vector2)
	print("normalized() -> " + "(" + str(vector2_res2.x) + ", " + str(vector2_res2.y) + ")")
	print("is_normalized() -> " + str(vector2_res2.is_normalized(vector2)))
	print("distance_to() -> " + str(vector2.distance_to(vector2, vector2)))
	print("distance_squared_to() -> " + str(vector2.distance_squared_to(vector2, vector2)))
	print("angle_to() -> " + str(vector2.angle_to(vector2, vector2)))
	print("angle_to_point() -> " + str(vector2.angle_to_point(vector2, vector2)))
	print("dot() -> " + str(vector2.dot(vector2, vector2)))
	print("cross() -> " + str(vector2.cross(vector2, vector2)))
	var vec_rot = vector2.rotated(vector2, 1)
	print("rotated() -> " + "(" + str(vec_rot.x) + ", " + str(vec_rot.y) + ")")
	var vec_proj = vector2.project(vector2, vector2)
	print("project() -> " + "(" + str(vec_proj.x) + ", " + str(vec_proj.y) + ")")
	var vec_lim = vector2.limit_length(vector2, 2, vector2)
	print("limit_length() -> " + "(" + str(vec_lim.x) + ", " + str(vec_lim.y) + ")")
