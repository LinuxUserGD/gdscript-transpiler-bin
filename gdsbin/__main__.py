import black
from nuitka import Version
import os
import sys


def _init():
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.__init__

    for arg in sys.argv:
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
        path_format_arg = "format="
        if arg.startswith(path_format_arg) and arg.endswith(".gd"):
            format = True
            start_stages(arg, format)
            return
        path_exp_arg = "exp="
        if arg.startswith(path_exp_arg):
            start_exp(arg)
            return
        compile_arg = "compile="
        if arg.startswith(compile_arg) and arg.endswith(".gd"):
            format = True
            start_stages(arg, format)
            compile(arg)
            return
        if arg == "compile_zig":
            compile_zig()
            return
        if arg == "zig_template":
            zig_template()
            return
        setup_arg = "setup="
        if arg.startswith(setup_arg):
            pyproject = False
            setup(arg, pyproject)
            return
        pyproject_arg = "pyproject="
        if arg.startswith(pyproject_arg):
            pyproject = True
            setup(arg, pyproject)
            return
    help()
    return


def compile_zig():
    sys.stdout.write("Building latest Zig toolchain from source")
    import gdsbin.threads

    threads = type(gdsbin.threads)(gdsbin.threads.__name__, gdsbin.threads.__doc__)
    threads.__dict__.update(gdsbin.threads.__dict__)
    threads.start(_build)
    while threads.is_alive():
        sys.stdout.write(".")
    threads.wait_to_finish()


def zig_template():
    print("Building Zig template...")
    stdout = []
    if len(stdout) > 0:
        for out_str in stdout[0].split("\n"):
            if len(out_str) > 0:
                print(out_str)
    stdout = []
    if len(stdout) > 0:
        for out_str in stdout[0].split("\n"):
            if len(out_str) > 0:
                print(out_str)


def _build():
    stdout = []


def compile(arg):
    path_end = arg.split("=")[1]
    args = path_end.split(".")
    c = len(args)
    pathstr = ""
    for path_str in args:
        c -= 1
        if c != 0:
            pathstr += path_str + "."
    nuitka = "import nuitka.__main__;"
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
    stdout = []
    print("Compiling " + pathstr + "py...")
    import subprocess

    x = sys.executable
    xx = "-m"
    xxx = "nuitka"
    y = pathstr + "py"
    z = "--onefile"
    a = "--lto=yes"
    b = "--static-libpython=no"
    c = "--clang"
    d = "--assume-yes-for-downloads"
    e = "--include-package-data=blib2to3"
    f = "--include-package-data=ziglang"
    g = "--noinclude-data-files=ziglang/doc"
    args = [
        x
        + " "
        + xx
        + " "
        + xxx
        + " "
        + y
        + " "
        + z
        + " "
        + a
        + " "
        + b
        + " "
        + c
        + " "
        + d
        + " "
        + e
        + " "
        + f
        + " "
        + g
    ]
    proc = subprocess.Popen(args, shell=True)
    proc.communicate()
    stdout = []
    if len(stdout) > 0:
        for out_str in stdout[0].split("\n"):
            if len(out_str) > 0:
                print(out_str)


def start_exp(arg):
    path_end = arg.split("=")[1]
    path = "" + path_end
    import gdsbin.transpiler

    transpiler = type(gdsbin.transpiler)(
        gdsbin.transpiler.__name__, gdsbin.transpiler.__doc__
    )
    transpiler.__dict__.update(gdsbin.transpiler.__dict__)
    content = transpiler.read(path)
    import gdsbin.tokenizer

    tokenizer = type(gdsbin.tokenizer)(
        gdsbin.tokenizer.__name__, gdsbin.tokenizer.__doc__
    )
    tokenizer.__dict__.update(gdsbin.tokenizer.__dict__)
    con = content.split("\n")
    unit = []
    for line in con:
        tokens = tokenizer.tokenize(line)
        unit.append(tokens)
    import gdsbin.ast

    ast = type(gdsbin.ast)(gdsbin.ast.__name__, gdsbin.ast.__doc__)
    ast.__dict__.update(gdsbin.ast.__dict__)
    import gdsbin.root

    root = type(gdsbin.root)(gdsbin.root.__name__, gdsbin.root.__doc__)
    root.__dict__.update(gdsbin.root.__dict__)
    ast_res = ast.ast(0, len(unit), 0, root, unit, con)
    import gdsbin.parsertree

    parsertree = type(gdsbin.parsertree)(
        gdsbin.parsertree.__name__, gdsbin.parsertree.__doc__
    )
    parsertree.__dict__.update(gdsbin.parsertree.__dict__)
    string_res = parsertree.printpt(ast_res, 0)
    print(string_res)


