import gdsbin.props

props = type(gdsbin.props)(gdsbin.props.__name__, gdsbin.props.__doc__)
props.__dict__.update(gdsbin.props.__dict__)
import gdsbin.defs

defs = type(gdsbin.defs)(gdsbin.defs.__name__, gdsbin.defs.__doc__)
defs.__dict__.update(gdsbin.defs.__dict__)


def transpile(content, package_name):
    t = ""
    for line in content.split("\n"):
        if not line.startswith("##"):
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


def read(path):
    file = ""
    file = open(path, "r")
    string = file.read()
    file.close()
    return string


def generate_setup(
    path,
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
    content = ""
    file = props.get_setup(
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
    for line in file:
        content += line + "\n"
    save(path, content)


def generate_pyproject(path, setuptools_min_ver):
    content = ""
    file = props.get_pyproject_toml(setuptools_min_ver)
    for line in file:
        content += line + "\n"
    save(path, content)


def save(path, content):
    file = ""
    file = open(path, "w")
    file.write(content)
    file.close()


def check_match(l):
    out = ""
    for i in l:
        if i != " " and i != "	":
            out += i
    cond = out.endswith(":")
    cond = cond and not out.startswith("for")
    cond = cond and not out.startswith("while")
    cond = cond and not out.startswith("if")
    cond = cond and not 0 <= out.find("(")
    cond = cond and not 0 <= out.find(")")
    cond = cond and not 0 <= out.find("match")
    cond = cond and not out.startswith("else")
    cond = cond and not 0 <= out.find("elif")
    if cond:
        args = l.split("	")
        count = 0
        for arg_str in args:
            if arg_str != "":
                l = arg_str
            else:
                count += 1
        l = "case " + l
        while count > 0:
            l = "	" + l
            count -= 1
    return l


def check_new(l):
    NAMES: [String] = ["preload", "load"]
    for n in NAMES:
        name = n + "(" + '"'
        search = ".gd" + '"'
        search += ").new()"
        if 0 <= l.find(name) and 0 <= l.find(search):
            l = l.replace(name, "")
            l = l.replace(search, "")
            name = l.split("=")[1]
            name = name.replace(" ", "")
            name = name.replace("//", "")
            lvl = name.split("/")
            lvl = len(lvl)
            search = ""
            for i in range(lvl - 1):
                search += name.split("/")[i] + "."
            search = left(search, len(search) - 1)
            name = name.split("/")[lvl - 1]
            while search.startswith("res:"):
                search = search.replace("res:", "")
            while 0 <= l.find(" = "):
                l = l.split(" = ")[0]
            while 0 <= l.find("="):
                l = l.split("=")[0]
            while not 0 <= l.find("var " + name):
                l = l.replace(
                    name, search + "." + name + " = " + name.upper() + ".new()"
                )
            while 0 <= l.find("var " + name):
                l = l.replace(
                    "var " + name, search + "." + name + " = " + name.upper() + ".new()"
                )
            s = l.replace("	", "")
            if s.startswith("."):
                l = l.replace(s, "")
                s = right(s, len(s) - 1)
                l = l + s
    return l


def analyze(l, package_name):
    l = check_match(l)
    l = check_new(l)
    out = ""
    quote = "'"
    quote += '"'
    quote += "'"
    string_prev = l.split(quote)
    c = 0
    for ii in range(0, len(string_prev)):
        string = string_prev[ii].split('"')
        if ii > 0:
            out += "'"
            out += '"'
            out += "'"
        for i in range(0, len(string)):
            if ii > 0:
                out += string[i]
            elif c ^ 1 != c + 1:
                out += '"' + string[i] + '"'
            else:
                out += translate(string[i], package_name)
            c += 1
    if len(out) > 0:
        res = "res"
        res += "://"
        while 0 <= out.find(res):
            out = out.replace(res, "")
        while 0 <= out.find("if") and out.endswith('"'):
            out += ":"
        if out.endswith(" "):
            out = left(out, len(out) - 1)
        out += "\n"
    return out


def dict(arg):
    e = ""
    if len(arg) == 0:
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
        defs.thread_def = True
        return e
    while arg.startswith("	"):
        e += "	"
        arg = right(arg, len(arg) - 1)
    con = False
    while 0 <= arg.find(".new()"):
        arg = arg.replace(".new()", "")
        if (
            not arg in props.gd_class
            and not arg in props.gds_class
            and not arg in props.gds_deps
        ):
            props.gds_deps.append(arg)
        arg = "import " + arg
        con = True
    if arg in props.types:
        return e
    if arg in props.extend:
        return e
    if arg in [
        "-s",
        "var",
        "const",
        "Node",
        "SceneTree",
        "extends",
        "class_name",
        "File",
    ]:
        e += props.repl_dict[arg]
        return e
    if arg in props.gds_deps:
        return e
    if arg in [
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
    ]:
        e += props.repl_dict[arg]
        e += " "
        return e
    if arg == "';ziglang.__main__'],stdout,true,false)":
        e += props.repl_dict[arg]
        e += " "
        defs.zig_imp = True
        return e
    if arg == "_ready()" or arg == "_init()":
        e += props.repl_dict[arg]
        e += " "
        defs.init_def = True
        return e
    if arg.endswith("_ready()"):
        arg = arg.replace("_ready()", props.repl_dict["_ready()"])
        e += arg
        e += " "
        return e
    if arg.endswith("_init()"):
        arg = arg.replace("_init()", props.repl_dict["_init()"])
        e += arg
        e += " "
        return e
    if 0 <= arg.find("null"):
        arg = arg.replace("null", props.repl_dict["null"])
        e += arg
        e += " "
        return e
    if arg == "OS.execute('python',['-c','import":
        e += props.repl_dict[arg]
        defs.sys_imp = True
        return e
    if arg == "OS.execute('python',['-c',import_str1+":
        e += props.repl_dict[arg]
        defs.nuitka_imp = True
        return e
    if arg == "OS.execute('python',['-c',nuitka+":
        e += props.repl_dict[arg]
        return e
    if arg == "OS.execute('python',['-c',import_str2+":
        e += props.repl_dict[arg]
        defs.black_imp = True
        return e
    if arg == "OS.execute('python',['-c',import_str3+":
        e += props.repl_dict[arg]
        defs.sys_imp = True
        return e
    if arg == "OS.execute('python',['-c',imp+":
        e += props.repl_dict[arg]
        defs.black_imp = True
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
        defs.sys_imp = True
        return e
    if arg == "#!/usr/bin/godot":
        e += props.repl_dict[arg]
        defs.py_imp = True
        e += " "
        return e
    while 0 <= arg.find(".to_lower()"):
        arg = arg.replace(".to_lower()", ".lower()")
        con = True
    while 0 <= arg.find(".to_upper()"):
        arg = arg.replace(".to_upper()", ".upper()")
        con = True
    while 0 <= arg.find("printraw("):
        arg = arg.replace("printraw(", "sys.stdout.write(")
        defs.sys_imp = True
        con = True
    while 0 <= arg.find(".resize("):
        arg = arg.replace("resize(", "")
        defs.resize_def = True
        if 0 <= arg.find("("):
            arg = arg.replace("(", "(resize(")
        else:
            arg = "resize(" + arg
        arg = arg.replace(".", ", ")
        con = True
    while 0 <= arg.find(".size()"):
        arg = arg.replace(".size()", ")")
        if 0 <= arg.find("("):
            arg = arg.replace("(", "(len(")
        else:
            arg = "len(" + arg
        con = True
    while 0 <= arg.find(".length()"):
        arg = arg.replace(".length()", ")")
        if 0 <= arg.find("("):
            arg = arg.replace("(", "(len(")
        else:
            arg = "len(" + arg
        con = True
    while 0 <= arg.find(".right("):
        arg = arg.replace(".right(", ", ")
        arg = "right(" + arg
        defs.right_def = True
        con = True
    while 0 <= arg.find(".left("):
        arg = arg.replace(".left(", ", ")
        arg = "left(" + arg
        defs.left_def = True
        con = True
    while 0 <= arg.find(".open"):
        arg = arg.replace(".open", " = open")
        con = True
    while 0 <= arg.find(".begins_with"):
        arg = arg.replace(".begins_with", ".startswith")
        con = True
    while 0 <= arg.find(".ends_with"):
        arg = arg.replace(".ends_with", ".endswith")
        con = True
    while 0 <= arg.find(".find("):
        arg = arg.replace(".find(", ".index(")
        con = True
    while 0 <= arg.find(".contains"):
        arg = arg.replace(".contains", ".find")
        arg = "0 <= " + arg
        con = True
    while 0 <= arg.find("file.FileOpts.READ"):
        r = ""
        r += '"'
        r += "r"
        r += '"'
        arg = arg.replace("file.FileOpts.READ", r)
        con = True
    while 0 <= arg.find("file.FileOpts.WRITE"):
        w = ""
        w += '"'
        w += "w"
        w += '"'
        arg = arg.replace("file.FileOpts.WRITE", w)
        con = True
    while 0 <= arg.find("print()"):
        arg = arg.replace("print()", "print('\\n')")
        con = True
    while 0 <= arg.find("randi()"):
        arg = arg.replace("randi()", "random.randint(0, 2147483647)")
        defs.rand_imp = True
        con = True
    while 0 <= arg.find(".push_back("):
        arg = arg.replace(".push_back(", ".append(")
        con = True
    while 0 <= arg.find(".pop_front()"):
        arg = arg.replace(".pop_front()", ".pop(0)")
        con = True
    while 0 <= arg.find(".remove_at("):
        arg = arg.replace(".remove_at(", ".pop(")
        con = True
    while 0 <= arg.find(".get_as_text"):
        arg = arg.replace(".get_as_text", ".read")
        con = True
    while 0 <= arg.find(".store_string"):
        arg = arg.replace(".store_string", ".write")
        con = True
    while 0 <= arg.find(".clear()"):
        arg = arg.replace(".clear()", " = []")
        con = True
    while 0 <= arg.find("_self,"):
        arg = arg.replace("_self,", "")
        con = True
    while 0 <= arg.find("_self"):
        arg = arg.replace("_self", "self")
        con = True
    while 0 <= arg.find("Time.get_ticks_msec()"):
        arg = arg.replace(
            "Time.get_ticks_msec()",
            "round(datetime.datetime.utcnow().timestamp() * 1000)",
        )
        defs.datetime_imp = True
        con = True
    while 0 <= arg.find("OS.get_cmdline_args()"):
        arg = arg.replace("OS.get_cmdline_args()", "sys.argv")
        con = True
    while 0 <= arg.find("Engine.get_version_info()"):
        arg = arg.replace(
            "Engine.get_version_info()",
            str(
                {
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
            ),
        )
        con = True
    while 0 <= arg.find("sqrt(") and not 0 <= arg.find("math.sqrt("):
        arg = arg.replace("sqrt(", "math.sqrt(")
        defs.math_imp = True
        con = True
    while 0 <= arg.find("atan2(") and not 0 <= arg.find("math.atan2("):
        arg = arg.replace("atan2(", "math.atan2(")
        defs.math_imp = True
        con = True
    while 0 <= arg.find("sin(") and not 0 <= arg.find("math.sin("):
        arg = arg.replace("sin(", "math.sin(")
        defs.math_imp = True
        con = True
    while 0 <= arg.find("cos(") and not 0 <= arg.find("math.cos("):
        arg = arg.replace("cos(", "math.cos(")
        defs.math_imp = True
        con = True
    found = False
    for type in props.types:
        while arg.startswith(type):
            found = True
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


def translate(e, package_name):
    if e == ",":
        return ","
    if e == "":
        return ""
    if 0 <= e.find("class_name"):
        script_name = e.split(" ")[1]
        props.gds_deps.append(script_name)
    if 0 <= e.find("extends"):
        script_name = e.split(" ")[1]
        if script_name not in props.types:
            props.extend.append(script_name)
    args = e.split(" ")
    e = ""
    for arg in args:
        e += dict(arg)
    while 0 <= e.find("	"):
        e = e.replace("	", "    ")
    while 0 <= e.find(": ="):
        e = e.replace(": =", "=")
    while 0 <= e.find(":="):
        e = e.replace(":=", "=")
    while 0 <= e.find(": )"):
        e = e.replace(": )", ")")
    while 0 <= e.find(":)"):
        e = e.replace(":)", ")")
    while 0 <= e.find(": ,"):
        e = e.replace(": ,", ",")
    while 0 <= e.find(":,"):
        e = e.replace(":,", ",")
    while 0 <= e.find(" -> "):
        e = e.replace(" -> ", "")
    while 0 <= e.find("DisplayServer"):
        e = ""
    while 0 <= e.find("OS"):
        e = ""
    index = 0
    for gds_name in props.gds_deps:
        while 0 <= e.find(gds_name.lower() + " = import " + gds_name):
            e = e.replace(
                gds_name.lower() + " = import " + gds_name, "import " + gds_name.lower()
            )
            if 0 <= e.find("."):
                if 0 <= e.find(package_name):
                    packages = e.split(".")
                    l = len(packages)
                    imp = packages[l - 1]
                    imp_b = imp.split(" ")[1]
                    package = ""
                    while l > 1:
                        package = packages[l - 2] + "/" + package
                        l -= 1
                    package = left(package, len(package) - 1)
                    defs.os_imp = True
                    e = "    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), '..')))"
                    e += "\n"
                    while 0 <= package.find(" "):
                        e += " "
                        package = right(package, len(package) - 1)
                    e += "import " + package.replace("/", ".") + "." + imp_b
                    props.gds_deps[index] = "../" + package + "/" + imp_b
            else:
                # Shallow copy, https://stackoverflow.com/a/11173076
                gds = gds_name.lower()
                b = package_name + "." + gds
                str1 = "import " + gds
                str2 = "import " + b + "; "
                str3 = (
                    gds + " =  type(" + b + ")(" + b + ".__name__, " + b + ".__doc__); "
                )
                str4 = gds + ".__dict__.update(" + b + ".__dict__)"
                e = e.replace(str1, str2 + str3 + str4)
        index += 1
    return e


def set_def(arr):
    if len(arr) != 17:
        return
    defs.py_imp = defs.py_imp or arr[0]
    defs.debug = defs.debug or arr[1]
    defs.verbose = defs.verbose or arr[2]
    defs.init_def = defs.init_def or arr[3]
    defs.thread_def = defs.thread_def or arr[4]
    defs.resize_def = defs.resize_def or arr[5]
    defs.right_def = defs.right_def or arr[6]
    defs.left_def = defs.left_def or arr[7]
    defs.newinstance_def = defs.newinstance_def or arr[8]
    defs.sys_imp = defs.sys_imp or arr[9]
    defs.os_imp = defs.os_imp or arr[10]
    defs.nuitka_imp = defs.nuitka_imp or arr[11]
    defs.black_imp = defs.black_imp or arr[12]
    defs.math_imp = defs.math_imp or arr[13]
    defs.rand_imp = defs.math_imp or arr[14]
    defs.datetime_imp = defs.datetime_imp or arr[15]
    defs.zig_imp = defs.zig_imp or arr[16]


def get_def():
    return [
        defs.py_imp,
        defs.debug,
        defs.verbose,
        defs.init_def,
        defs.thread_def,
        defs.resize_def,
        defs.right_def,
        defs.left_def,
        defs.newinstance_def,
        defs.sys_imp,
        defs.os_imp,
        defs.nuitka_imp,
        defs.black_imp,
        defs.math_imp,
        defs.rand_imp,
        defs.datetime_imp,
        defs.zig_imp,
    ]


def left(s, amount):
    return s[:amount]


def right(s, amount):
    return s[len(s) - amount :]
