def ast(startln, endln, level, root, unit, con):
    for i in range(startln, endln, 1):
        input = unit[i]
        conline = con[i]
        if len(input) < level + 1:
            continue
        tabcount = 0
        for ii in range(0, len(input), 1):
            if input[ii] == "TAB":
                tabcount += 1
            else:
                break
        if tabcount > level:
            continue
        elif tabcount < level:
            break
        if root == None:
            import gdsbin.root

            root = type(gdsbin.root)(gdsbin.root.__name__, gdsbin.root.__doc__)
            root.__dict__.update(gdsbin.root.__dict__)
            root.elem = []
        if input[level] == "NUMBER SIGN":
            _number_sign(root, conline, level)
            continue
        if input[level] == "NUMBER SIGN 2":
            _number_sign(root, conline, level)
            continue
        if input[level] == "CLASS NAME":
            _classname(root, input, level)
            continue
        if input[level] == "EXTENDS":
            _extend(root, input, level)
            continue
        if input[level] == "FUNCTION":
            _function(i, endln, level, root, input, unit, con)
            continue
        if input[level] == "FOR":
            _for_in(i, endln, level, root, input, unit, con)
            continue
        if input[level] == "IF":
            _if_cond(i, endln, level, root, input, unit, con)
            continue
        if input[level] == "VARIABLE":
            is_const = False
            _variable(root, input, level, is_const)
            continue
        if input[level] == "CONST":
            is_const = True
            _variable(root, input, level, is_const)
            continue
        _call(root, input, level)
    return root


def _number_sign(root, conline, level):
    import gdsbin.comment

    comment = type(gdsbin.comment)(gdsbin.comment.__name__, gdsbin.comment.__doc__)
    comment.__dict__.update(gdsbin.comment.__dict__)
    comment.comment = _cut_string(conline, level)
    root.elem.append(comment)
    # print(input)


def _number_sign_2(root, conline, level):
    import gdsbin.comment

    comment = type(gdsbin.comment)(gdsbin.comment.__name__, gdsbin.comment.__doc__)
    comment.__dict__.update(gdsbin.comment.__dict__)
    comment.comment = _cut_string(conline, level)
    root.elem.append(comment)
    # print(input)


def _classname(root, input, level):
    import gdsbin.classn

    classn = type(gdsbin.classn)(gdsbin.classn.__name__, gdsbin.classn.__doc__)
    classn.__dict__.update(gdsbin.classn.__dict__)
    classn.classn = input[level + 1]
    root.elem.append(classn)
    # print(input)


def _extend(root, input, level):
    import gdsbin.extend

    extend = type(gdsbin.extend)(gdsbin.extend.__name__, gdsbin.extend.__doc__)
    extend.__dict__.update(gdsbin.extend.__dict__)
    extend.extend = input[level + 1]
    root.elem.append(extend)
    # print(input)


def _call(root, input, level):
    callx = _new_call(input, level)
    root.elem.append(callx)
    # print(input)


def _arg_call(input, level):
    import gdsbin.callnew

    callnew = type(gdsbin.callnew)(gdsbin.callnew.__name__, gdsbin.callnew.__doc__)
    callnew.__dict__.update(gdsbin.callnew.__dict__)
    s = len(input)
    if level + 1 < s:
        if input[level + 1] == "DOT":
            callnew.name = input[level]
            callnew.callnew = _new_call(input, level + 2)
        else:
            callnew.name = _eval_string(input, 0).string
    else:
        callnew.name = input[level]
    return callnew


def _new_call(input, level):
    import gdsbin.callnew

    callnew = type(gdsbin.callnew)(gdsbin.callnew.__name__, gdsbin.callnew.__doc__)
    callnew.__dict__.update(gdsbin.callnew.__dict__)
    s = len(input)
    if level + 1 < s:
        if input[level + 1] == "DOT":
            callnew.name = input[level]
            callnew.callnew = _new_call(input, level + 2)
        elif input[level + 1] == "EQUALS SIGN":
            callnew.name = input[level]
            callnew.equ = True
            array = []
            for i in range(level + 2, len(input)):
                array.append(input[i])
            callnew.res = _eval(array)
        elif input[level + 1] in ["PLUS", "MINUS", "ASTERISK", "SLASH"]:
            callnew.name = input[level]
            callnew.equ = True
            callnew.op = input[level + 1]
            array = []
            for i in range(level + 3, len(input)):
                array.append(input[i])
            callnew.res = _eval(array)
        elif input[level + 1] == "LEFT BRACKET" and "RIGHT BRACKET" in input:
            end = input.index("RIGHT BRACKET", level + 2)
            callnew.name = input[level]
            callnew.function = True
            callnew.builtin_function = _builtin_function(input[level])
            args = []
            for i in range(level + 2, end):
                args.append(input[i])
            if len(args) != 0:
                callnew.args = _eval_function_args(args)
        else:
            callnew.name = _eval_string(input, 0).string
    elif level + 1 == s:
        callnew.name = input[level]
    return callnew


def _eval_dictionary(_array):
    import gdsbin.dictionary

    dictionary = type(gdsbin.dictionary)(
        gdsbin.dictionary.__name__, gdsbin.dictionary.__doc__
    )
    dictionary.__dict__.update(gdsbin.dictionary.__dict__)
    dictionary.items = []
    return dictionary


def _cut_string(msg, level):
    l = len(msg)
    return right(msg, l - level)


