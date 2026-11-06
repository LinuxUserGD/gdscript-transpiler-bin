import os
import sys

class_name = "__Main__"


def _init():
    import gdsbin.__init__

    __init__ = type(gdsbin.__init__)(gdsbin.__init__.__name__, gdsbin.__init__.__doc__)
    __init__.__dict__.update(gdsbin.__init__.__dict__)
    args = sys.argv
    files = []
    flags_l = []
    flags_u = []
    start_i = 0
    if len(args) > 1 and args[0] == "-s" and args[1].endswith(".gd"):
        start_i = 2
    for i in range(start_i, len(args)):
        if args[i].startswith("--"):
            arg = right(args[i], -2)
            flags_l.append(arg)
            continue
        if args[i].startswith("-"):
            arg = right(args[i], -1)
            flags_u.append(arg)
            continue
        if not args[i].endswith(".py"):
            files.append(args[i])
        continue
    for flag in flags_u:
        if flag == "V":
            version_info()
            return
        if flag == "B":
            run_benchmark()
            return
        print("Unknown argument: -" + flag)
        help()
        return
    for flag in flags_l:
        if flag == "test=vector2":
            run_vector2()
            return
        if flag == "test=parser":
            run_parser()
            return
        if flag == "format":
            format = True
            comp = False
            arg = files[0]
            formatter = "ruff"
            if "ruff" in flags_l:
                formatter = "ruff"
            elif "black" in flags_l:
                formatter = "black"
            start(arg, formatter, format, comp, __init__.package_name)
            ESCAPE = ""
            sys.stdout.write(ESCAPE + "[2K\r")
            return
        if flag == "gen_api":
            arg = files[0]
            gen_api(arg)
            return
        if flag == "exp":
            arg = files[0]
            start_exp(arg, __init__.package_name)
            print("")
            return
        if flag == "tok":
            arg = files[0]
            start_tok(arg, __init__.package_name)
            print("")
            return
        if flag == "tree":
            arg = files[0]
            start_tree(arg, __init__.package_name)
            return
        if flag == "compile":
            format = True
            comp = True
            arg = files[0]
            formatter = "ruff"
            if "ruff" in flags_l:
                formatter = "ruff"
            elif "black" in flags_l:
                formatter = "black"
            start(arg, formatter, format, comp, __init__.package_name)
            ESCAPE = ""
            sys.stdout.write(ESCAPE + "[2K\r")
            return
        if flag == "setup":
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
        print("Unknown argument: --" + flag)
        help()
        return
    help()
    return


def gen_api(program):
    import gdsbin.application

    application = type(gdsbin.application)(
        gdsbin.application.__name__, gdsbin.application.__doc__
    )
    application.__dict__.update(gdsbin.application.__dict__)
    version = application.execute(program, ["--headless", "--quit"])
    version = version[0].split("\n")[0]
    info = {
        "major": 4,
        "minor": 7,
        "patch": 2,
        "hex": 263938,
        "status": "stable",
        "build": "official",
        "hash": "ed1daf0bf001b61586d9930840f2f1394092c079",
        "timestamp": 0,
        "string": "4.7.2-stable (official)",
    }
    major = info.get("major")
    minor = info.get("minor")
    patch = info.get("patch")
    status = info.get("status")
    build = info.get("build")
    id = info.get("hash")
    compat = "v"
    compat += str(major)
    compat += "."
    compat += str(minor)
    compat += "."
    if patch != 0:
        compat += str(patch)
        compat += "."
    compat += status
    compat += "."
    compat += build
    compat += "."
    compat += left(id, 9)
    col = version.split(" ")
    if len(col) < 3:
        print("Invalid godot4 executable")
        return
    if compat != col[2]:
        print("Invalid godot4 executable")
        return
    print("Generating GDScript files from extension api...")
    application.execute(program, ["--headless", "--dump-extension-api"])
    save_extension_api()


def save_extension_api():
    import gdsbin.transpiler

    transpiler = type(gdsbin.transpiler)(
        gdsbin.transpiler.__name__, gdsbin.transpiler.__doc__
    )
    transpiler.__dict__.update(gdsbin.transpiler.__dict__)
    content = transpiler.read("extension_api.json").split("\n")
    save_enum_from_api(content, "Variant.Operator")
    save_enum_from_api(content, "Variant.Type")
    save_enum_from_api(content, "Key")


