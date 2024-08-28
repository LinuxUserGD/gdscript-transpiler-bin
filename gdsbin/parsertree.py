class_name = "Parsertree"


def printtree(element, level):
    match element.get_script().get_global_name():
        case "Root":
            dictionary = {}
            if len(element.elem) > 0:
                for i in range(0, len(element.elem)):
                    dictionary["Root" + str(i)] = printtree(element.elem[i], level)
            return dictionary
        case "Comment":
            return {"Comment": {element.comment: None}}
        case "Classn":
            return {"class_name": {element.classn: None}}
        case "Extend":
            return {"extends": {element.extend: None}}
        case "Function":
            return {"Function": None}
        case "Variable":
            return {"Variable": {element.variable: None}}
        case "Forloop":
            return {"Forloop": None}
        case "Ifcond":
            return {"Ifconf": None}
        case "Callnew":
            return {"Callnew": None}
    return {"": None}


def printpt(element, level):
    match element.get_script().get_global_name():
        case "Root":
            out = ""
            if len(element.elem) > 0:
                for e in element.elem:
                    for i in range(level):
                        out += "	"
                    out += printpt(e, level)
            return out
        case "Comment":
            return element.comment + "\n"
        case "Classn":
            return "class_name " + element.classn + "\n"
        case "Extend":
            return "extends " + element.extend + "\n"
        case "Function":
            out = ""
            out += "func " + element.function + "("
            s = len(element.args)
            if s != 0:
                for i in range(0, s - 1, 1):
                    out += eval_call(element.args[i]) + ", "
                out += eval_call(element.args[s - 1])
            out += ")"
            if element.ret:
                out += " -> "
                out += element.res
            out += ":"
            out += "\n"
            if element.root != None:
                out += printpt(element.root, level + 1)
            return out
        case "Variable":
            out = "var"
            if element.is_const:
                out = "const"
            out += " " + element.variable
            if element.st:
                out += ": "
            if element.type != "":
                out += element.type
            if element.equ:
                out += " = "
                out += eval_call(element.res)
            return out + "\n"
        case "Forloop":
            out = "for"
            out += " " + parse_call(element.f)
            out += " " + "in"
            out += " " + parse_call(element.i)
            out += ":"
            out += "\n"
            if element.root != None:
                out += printpt(element.root, level + 1)
            return out
        case "Ifcond":
            out = "i"
            out += "f"
            out += " " + parse_call(element.i)
            out += ":"
            out += "\n"
            if element.root != None:
                out += printpt(element.root, level + 1)
            return out
        case "Callnew":
            return parse_call(element) + "\n"
    return ""


def eval_call(element):
    out = ""
    if element != None:
        if element.get_script().get_global_name() == "Stringname":
            out += element.string
        elif element.get_script().get_global_name() == "Dictionaryname":
            out += "{}"
        elif element.get_script().get_global_name() == "Callnew":
            if element.builtin_function:
                out += element.name.lower()
            else:
                out += element.name
            if element.function:
                out += "("
                s = len(element.args)
                if s != 0:
                    for i in range(0, s - 1, 1):
                        out += eval_call(element.args[i]) + ", "
                    out += eval_call(element.args[s - 1])
                out += ")"
            while element.callnew != None:
                element = element.callnew
                out += "."
                if element.builtin_function:
                    out += element.name.lower()
                else:
                    out += element.name
                if element.function:
                    out += "("
                    s = len(element.args)
                    if s != 0:
                        for i in range(0, s - 1, 1):
                            out += eval_call(element.args[i])
                            out += ", "
                        out += eval_call(element.args[s - 1])
                    out += ")"
        else:
            out += str(element).replace(" ", "")
    return out


def parse_call(element):
    out = ""
    if element.builtin_function:
        out += element.name.lower()
    else:
        out += element.name
    if element.function:
        out += "("
        s = len(element.args)
        if s != 0:
            for i in range(0, s - 1, 1):
                out += eval_call(element.args[i]) + ", "
            out += eval_call(element.args[s - 1])
        out += ")"
    while element.callnew != None:
        element = element.callnew
        out += "."
        if element.builtin_function:
            out += element.name.lower()
        else:
            out += element.name
        if element.function:
            out += "("
            s = len(element.args)
            if s != 0:
                for i in range(0, s - 1, 1):
                    out += eval_call(element.args[i])
                    out += ", "
                out += eval_call(element.args[s - 1])
            out += ")"
    if element.equ:
        if element.op == "":
            out += " = "
        elif element.op == "PLUS":
            out += " += "
        elif element.op == "MINUS":
            out += " -= "
        elif element.op == "ASTERISK":
            out += " *= "
        elif element.op == "SLASH":
            out += " /= "
        out += eval_call(element.res)
    return out


def printrec(e, ch):
    s = ""
    k = e.keys()
    i = len(k) - 1
    for item in k:
        s += ch
        s += "├─" if i != 0 else "└─" if ch != "" else "──"
        s += "┐ " if e[item] != None else "  "
        s += item
        s += "\n"
        if e[item] != None:
            s += printrec(e[item], ch + ("│ " if i != 0 else "  "))
        i -= 1
    return s


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