def _eval_string(array, level):
    s = ""
    qu = '"'
    token = {
        "NUMBER SIGN": "#",
        "EXCLAMATION MARK": "!",
        "SLASH": "/",
        "BACKSLASH": "\\",
        "CLASS NAME": "class_name",
        "EXTENDS": "extends",
        "NUMBER SIGN 2": "##",
        "FUNCTION": "func",
        "LEFT BRACKET": "(",
        "RIGHT BRACKET": ")",
        "MINUS": "-",
        "PLUS": "+",
        "GREATER THAN": ">",
        "LESS THAN": "<",
        "COLON": ":",
        "EQUALS SIGN": "=",
        "CURLY LEFT BRACKET": "{",
        "CURLY RIGHT BRACKET": "}",
        "TAB": "\t",
        "DOT": ".",
        "NEW": "new",
        "VARIABLE": "var",
        "CONST": "const",
        "QUOTATION": qu,
    }
    for i in range(level, len(array)):
        s += token[array[i]] if array[i] in token else array[i]
    import gdsbin.string

    string = type(gdsbin.string)(gdsbin.string.__name__, gdsbin.string.__doc__)
    string.__dict__.update(gdsbin.string.__dict__)
    string.string = s
    return string


def _eval_function_args(array):
    arr = []
    ast_arr = []
    array.append("COMMA")
    for i in range(0, len(array)):
        if array[i] == "COMMA":
            ast_arr.append(_arg_call(arr, 0))
            arr = []
        else:
            arr.append(array[i])
    return ast_arr


def _variable(root, input, level, is_const):
    import gdsbin.variable

    variable = type(gdsbin.variable)(gdsbin.variable.__name__, gdsbin.variable.__doc__)
    variable.__dict__.update(gdsbin.variable.__dict__)
    variable.variable = input[level + 1]
    variable.is_const = is_const
    if input[level + 2] == "COLON":
        variable.st = True
        level += 1
        if input[level + 2] != "EQUALS SIGN":
            variable.type = input[level + 2]
            level += 1
    if input[level + 2] == "EQUALS SIGN":
        variable.equ = True
        level += 1
        array = []
        for i in range(level + 2, len(input)):
            array.append(input[i])
        variable.res = _eval(array)
    root.elem.append(variable)
    # print(input)


def _builtin_function(function):
    return function == "NEW"


def _eval(array):
    s = len(array)
    variable = None
    if array[0] == "CURLY LEFT BRACKET" and array[s - 1] == "CURLY RIGHT BRACKET":
        variable = _eval_dictionary(array)
        return variable
    if array[0] == "QUOTATION" and array[s - 1] == "QUOTATION":
        variable = _eval_string(array, 0)
        return variable
    variable = _new_call(array, 0)
    return variable


def _for_in(startln, endln, level, root, input, unit, con):
    import gdsbin.forloop

    forloop = type(gdsbin.forloop)(gdsbin.forloop.__name__, gdsbin.forloop.__doc__)
    forloop.__dict__.update(gdsbin.forloop.__dict__)
    begin = -1
    if "IN" in input:
        begin = input.index("IN", level + 2)
    end = len(input)
    f = []
    for i in range(level + 1, begin):
        f.append(input[i])
    x = []
    for i in range(begin + 1, end - 1):
        x.append(input[i])
    forloop.f = _new_call(f, 0)
    forloop.i = _new_call(x, 0)
    forloop.root = ast(startln + 1, endln, level + 1, forloop.root, unit, con)
    root.elem.append(forloop)


def _if_cond(startln, endln, level, root, input, unit, con):
    import gdsbin.ifcond

    ifcond = type(gdsbin.ifcond)(gdsbin.ifcond.__name__, gdsbin.ifcond.__doc__)
    ifcond.__dict__.update(gdsbin.ifcond.__dict__)
    end = len(input)
    i = []
    for x in range(level + 1, end - 1):
        i.append(input[x])
    ifcond.i = _new_call(i, 0)
    ifcond.root = ast(startln + 1, endln, level + 1, ifcond.root, unit, con)
    root.elem.append(ifcond)


def _function(startln, endln, level, root, input, unit, con):
    import gdsbin.function

    function = type(gdsbin.function)(gdsbin.function.__name__, gdsbin.function.__doc__)
    function.__dict__.update(gdsbin.function.__dict__)
    function.args = []
    function.function = input[level + 1]
    begin = -1
    if "LEFT BRACKET" in input:
        begin = input.index("LEFT BRACKET", level + 2)
    end = -1
    if "RIGHT BRACKET" in input:
        end = input.index("RIGHT BRACKET", begin + 1)
    arrow1 = -1
    if "MINUS" in input:
        arrow1 = input.index("MINUS", end + 1)
    arrow2 = -1
    if "GREATER THAN" in input:
        arrow2 = input.index("GREATER THAN", arrow1 + 1)
    colon = -1
    if "COLON" in input:
        colon = input.index("COLON", end + 1)
    if arrow1 > 0 and arrow2 > 0:
        function.ret = True
        function.res = input[colon - 1]
    add = True
    while end - begin > 1:
        if add:
            import gdsbin.string

            string = type(gdsbin.string)(gdsbin.string.__name__, gdsbin.string.__doc__)
            string.__dict__.update(gdsbin.string.__dict__)
            string.string = input[begin + 1]
            function.args.append(string)
            add = False
        if input[begin + 1] == "COMMA":
            add = True
        begin += 1
    function.root = ast(startln + 1, endln, level + 1, function.root, unit, con)
    root.elem.append(function)
    # print(input)


def right(s, amount):
    return s[len(s) - amount :]