def save_enum_from_api(content, search):
    script_name = search.lower()
    script_name = script_name.replace(".", "_")
    sl = len(script_name)
    classn = script_name[0].upper()
    classn += right(script_name, sl - 1)
    out = "## GDScript Transpiler Properties Class"
    out += "\n\n"
    out += "# Autogenerated class (gen_api)"
    out += "\n"
    out += "# See https://raw.githubusercontent.com/godotengine/godot-cpp/master/gdextension/extension_api.json"
    out += "\n\n"
    out += "class_name %s" % classn
    out += "\n\n"
    line = 0
    l = len(content)
    for i in range(0, l):
        if 0 <= content[i].find(search):
            line = i + 1
            break
    for i in range(line, l):
        if content[i].endswith("["):
            line = i + 1
            break
    for i in range(line, l):
        if 0 <= content[i].find("name"):
            res = content[i].split(" ")[1]
            res = res.split('"')[1]
            out += "const %s: int = " % res
            continue
        if 0 <= content[i].find("value"):
            res = content[i].split(" ")[1]
            out += res
            out += "\n"
            continue
        if content[i].endswith("]"):
            break
        else:
            continue
    pathstr = "gdsbin/" + script_name
    path = "" + pathstr + ".gd"
    import gdsbin.transpiler

    transpiler = type(gdsbin.transpiler)(
        gdsbin.transpiler.__name__, gdsbin.transpiler.__doc__
    )
    transpiler.__dict__.update(gdsbin.transpiler.__dict__)
    transpiler.save(path, out)


def compile(arg):
    path_end = arg.split("=")[1]
    args = path_end.split(".")
    c = len(args)
    pathstr = ""
    for path_str in args:
        c -= 1
        if c != 0:
            pathstr += path_str + "."
    nopt = []
    nopt.append(pathstr + "py")
    nopt.append("--onefile")
    nopt.append("--no-progressbar")
    nopt.append("--show-scons")
    nopt.append("--quiet")
    nopt.append("--remove-output")
    nopt.append("--lto=yes")
    nopt.append("--deployment")
    nopt.append("--static-libpython=auto")
    nopt.append("--clang")
    nopt.append("--assume-yes-for-downloads")
    print("\n")
    print("Compiling " + pathstr + "py...")
    print("Info: Running " + "'" + " ".join(nopt) + "'")
    import gdsbin.application

    application = type(gdsbin.application)(
        gdsbin.application.__name__, gdsbin.application.__doc__
    )
    application.__dict__.update(gdsbin.application.__dict__)
    application.execute_pipe("python", ["-c", nopttoarg(nopt)])


def nopttoarg(nopt):
    opts = []
    opts.append("import nuitka.__main__")
    opts.append("import sys")
    args = "sys.argv=[sys.executable,"
    for opt in nopt:
        args += "'%s'," % opt
    args += "]"
    opts.append(args)
    # AttributeError: module '__main__' has no attribute '__file__'. Did you mean: '__name__'?
    opts.append("sys.modules['__main__'].__file__=sys.modules['__main__'].__name__")
    opts.append("nuitka.__main__.main()")
    out = ";".join(opts)
    return out


def start_exp(arg, _package_name):
    path = "" + arg
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


def start_tok(arg, _package_name):
    path = "" + arg
    import gdsbin.transpiler

    transpiler = type(gdsbin.transpiler)(
        gdsbin.transpiler.__name__, gdsbin.transpiler.__doc__
    )
    transpiler.__dict__.update(gdsbin.transpiler.__dict__)
    content = transpiler.read(path)
    import gdsbin.lexer

    lexer = type(gdsbin.lexer)(gdsbin.lexer.__name__, gdsbin.lexer.__doc__)
    lexer.__dict__.update(gdsbin.lexer.__dict__)
    tokens = lexer.tokenize(content)
    for token in tokens:
        print(lexer.to_output(token))


def start_tree(arg, _package_name):
    path = "" + arg
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
    e = parsertree.printtree(ast_res, 0)
    string_res = parsertree.printrec(e, "")
    print(string_res)


def token_tree(arg, _package_name):
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
    e = {}
    for i in range(0, len(con)):
        l = {}
        tokens = tokenizer.tokenize(con[i])
        for ii in range(0, len(tokens)):
            l["Token" + str(ii)] = {
                "id": {str(tokens[ii].id): None},
                "value": {tokens[ii].value: None},
            }
        e["line " + str(i)] = l
    import gdsbin.parsertree

    parsertree = type(gdsbin.parsertree)(
        gdsbin.parsertree.__name__, gdsbin.parsertree.__doc__
    )
    parsertree.__dict__.update(gdsbin.parsertree.__dict__)
    string_res = parsertree.printrec(e, "")
    print(string_res)


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


