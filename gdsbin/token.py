class_name = "Token"
id = 0
value = ""


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
