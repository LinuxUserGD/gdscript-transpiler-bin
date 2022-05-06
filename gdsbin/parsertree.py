def printpt(element, level):
    match element.t():
        case "root":
            out = ""
            if len(element.elem) > 0:
                for e in element.elem:
                    for i in range(level):
                        out += "	"
                    out += printpt(e, level)
            return out
        case "comment":
            return element.comment + "\n"
        case "classname":
            return "class_name " + element.classn + "\n"
        case "extends":
            return "extends " + element.extend + "\n"
        case "function":
            out = ""
            out += "func " + element.function + "("
            s = len(element.args)
            if s != 0:
                for i in range(0, s - 1, 1):
                    out += element.args[i] + ", "
                out += element.args[s - 1]
            out += "):"
            out += "\n"
            if element.root != None:
                out += printpt(element.root, level + 1)
            return out
        case "variable":
            return "var " + element.vari + "\n"
    return ""
