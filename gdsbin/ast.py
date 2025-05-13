class_name = "Ast"
import gdsbin.key

key = type(gdsbin.key)(gdsbin.key.__name__, gdsbin.key.__doc__)
key.__dict__.update(gdsbin.key.__dict__)
import gdsbin.keyword

keyword = type(gdsbin.keyword)(gdsbin.keyword.__name__, gdsbin.keyword.__doc__)
keyword.__dict__.update(gdsbin.keyword.__dict__)


def ast(startln, endln, level, root, unit, con):
    for i in range(startln, endln, 1):
        input = unit[i]
        conline = con[i]
        if len(input) < level + 1:
            continue
        tabcount = 0
        for ii in range(0, len(input), 1):
            if input[ii].id == key.KEY_TAB:
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
        if input[level].id == key.KEY_NUMBERSIGN:
            _number_sign(root, conline, level)
            continue
        if input[level].id == keyword.KW_NUMBERSIGN2:
            _number_sign(root, conline, level)
            continue
        if input[level].id == keyword.KW_CLASSNAME:
            _classname(root, input, level)
            continue
        if input[level].id == keyword.KW_EXTENDS:
            _extend(root, input, level)
            continue
        if input[level].id == keyword.KW_FUNCTION:
            _function(i, endln, level, root, input, unit, con)
            continue
        if input[level].id == keyword.KW_FOR:
            _for_in(i, endln, level, root, input, unit, con)
            continue
        if input[level].id == keyword.KW_IF:
            _if_cond(i, endln, level, root, input, unit, con)
            continue
        if input[level].id == keyword.KW_VARIABLE:
            is_const = False
            _variable(root, input, level, is_const)
            continue
        if input[level].id == keyword.KW_CONST:
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
    classn.classn = input[level + 1].value
    root.elem.append(classn)


# print(input)
def _extend(root, input, level):
    import gdsbin.extend

    extend = type(gdsbin.extend)(gdsbin.extend.__name__, gdsbin.extend.__doc__)
    extend.__dict__.update(gdsbin.extend.__dict__)
    extend.extend = input[level + 1].value
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
        if input[level + 1].id == key.KEY_PERIOD:
            callnew.name = input[level].value
            callnew.callnew = _new_call(input, level + 2)
        elif len(input) > 2:
            callnew.name = _eval_string(input, 0).string
    else:
        callnew.name = input[level].value
    return callnew


def _new_call(input, level):
    import gdsbin.callnew

    callnew = type(gdsbin.callnew)(gdsbin.callnew.__name__, gdsbin.callnew.__doc__)
    callnew.__dict__.update(gdsbin.callnew.__dict__)
    s = len(input)
    if level + 1 < s:
        if input[level + 1].id == key.KEY_PERIOD:
            callnew.name = input[level].value
            callnew.callnew = _new_call(input, level + 2)
        elif input[level + 1].id == key.KEY_EQUAL:
            callnew.name = input[level].value
            callnew.equ = True
            array = []
            for i in range(level + 2, len(input)):
                array.append(input[i])
            callnew.res = _eval(array)
        elif input[level + 1].id in [
            key.KEY_PLUS,
            key.KEY_MINUS,
            key.KEY_ASTERISK,
            key.KEY_SLASH,
        ]:
            callnew.name = input[level].value
            callnew.equ = True
            callnew.op = input[level + 1].value
            array = []
            for i in range(level + 2, len(input)):
                array.append(input[i])
            callnew.res = _eval(array)
        elif input[
            level + 1
        ].id == key.KEY_PARENLEFT and key.KEY_PARENRIGHT in _get_ids(input):
            end = _get_ids(input).index(key.KEY_PARENRIGHT, level + 2)
            callnew.name = input[level].value
            callnew.function = True
            callnew.builtin_function = _builtin_function(input[level])
            args = []
            for i in range(level + 2, end):
                args.append(input[i])
            if len(args) != 0:
                callnew.args = _eval_function_args(args)
        elif len(input) > 2:
            callnew.name = _eval_string(input, 0).string
    elif level + 1 == s:
        callnew.name = input[level].value
    return callnew


def _get_ids(tokens):
    arr = []
    for i in tokens:
        arr.append(i.id)
    return arr


def _eval_dictionary(_array):
    import gdsbin.dictionaryname

    dictionaryname = type(gdsbin.dictionaryname)(
        gdsbin.dictionaryname.__name__, gdsbin.dictionaryname.__doc__
    )
    dictionaryname.__dict__.update(gdsbin.dictionaryname.__dict__)
    dictionaryname.items = []
    return dictionaryname