def start(arg, formatter, stage2, stage3, package_name):
    path = "" + arg
    args = arg.split(".")
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
        ESCAPE = ""
        sys.stdout.write(ESCAPE + "[2K\r" + "Transpiling " + pathstr + "gd...")
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
        import gdsbin.application

        application = type(gdsbin.application)(
            gdsbin.application.__name__, gdsbin.application.__doc__
        )
        application.__dict__.update(gdsbin.application.__dict__)
        if formatter == "ruff":
            application.execute("ruff", ["format", pathstr + "py"])
        elif formatter == "black":
            application.execute("black", [pathstr + "py"])
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
            transpiler.set_def(start(result_str, formatter, stage2, comp, package_name))
    if stage3:
        compile(arg)
    return transpiler.get_def()


def version_info():
    info = {
        "major": 4,
        "minor": 7,
        "patch": 2,
        "hex": 263938,
        "status": "stable",
        "build": "official",
        "hash": "ed1daf0bf001b61586d9930840f2f1394092c079",
        "timestamp": 0,
        "string": "4.7.2-stable (official)",
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
    ESCAPE = ""
    COLOR_RESET = "[0m"
    CYAN = "[0;36m"
    WHITE_BOLD = "[1;37m"
    print(
        CYAN
        + "GDScript Transpiler "
        + version.__version__
        + ESCAPE
        + COLOR_RESET
        + "\n"
    )
    GDV = str(major) + "." + str(minor) + "." + str(patch)
    print(WHITE_BOLD + "Compatible with Godot" + ESCAPE + COLOR_RESET)
    print(GDV + "." + status + "." + build + "." + left(id, 9))
    out = []
    import gdsbin.application

    application = type(gdsbin.application)(
        gdsbin.application.__name__, gdsbin.application.__doc__
    )
    application.__dict__.update(gdsbin.application.__dict__)
    print(WHITE_BOLD + "Python" + ESCAPE + COLOR_RESET)
    out = application.execute("python", ["-c", "import sys;print(sys.version)"])
    if out[0].split("\n")[0] != "":
        print(out[0].split("\n")[0])
    else:
        print("[not installed]")
    print(WHITE_BOLD + "Nuitka" + ESCAPE + COLOR_RESET)
    out = application.execute(
        "python", ["-c", "from nuitka import Version;print(Version.getNuitkaVersion())"]
    )
    if out[0].split("\n")[0] != "":
        print(out[0].split("\n")[0])
    else:
        print("[not installed]")
    print(WHITE_BOLD + "Ruff" + ESCAPE + COLOR_RESET)
    out = application.execute("ruff", ["version"])
    resout = out[0].split("\n")[0].split(" ")
    resout_s = len(resout)
    if resout_s > 1:
        print(out[0].split("\n")[0].split(" ")[1])
    else:
        print("[not installed]")
    print(WHITE_BOLD + "Zig" + ESCAPE + COLOR_RESET)
    out = application.execute("zig", ["version"])
    if out[0].split("\n")[0] != "":
        print(out[0].split("\n")[0])
    else:
        print("[not installed]")


def help():
    VER_DESC = "show program's version number and exit"
    FMT_DESC = "transpile and format GDScript files recursively"
    COMP_DESC = "compile GDScript file to binary using Clang/Nuitka"
    EXP_DESC = "experimental option to tokenize GDScript file"
    TOK_DESC = "experimental option to tokenize GDScript file"
    TREE_DESC = "experimental option to tokenize GDScript file"
    SETUP_DESC = "generate a setup.py and pyproject.toml file to install Python project"
    VEC2_DESC = "testing Vector2 implementation"
    PARSER_DESC = "running GDScript tests (not working yet)"
    BENCH_DESC = "running benchmark to compare performance"
    GEN_API = "generate API bindings"
    ESCAPE = ""
    COLOR_RESET = "[0m"
    GREEN = "[0;32m"
    CYAN = "[0;36m"
    print(
        "Usage: "
        + CYAN
        + "gds"
        + ESCAPE
        + COLOR_RESET
        + " [ "
        + GREEN
        + "options"
        + ESCAPE
        + COLOR_RESET
        + " ]"
        + "\n"
    )
    print("Options:")
    print(
        "  "
        + GREEN
        + "-V"
        + ESCAPE
        + COLOR_RESET
        + "                                "
        + VER_DESC
    )
    print(
        "  "
        + GREEN
        + "--format"
        + ESCAPE
        + COLOR_RESET
        + " "
        + CYAN
        + "../path/to/file.gd"
        + ESCAPE
        + COLOR_RESET
        + "       "
        + FMT_DESC
    )
    print(
        "  "
        + GREEN
        + "--compile"
        + ESCAPE
        + COLOR_RESET
        + " "
        + CYAN
        + "../path/to/file.gd"
        + ESCAPE
        + COLOR_RESET
        + "      "
        + COMP_DESC
    )
    print(
        "  "
        + GREEN
        + "--exp"
        + ESCAPE
        + COLOR_RESET
        + " "
        + CYAN
        + "../path/to/file.gd"
        + ESCAPE
        + COLOR_RESET
        + "          "
        + EXP_DESC
    )
    print(
        "  "
        + GREEN
        + "--tok"
        + ESCAPE
        + COLOR_RESET
        + " "
        + CYAN
        + "../path/to/file.gd"
        + ESCAPE
        + COLOR_RESET
        + "          "
        + TOK_DESC
    )
    print(
        "  "
        + GREEN
        + "--tree"
        + ESCAPE
        + COLOR_RESET
        + " "
        + CYAN
        + "../path/to/file.gd"
        + ESCAPE
        + COLOR_RESET
        + "         "
        + TREE_DESC
    )
    print(
        "  "
        + GREEN
        + "--setup"
        + ESCAPE
        + COLOR_RESET
        + " "
        + CYAN
        + "../path/setup.py"
        + ESCAPE
        + COLOR_RESET
        + "          "
        + SETUP_DESC
    )
    print(
        "  "
        + GREEN
        + "--test"
        + ESCAPE
        + COLOR_RESET
        + " "
        + CYAN
        + "vector2"
        + ESCAPE
        + COLOR_RESET
        + "                    "
        + VEC2_DESC
    )
    print(
        "  "
        + GREEN
        + "--test"
        + ESCAPE
        + COLOR_RESET
        + " "
        + CYAN
        + "parser"
        + ESCAPE
        + COLOR_RESET
        + "                     "
        + PARSER_DESC
    )
    print(
        "  "
        + GREEN
        + "-B"
        + ESCAPE
        + COLOR_RESET
        + "                                "
        + BENCH_DESC
    )
    print(
        "  "
        + GREEN
        + "--gen_api"
        + ESCAPE
        + COLOR_RESET
        + " "
        + CYAN
        + "../path/to/godot4"
        + ESCAPE
        + COLOR_RESET
        + "       "
        + GEN_API
    )


def run_benchmark():
    gdsbin = {"test": {}}
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.benchmark

    gdsbin.test.benchmark.run()


def run_parser():
    gdsbin = {"test": {}}
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.arrays_dictionaries_nested_const

    gdsbin.test.arrays_dictionaries_nested_const.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.concatenation

    gdsbin.test.concatenation.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.function_default_parameter_type_inference

    gdsbin.test.function_default_parameter_type_inference.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.matches

    gdsbin.test.matches.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.match_bind_unused

    gdsbin.test.match_bind_unused.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.match_multiple_patterns_with_array

    gdsbin.test.match_multiple_patterns_with_array.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.multiline_arrays

    gdsbin.test.multiline_arrays.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.nested_arithmetic

    gdsbin.test.nested_arithmetic.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.nested_array

    gdsbin.test.nested_array.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.nested_function_calls

    gdsbin.test.nested_function_calls.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.nested_parentheses

    gdsbin.test.nested_parentheses.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.operator_assign

    gdsbin.test.operator_assign.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.semicolon_as_terminator

    gdsbin.test.semicolon_as_terminator.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.str_preserves_case

    gdsbin.test.str_preserves_case.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.trailing_comma_in_function_args

    gdsbin.test.trailing_comma_in_function_args.test()
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.test.typed_arrays

    gdsbin.test.typed_arrays.test()
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


def right(s, amount):
    if amount < 0:
        return s[-amount:]
    else:
        return s[len(s) - amount :]


if __name__ == "__main__":
    _init()


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