def start_stages(argum, format):
    f = False
    start(argum, f)
    start(argum, format)


def form(stdout, imp, _imp_string):
    versions = set()
    mode = black.mode.Mode(
        target_versions=versions,
        line_length=black.const.DEFAULT_LINE_LENGTH,
        is_pyi=False,
        is_ipynb=False,
        skip_source_first_line=False,
        string_normalization=True,
        magic_trailing_comma=True,
        experimental_string_processing=False,
        preview=False,
        python_cell_magics=set(black.handle_ipynb_magics.PYTHON_CELL_MAGICS),
    )
    report = black.report.Report(check=False, diff=False, quiet=True, verbose=False)
    write_back = black.WriteBack.from_configuration(
        check=False, diff=False, color=False
    )
    src = black.Path(_imp_string + "py")
    black.reformat_one(
        src=src, fast=False, write_back=write_back, mode=mode, report=report
    )
    return stdout


def setup(arg, pyproject_toml):
    path_end = arg.split("=")[1]
    args = path_end.split(".")
    c = len(args)
    pathstr = ""
    for path_str in args:
        c -= 1
        if c != 0:
            pathstr += path_str + "."
    if 0 <= pathstr.find("/.."):
        paths = pathstr.split("/")
        pathstr = ""
        index = 0
        for path_arg in paths:
            if path_arg == ".." and index > 0:
                path_size = len(pathstr)
                previous = paths[index - 1]
                previous_size = len(previous)
                # remove "/"
                pathstr = left(pathstr, path_size - 1)
                path_size = len(pathstr)
                # remove previous path
                pathstr = left(pathstr, path_size - previous_size)
            else:
                pathstr += path_arg
                pathstr += "/"
            index += 1
        pathstr = left(pathstr, len(pathstr) - 1)
    import gdsbin.transpiler

    transpiler = type(gdsbin.transpiler)(
        gdsbin.transpiler.__name__, gdsbin.transpiler.__doc__
    )
    transpiler.__dict__.update(gdsbin.transpiler.__dict__)
    if pyproject_toml:
        path2 = "" + pathstr + "toml"
        transpiler.generate_setup(path2, pyproject_toml)
    else:
        path2 = "" + pathstr + "py"
        transpiler.generate_setup(path2, pyproject_toml)


def start(arg, stage2):
    path_end = arg.split("=")[1]
    path = "" + path_end
    args = path_end.split(".")
    c = len(args)
    pathstr = ""
    for path_str in args:
        c -= 1
        if c != 0:
            pathstr += path_str + "."
    if 0 <= pathstr.find("/.."):
        paths = pathstr.split("/")
        pathstr = ""
        index = 0
        for path_arg in paths:
            if path_arg == ".." and index > 0:
                path_size = len(pathstr)
                previous = paths[index - 1]
                previous_size = len(previous)
                # remove "/"
                pathstr = left(pathstr, path_size - 1)
                path_size = len(pathstr)
                # remove previous path
                pathstr = left(pathstr, path_size - previous_size)
            else:
                pathstr += path_arg
                pathstr += "/"
            index += 1
        pathstr = left(pathstr, len(pathstr) - 1)
    if stage2:
        print("Transpiling " + pathstr + "gd...")
    path2 = "" + pathstr + "py"
    import gdsbin.transpiler

    transpiler = type(gdsbin.transpiler)(
        gdsbin.transpiler.__name__, gdsbin.transpiler.__doc__
    )
    transpiler.__dict__.update(gdsbin.transpiler.__dict__)
    content = transpiler.read(path)
    out = transpiler.transpile(content)
    if transpiler.props.verbose:
        print(out)
    transpiler.save(path2, out)
    deps = []
    for dep in transpiler.props.gds_deps:
        deps.append(dep)
    transpiler.props.gds_deps = []
    if stage2:
        print("Formatting " + pathstr + "py...")
    stdout = []
    imp_string = "import black"
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
            path_arr = pathstr.split("/")
            size = len(path_arr)
            path_arr[size - 1] = dep.lower() + "."
            result_str = ""
            for string in path_arr:
                result_str += string
                result_str += "/"
            result_str = left(result_str, len(result_str) - 1)
            result_str += "gd"
            start("dep=" + result_str, stage2)