def _cut_string(msg, level):
    l = len(msg)
    return right(msg, l - level)


def _eval_string(array, level):
    s = ""
    for i in range(level, level + 3):
        s += array[i].value
    import gdsbin.stringname

    stringname = type(gdsbin.stringname)(
        gdsbin.stringname.__name__, gdsbin.stringname.__doc__
    )
    stringname.__dict__.update(gdsbin.stringname.__dict__)
    stringname.string = s
    return stringname


def _eval_function_args(array):
    arr = []
    ast_arr = []
    import gdsbin.token

    token = type(gdsbin.token)(gdsbin.token.__name__, gdsbin.token.__doc__)
    token.__dict__.update(gdsbin.token.__dict__)
    token.id = key.KEY_COMMA
    token.value = ","
    array.append(token)
    for i in range(0, len(array)):
        if array[i].id == key.KEY_COMMA:
            ast_arr.append(_arg_call(arr, 0))
            arr = []
        else:
            arr.append(array[i])
    return ast_arr


def _variable(root, input, level, is_const):
    import gdsbin.variable

    variable = type(gdsbin.variable)(gdsbin.variable.__name__, gdsbin.variable.__doc__)
    variable.__dict__.update(gdsbin.variable.__dict__)
    variable.variable = input[level + 1].value
    variable.is_const = is_const
    if input[level + 2].id == key.KEY_COLON:
        variable.st = True
        level += 1
        if input[level + 2].id != key.KEY_EQUAL:
            variable.type = input[level + 2].value
            level += 1
    if input[level + 2].id == key.KEY_EQUAL:
        variable.equ = True
        level += 1
        array = []
        for i in range(level + 2, len(input)):
            array.append(input[i])
        variable.res = _eval(array)
    root.elem.append(variable)


# print(input)
def _builtin_function(function):
    return function.id == keyword.KW_NEW


def _eval(array):
    s = len(array)
    variable = None
    if array[0].id == key.KEY_BRACELEFT and array[s - 1].id == key.KEY_BRACERIGHT:
        variable = _eval_dictionary(array)
        return variable
    if len(array) == 3:
        if array[0].id == key.KEY_QUOTEDBL and array[2].id == key.KEY_QUOTEDBL:
            variable = _eval_string(array, 0)
            return variable
    variable = _new_call(array, 0)
    return variable


def _for_in(startln, endln, level, root, input, unit, con):
    import gdsbin.forloop

    forloop = type(gdsbin.forloop)(gdsbin.forloop.__name__, gdsbin.forloop.__doc__)
    forloop.__dict__.update(gdsbin.forloop.__dict__)
    begin = -1
    if keyword.KW_IN in _get_ids(input):
        begin = _get_ids(input).index(keyword.KW_IN, level + 2)
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
    function.function = input[level + 1].value
    begin = -1
    if key.KEY_PARENLEFT in _get_ids(input):
        begin = _get_ids(input).index(key.KEY_PARENLEFT, level + 2)
    end = -1
    if key.KEY_PARENRIGHT in _get_ids(input):
        end = _get_ids(input).index(key.KEY_PARENRIGHT, begin + 1)
    arrow1 = -1
    if key.KEY_MINUS in _get_ids(input):
        arrow1 = _get_ids(input).index(key.KEY_MINUS, end + 1)
    arrow2 = -1
    if key.KEY_GREATER in _get_ids(input):
        arrow2 = _get_ids(input).index(key.KEY_GREATER, arrow1 + 1)
    colon = -1
    if key.KEY_COLON in _get_ids(input):
        colon = _get_ids(input).index(key.KEY_COLON, end + 1)
    if arrow1 > 0 and arrow2 > 0:
        function.ret = True
        function.res = input[colon - 1].value
    add = True
    while end - begin > 1:
        if add:
            import gdsbin.stringname

            stringname = type(gdsbin.stringname)(
                gdsbin.stringname.__name__, gdsbin.stringname.__doc__
            )
            stringname.__dict__.update(gdsbin.stringname.__dict__)
            stringname.string = input[begin + 1].value
            function.args.append(stringname)
            add = False
        if input[begin + 1].id == key.KEY_COMMA:
            add = True
        begin += 1
    function.root = ast(startln + 1, endln, level + 1, function.root, unit, con)
    root.elem.append(function)


# print(input)
def right(s, amount):
    return s[len(s) - amount :]


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
