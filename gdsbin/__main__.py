import black
from nuitka import Version
import os
import sys


def _init():
    import gdsbin.__init__

    __init__ = type(gdsbin.__init__)(gdsbin.__init__.__name__, gdsbin.__init__.__doc__)
    __init__.__dict__.update(gdsbin.__init__.__dict__)
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
            comp = False
            start_stages(arg, format, comp, __init__.package_name)
            return
        path_exp_arg = "exp="
        if arg.startswith(path_exp_arg):
            start_exp(__init__.package_name)
            return
        compile_arg = "compile="
        if arg.startswith(compile_arg) and arg.endswith(".gd"):
            format = True
            comp = True
            start_stages(arg, format, comp, __init__.package_name)
            return
        setup_arg = "setup="
        if arg.startswith(setup_arg):
            setup(
                __init__.setuptools_min_ver,
                __init__.package_name,
                __init__.author,
                __init__.author_email,
                __init__.project_url,
                __init__.download_url,
                __init__.documentation_url,
                __init__.source_url,
                __init__.tracker_url,
                __init__.description,
                __init__.proj_license,
            )
            return
    help()
    return


def compile(arg, defs):
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
    nuitka += "x=sys.executable;"
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
    if defs.zig_imp:
        nuitka += "f='"
        nuitka += "--include-package-data=ziglang"
        nuitka += "';"
        nuitka += "g='"
        nuitka += "--noinclude-data-files=ziglang/doc"
        nuitka += "';"
        nuitka += "sys.argv=[x,y,z,a,b,c,d,e,f,g]"
    else:
        nuitka += "sys.argv=[x,y,z,a,b,c,d,e]"
    # AttributeError: module '__main__' has no attribute '__file__'. Did you mean: '__name__'?
    nuitka += ";sys.modules['__main__'].__file__=sys.modules['__main__'].__name__"
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


def start_stages(argum, format, comp, package_name):
    f = False
    c = False
    start(argum, f, c, package_name)
    start(argum, format, comp, package_name)