def version_info():
    info = {
        "major": 4,
        "minor": 1,
        "patch": 1,
        "hex": 262401,
        "status": "stable",
        "build": "gentoo",
        "year": 2023,
        "hash": "bd6af8e0ea69167dd0627f3bd54f9105bda0f8b5",
        "string": "4.1.1-stable (gentoo)",
    }
    major = info.get("major")
    minor = info.get("minor")
    patch = info.get("patch")
    status = info.get("status")
    build = info.get("build")
    id = info.get("hash")
    import gdsbin.version

    version = type(gdsbin.version)(gdsbin.version.__name__, gdsbin.version.__doc__)
    version.__dict__.update(gdsbin.version.__dict__)
    print("GDScript Transpiler " + version.__version__ + "\n")
    print(
        "Compatible with Godot"
        + "\n"
        + str(major)
        + "."
        + str(minor)
        + "."
        + str(patch)
        + "."
        + status
        + "."
        + build
        + "."
        + left(id, 9)
    )
    stdout = []
    stdout = [sys.version]
    print("Python" + "\n" + stdout[0].split("\n")[0])
    stdout = []
    import_str1 = "from nuitka import Version"
    stdout = [Version.getNuitkaVersion()]
    print("Nuitka" + "\n" + stdout[0].split("\n")[0])
    stdout = []
    import_str2 = "import black"
    stdout = [black.__version__]
    print("Black" + "\n" + stdout[0].split("\n")[0])
    stdout = []
    import_str3 = "import sys; sys.argv=['zig', 'version']; import ziglang.__main__"
    print("Zig")
    sys.argv = ["zig", "version"]
    import ziglang.__main__

    stdout = [ziglang.__main__]
    print(stdout[0].split("\n")[0])
    stdout = []


def help():
    print("Usage: gds [options]")
    print("\n")
    print("Options:")
    print(
        "  "
        + "version                           "
        + "show program's version number and exit"
    )
    print(
        "  " + "help                              " + "show this help message and exit"
    )
    print(
        "  "
        + "format=../path/to/file.gd         "
        + "transpile and format GDScript files recursively"
    )
    print(
        "  "
        + "run=../path/to/file.gd            "
        + "run GDScript file directly using x-python"
    )
    print(
        "  "
        + "compile=../path/to/file.gd        "
        + "compile GDScript file to binary using Clang/Nuitka"
    )
    print(
        "  "
        + "exp=../path/to/file.gd            "
        + "experimental option to tokenize GDScript file"
    )
    print(
        "  "
        + "setup=../path/setup.py            "
        + "output a setup.py file to install python project"
    )
    print(
        "  "
        + "pyproject=../path/pyproject.toml  "
        + "output a pyproject.toml file to install python project"
    )
    print(
        "  " + "test=vector2                      " + "testing Vector2 implementation"
    )
    print(
        "  "
        + "test=parser                       "
        + "running GDScript tests (not working yet)"
    )
    print(
        "  "
        + "benchmark                         "
        + "running benchmark to compare performance"
    )
    print(
        "  "
        + "compile_zig                       "
        + "build latest Zig toolchain from source"
    )


def run_benchmark():
    test = {}
    import test.benchmark

    test.benchmark.run()


