import gdsbin.props

props = type(gdsbin.props)(gdsbin.props.__name__, gdsbin.props.__doc__)
props.__dict__.update(gdsbin.props.__dict__)


def transpile(content):
    props.types.sort()
    t = ""
    for line in content.split("\n"):
        if not line.startswith("##"):
            t += analyze(line)
    if props.sys_imp:
        props.sys_imp = False
        t = "import sys" + "\n" + t
    if props.os_imp:
        props.os_imp = False
        t = "import os" + "\n" + t
    if props.rand_imp:
        props.rand_imp = False
        t = "import random" + "\n" + t
    if props.math_imp:
        props.math_imp = False
        t = "import math" + "\n" + t
    if props.nuitka_imp:
        props.nuitka_imp = False
        t = "from nuitka import Version" + "\n" + t
    if props.black_imp:
        props.black_imp = False
        t = "import black" + "\n" + t
    if props.zig_imp:
        props.zig_imp = False
        t = "import ziglang.__main__" + "\n" + t
    if props.datetime_imp:
        props.datetime_imp = False
        t = "import datetime" + "\n" + t
    if props.py_imp:
        props.py_imp = False
        t = "#!/usr/bin/env python" + "\n" + t
    if props.left_def:
        props.left_def = False
        t += "def left(s, amount):"
        t += "\n"
        t += "    return s[:amount]"
        t += "\n"
    if props.right_def:
        props.right_def = False
        t += "def right(s, amount):"
        t += "\n"
        t += "    return s[len(s)-amount:]"
        t += "\n"
    if props.thread_def:
        props.thread_def = False
        t += "class Thread:"
        t += "\n"
        t += "    def start(self, function):"
        t += "\n"
        t += "        return"
        t += "\n"
        t += "    def is_alive(self):"
        t += "        return True"
    if props.resize_def:
        props.resize_def = False
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
    if props.init_def:
        props.init_def = False
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
    if props.newinstance_def:
        props.newinstance_def = False
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


def generate_setup(path, pyproject_toml):
    content = ""
    if pyproject_toml:
        file = props.pyproject_toml
        for line in file:
            content += line + "\n"
    else:
        file = props.setup
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
    if (
        out.endswith(":")
        and not out.startswith("for")
        and not out.startswith("while")
        and not out.startswith("if")
        and not 0 <= out.find("(")
        and not 0 <= out.find(")")
        and not 0 <= out.find("match")
        and not out.startswith("else")
        and not 0 <= out.find("elif")
    ):
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
    names: [String] = ["preload", "load"]
    for n in names:
        name = n + "(" + '"'
        name += ""
        search = ".gd" + '"'
        search += ").new()"
        while 0 <= l.find(name) and 0 <= l.find(search):
            l = l.replace(name, "")
            l = l.replace(search, "")
            name = l.split("=")[1]
            name = name.replace(" ", "")
            name = name.replace("//", "")
            search = name.split("/")[0]
            while search.startswith("res:"):
                search = search.replace("res:", "")
            name = name.split("/")[1]
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
            name = n + "(" + '"'
            name += ""
            search = ".gd" + '"'
            search += ").new()"
    return l


