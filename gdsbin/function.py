class_name = "Function"
function = ""
args = []
res = ""
ret = False
root = None


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