def run_parser():
    test = {}
    import test.advanced_expression_matching

    test.advanced_expression_matching.test()
    import test.arrays

    test.arrays.test()
    import test.arrays_dictionaries_nested_const

    test.arrays_dictionaries_nested_const.test()
    import test.basic_expression_matching

    test.basic_expression_matching.test()
    import test.bitwise_operators

    test.bitwise_operators.test()
    import test.concatenation

    test.concatenation.test()
    import test.constants

    test.constants.test()
    import test.dictionaries

    test.dictionaries.test()
    import test.dictionary_lua_style

    test.dictionary_lua_style.test()
    import test.dictionary_mixed_syntax

    test.dictionary_mixed_syntax.test()
    import test.dollar_and_percent_get_node

    test.dollar_and_percent_get_node.test()
    import test.dollar_node_paths

    test.dollar_node_paths.test()
    import test.enums

    test.enums.test()
    import test.export_variable

    test.export_variable.test()
    import test.float_notation

    test.float_notation.test()
    import test.for_range

    test.for_range.test()
    import test.function_default_parameter_type_inference

    test.function_default_parameter_type_inference.test()
    import test.function_many_parameters

    test.function_many_parameters.test()
    import test.if_after_lambda

    test.if_after_lambda.test()
    import test.ins

    test.ins.test()
    import test.lambda_callable

    test.lambda_callable.test()
    import test.lambda_capture_callable

    test.lambda_capture_callable.test()
    import test.lambda_default_parameter_capture

    test.lambda_default_parameter_capture.test()
    import test.lambda_named_callable

    test.lambda_named_callable.test()
    import test.matches

    test.matches.test()
    import test.match_bind_unused

    test.match_bind_unused.test()
    import test.match_dictionary

    test.match_dictionary.test()
    import test.match_multiple_patterns_with_array

    test.match_multiple_patterns_with_array.test()
    import test.match_multiple_variable_binds_in_pattern

    test.match_multiple_variable_binds_in_pattern.test()
    import test.multiline_arrays

    test.multiline_arrays.test()
    import test.multiline_dictionaries

    test.multiline_dictionaries.test()
    import test.multiline_if

    test.multiline_if.test()
    import test.multiline_strings

    test.multiline_strings.test()
    import test.multiline_vector

    test.multiline_vector.test()
    import test.nested_arithmetic

    test.nested_arithmetic.test()
    import test.nested_array

    test.nested_array.test()
    import test.nested_dictionary

    test.nested_dictionary.test()
    import test.nested_function_calls

    test.nested_function_calls.test()
    import test.nested_if

    test.nested_if.test()
    import test.nested_match

    test.nested_match.test()
    import test.nested_parentheses

    test.nested_parentheses.test()
    import test.number_separators

    test.number_separators.test()
    import test.operator_assign

    test.operator_assign.test()
    import test.property_setter_getter

    test.property_setter_getter.test()
    import test.semicolon_as_end_statement

    test.semicolon_as_end_statement.test()
    import test.semicolon_as_terminator

    test.semicolon_as_terminator.test()
    import test.signal_declaration

    test.signal_declaration.test()
    import test.static_typing

    test.static_typing.test()
    import test.string_formatting

    test.string_formatting.test()
    import test.str_preserves_case

    test.str_preserves_case.test()
    import test.trailing_comma_in_function_args

    test.trailing_comma_in_function_args.test()
    import test.truthiness

    test.truthiness.test()
    import test.typed_arrays

    test.typed_arrays.test()
    import test.variable_declaration

    test.variable_declaration.test()
    import test.whiles

    test.whiles.test()


def run_vector2():
    import gdsbin.vector2

    vector2 = type(gdsbin.vector2)(gdsbin.vector2.__name__, gdsbin.vector2.__doc__)
    vector2.__dict__.update(gdsbin.vector2.__dict__)
    vector2.x = 3
    vector2.y = 5
    print("x -> " + str(vector2.x))
    print("y -> " + str(vector2.y))
    print("angle() -> " + str(vector2.angle(vector2)))
    vector2_res = vector2.from_angle(30)
    print(
        "from_angle(30) -> "
        + "("
        + str(vector2_res.x)
        + ", "
        + str(vector2_res.y)
        + ")"
    )
    print("vec_length() -> " + str(vector2.vec_length(vector2)))
    print("length_squared() -> " + str(vector2.length_squared(vector2)))
    vector2_res2 = vector2.normalized(vector2)
    print(
        "normalized() -> "
        + "("
        + str(vector2_res2.x)
        + ", "
        + str(vector2_res2.y)
        + ")"
    )
    print("is_normalized() -> " + str(vector2_res2.is_normalized(vector2)))
    print("distance_to() -> " + str(vector2.distance_to(vector2, vector2)))
    print(
        "distance_squared_to() -> " + str(vector2.distance_squared_to(vector2, vector2))
    )
    print("angle_to() -> " + str(vector2.angle_to(vector2, vector2)))
    print("angle_to_point() -> " + str(vector2.angle_to_point(vector2, vector2)))
    print("dot() -> " + str(vector2.dot(vector2, vector2)))
    print("cross() -> " + str(vector2.cross(vector2, vector2)))
    vec_rot = vector2.rotated(vector2, 1)
    print("rotated() -> " + "(" + str(vec_rot.x) + ", " + str(vec_rot.y) + ")")
    vec_proj = vector2.project(vector2, vector2)
    print("project() -> " + "(" + str(vec_proj.x) + ", " + str(vec_proj.y) + ")")
    vec_lim = vector2.limit_length(vector2, 2, vector2)
    print("limit_length() -> " + "(" + str(vec_lim.x) + ", " + str(vec_lim.y) + ")")


def left(s, amount):
    return s[:amount]


if __name__ == "__main__":
    _init()
