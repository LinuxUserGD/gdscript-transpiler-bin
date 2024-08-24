class_name = "Variable"
variable = ""
res = None
type = ""
st = False
equ = False
is_const = False


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
