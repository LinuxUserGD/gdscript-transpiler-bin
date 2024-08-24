class_name = "Forloop"
f = None
i = None
root = None


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