def form(stdout, imp, _imp_string):
    args = {
        "src": "src",
        "fast": "False",
        "write_back": "write_back",
        "mode": "mode",
        "report": "report",
    }
    args_str = ""
    for arg in args:
        args_str += arg + "=" + args[arg] + ","
    args_str = left(args_str, len(args_str) - 1)
    _black_ = ";black.reformat_one(" + args_str + ")"
    versions = set()
    mode = black.mode.Mode(
        target_versions=versions,
        line_length=black.const.DEFAULT_LINE_LENGTH,
        is_pyi=False,
        is_ipynb=False,
        skip_source_first_line=False,
        string_normalization=True,
        magic_trailing_comma=True,
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


def setup(
    setuptools_min_ver,
    package_name,
    author,
    author_email,
    project_url,
    download_url,
    documentation_url,
    source_url,
    tracker_url,
    description,
    proj_license,
):
    import gdsbin.transpiler

    transpiler = type(gdsbin.transpiler)(
        gdsbin.transpiler.__name__, gdsbin.transpiler.__doc__
    )
    transpiler.__dict__.update(gdsbin.transpiler.__dict__)
    pyproject_path = "" + "pyproject" + "." + "toml"
    transpiler.generate_pyproject(pyproject_path, setuptools_min_ver)
    setup_path = "" + "setup" + "." + "py"
    transpiler.generate_setup(
        setup_path,
        package_name,
        author,
        author_email,
        project_url,
        download_url,
        documentation_url,
        source_url,
        tracker_url,
        description,
        proj_license,
    )


def start(arg, stage2, stage3, package_name):
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
    transpiler.set_def([])
    content = transpiler.read(path)
    out = transpiler.transpile(content, package_name)
    if transpiler.defs.verbose:
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
    bl = ";mode=black.mode.Mode(target_versions=versions,"
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
            path_arr = pathstr.split("/")
            size = len(path_arr)
            path_arr[size - 1] = dep.lower() + "."
            result_str = ""
            for string in path_arr:
                result_str += string
                result_str += "/"
            result_str = left(result_str, len(result_str) - 1)
            result_str += "gd"
            comp = False
            transpiler.set_def(start("dep=" + result_str, stage2, comp, package_name))
    if stage3:
        compile(arg, transpiler.defs)
    return transpiler.get_def()


def version_info():
    info = {
        "major": 4,
        "minor": 2,
        "patch": 1,
        "hex": 262657,
        "status": "stable",
        "build": "gentoo",
        "year": 2023,
        "hash": "b09f793f564a6c95dc76acc654b390e68441bd01",
        "string": "4.2.1-stable (gentoo)",
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
    GDV = str(major) + "." + str(minor) + "." + str(patch)
    print(
        "Compatible with Godot"
        + "\n"
        + GDV
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
    VER_DESC = "show program's version number and exit"
    HELP_DESC = "show this help message and exit"
    FMT_DESC = "transpile and format GDScript files recursively"
    COMP_DESC = "compile GDScript file to binary using Clang/Nuitka"
    EXP_DESC = "experimental option to tokenize GDScript file"
    SETUP_DESC = "generate a setup.py and pyproject.toml file to install Python project"
    VEC2_DESC = "testing Vector2 implementation"
    PARSER_DESC = "running GDScript tests (not working yet)"
    BENCH_DESC = "running benchmark to compare performance"
    print("Usage: gds [options]")
    print("\n")
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


def run_benchmark():
    gdsbin = {}
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.benchmark

    gdsbin.test.benchmark.run()


def run_parser():
    gdsbin = {}
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.advanced_expression_matching

    gdsbin.test.advanced_expression_matching.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.arrays

    gdsbin.test.arrays.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.arrays_dictionaries_nested_const

    gdsbin.test.arrays_dictionaries_nested_const.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.basic_expression_matching

    gdsbin.test.basic_expression_matching.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.bitwise_operators

    gdsbin.test.bitwise_operators.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.concatenation

    gdsbin.test.concatenation.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.constants

    gdsbin.test.constants.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.dictionaries

    gdsbin.test.dictionaries.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.dictionary_lua_style

    gdsbin.test.dictionary_lua_style.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.dictionary_mixed_syntax

    gdsbin.test.dictionary_mixed_syntax.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.dollar_and_percent_get_node

    gdsbin.test.dollar_and_percent_get_node.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.dollar_node_paths

    gdsbin.test.dollar_node_paths.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.enums

    gdsbin.test.enums.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.export_variable

    gdsbin.test.export_variable.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.float_notation

    gdsbin.test.float_notation.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.for_range

    gdsbin.test.for_range.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.function_default_parameter_type_inference

    gdsbin.test.function_default_parameter_type_inference.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.function_many_parameters

    gdsbin.test.function_many_parameters.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.if_after_lambda

    gdsbin.test.if_after_lambda.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.ins

    gdsbin.test.ins.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.lambda_callable

    gdsbin.test.lambda_callable.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.lambda_capture_callable

    gdsbin.test.lambda_capture_callable.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.lambda_default_parameter_capture

    gdsbin.test.lambda_default_parameter_capture.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.lambda_named_callable

    gdsbin.test.lambda_named_callable.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.matches

    gdsbin.test.matches.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.match_bind_unused

    gdsbin.test.match_bind_unused.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.match_dictionary

    gdsbin.test.match_dictionary.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.match_multiple_patterns_with_array

    gdsbin.test.match_multiple_patterns_with_array.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.match_multiple_variable_binds_in_pattern

    gdsbin.test.match_multiple_variable_binds_in_pattern.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.multiline_arrays

    gdsbin.test.multiline_arrays.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.multiline_dictionaries

    gdsbin.test.multiline_dictionaries.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.multiline_if

    gdsbin.test.multiline_if.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.multiline_strings

    gdsbin.test.multiline_strings.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.multiline_vector

    gdsbin.test.multiline_vector.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.nested_arithmetic

    gdsbin.test.nested_arithmetic.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.nested_array

    gdsbin.test.nested_array.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.nested_dictionary

    gdsbin.test.nested_dictionary.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.nested_function_calls

    gdsbin.test.nested_function_calls.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.nested_if

    gdsbin.test.nested_if.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.nested_match

    gdsbin.test.nested_match.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.nested_parentheses

    gdsbin.test.nested_parentheses.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.number_separators

    gdsbin.test.number_separators.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.operator_assign

    gdsbin.test.operator_assign.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.property_setter_getter

    gdsbin.test.property_setter_getter.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.semicolon_as_end_statement

    gdsbin.test.semicolon_as_end_statement.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.semicolon_as_terminator

    gdsbin.test.semicolon_as_terminator.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.signal_declaration

    gdsbin.test.signal_declaration.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.static_typing

    gdsbin.test.static_typing.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.string_formatting

    gdsbin.test.string_formatting.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.str_preserves_case

    gdsbin.test.str_preserves_case.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.trailing_comma_in_function_args

    gdsbin.test.trailing_comma_in_function_args.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.truthiness

    gdsbin.test.truthiness.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.typed_arrays

    gdsbin.test.typed_arrays.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.variable_declaration

    gdsbin.test.variable_declaration.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.whiles

    gdsbin.test.whiles.test()


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
