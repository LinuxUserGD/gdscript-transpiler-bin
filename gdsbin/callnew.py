class_name = "Callnew"
equ = False
res = None
name = ""
function = False
op = ""
args = []
builtin_function = False
callnew = None


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