def analyze(l):
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
                out += translate(string[i])
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
    elif arg == "File.new()":
        e += props.repl_dict[arg]
        e += '"'
        e += '"'
        e += " "
        return e
    elif arg == "Thread.new()":
        e += props.repl_dict[arg]
        e += "	Thread()"
        e += " "
        props.thread_def = True
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
    elif arg in props.extend:
        return e
    elif arg in [
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
    elif arg in props.gds_deps:
        return e
    elif arg in [
        "func",
        "true",
        "false",
        "&&",
        "||",
        "sys;print(sys.version)'],stdout,true,false)",
        "';print(Version.getNuitkaVersion())'],stdout,true,false)",
        "';print(black.__version__)'],stdout,true,false)",
        "';black.reformat_one(src=src,fast=False,write_back=write_back,mode=mode,report=report)'],stdout,true,false)",
        "';nuitka.__main__.main()'],stdout,true,false)",
        "';ziglang.__main__'],stdout,true,false)",
    ]:
        e += props.repl_dict[arg]
        e += " "
        return e
    elif arg == "_ready()" or arg == "_init()":
        e += props.repl_dict[arg]
        e += " "
        props.init_def = True
        return e
    elif arg.endswith("_ready()"):
        arg = arg.replace("_ready()", props.repl_dict["_ready()"])
        e += arg
        e += " "
        return e
    elif arg.endswith("_init()"):
        arg = arg.replace("_init()", props.repl_dict["_init()"])
        e += arg
        e += " "
        return e
    elif 0 <= arg.find("null"):
        arg = arg.replace("null", props.repl_dict["null"])
        e += arg
        e += " "
        return e
    elif arg == "OS.execute('python',['-c','import":
        e += props.repl_dict[arg]
        props.sys_imp = True
        return e
    elif arg == "OS.execute('python',['-c',import_str1+":
        e += props.repl_dict[arg]
        props.nuitka_imp = True
        return e
    elif arg == "OS.execute('python',['-c',nuitka+":
        e += props.repl_dict[arg]
        return e
    elif arg == "OS.execute('python',['-c',import_str2+":
        e += props.repl_dict[arg]
        props.black_imp = True
        return e
    elif arg == "OS.execute('python',['-c',import_str3+":
        e += props.repl_dict[arg]
        props.sys_imp = True
        return e
    elif arg == "OS.execute('python',['-c',imp+":
        e += props.repl_dict[arg]
        props.black_imp = True
        return e
    elif arg == "OS.execute('python',['-c',xpy+":
        e += props.repl_dict[arg]
        return e
    elif arg == "OS.execute('python',['-c',nuitka+":
        e += props.repl_dict[arg]
        return e
    elif arg == "quit()" or arg == "self.quit()":
        e += props.repl_dict[arg]
        e += " "
        props.sys_imp = True
        return e
    elif arg == "#!/usr/bin/godot":
        e += props.repl_dict[arg]
        props.py_imp = True
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
        props.sys_imp = True
        con = True
    while 0 <= arg.find(".resize("):
        arg = arg.replace("resize(", "")
        props.resize_def = True
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
        props.right_def = True
        con = True
    while 0 <= arg.find(".left("):
        arg = arg.replace(".left(", ", ")
        arg = "left(" + arg
        props.left_def = True
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
        props.rand_imp = True
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
        props.datetime_imp = True
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
                    "patch": 0,
                    "hex": 262656,
                    "status": "stable",
                    "build": "gentoo",
                    "year": 2023,
                    "hash": "46dc277917a93cbf601bbcf0d27d00f6feeec0d5",
                    "string": "4.2-stable (gentoo)",
                }
            ),
        )
        con = True
    while 0 <= arg.find("sqrt(") and not 0 <= arg.find("math.sqrt("):
        arg = arg.replace("sqrt(", "math.sqrt(")
        props.math_imp = True
        con = True
    while 0 <= arg.find("atan2(") and not 0 <= arg.find("math.atan2("):
        arg = arg.replace("atan2(", "math.atan2(")
        props.math_imp = True
        con = True
    while 0 <= arg.find("sin(") and not 0 <= arg.find("math.sin("):
        arg = arg.replace("sin(", "math.sin(")
        props.math_imp = True
        con = True
    while 0 <= arg.find("cos(") and not 0 <= arg.find("math.cos("):
        arg = arg.replace("cos(", "math.cos(")
        props.math_imp = True
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
    if props.debug:
        print("DEBUG: " + arg)
    e += arg
    e += " "
    return e


def translate(e):
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
                if 0 <= e.find("gdsbin"):
                    imp = e.split(".")[1]
                    imp_b = imp.split(" ")[1]
                    package = e.split(".")[0]
                    props.os_imp = True
                    e = "    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), '..')))"
                    e += "\n"
                    while 0 <= package.find(" "):
                        e += " "
                        package = right(package, len(package) - 1)
                    e += "import " + package + "." + imp_b
                    props.gds_deps[index] = "../" + package + "/" + imp_b
                elif 0 <= e.find("test"):
                    imp = e.split(".")[1]
                    imp_b = imp.split(" ")[1]
                    package = e.split(".")[0]
                    props.os_imp = True
                    e = ""
                    while 0 <= package.find(" "):
                        e += " "
                        package = right(package, len(package) - 1)
                    e += "import " + package + "." + imp_b
                    props.gds_deps[index] = "../" + package + "/" + imp_b
            else:
                # Shallow copy, https://stackoverflow.com/a/11173076
                e = e.replace(
                    "import " + gds_name.lower(),
                    "import gdsbin."
                    + gds_name.lower()
                    + "; "
                    + gds_name.lower()
                    + " =  type(gdsbin."
                    + gds_name.lower()
                    + ")(gdsbin."
                    + gds_name.lower()
                    + ".__name__, gdsbin."
                    + gds_name.lower()
                    + ".__doc__); "
                    + gds_name.lower()
                    + ".__dict__.update(gdsbin."
                    + gds_name.lower()
                    + ".__dict__)",
                )
        index += 1
    return e


def left(s, amount):
    return s[:amount]


def right(s, amount):
    return s[len(s) - amount :]
