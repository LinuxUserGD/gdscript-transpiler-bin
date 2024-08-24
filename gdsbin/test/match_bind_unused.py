class_name = "Match_bind_unused"


# https://github.com/godotengine/godot/pull/61666
def test():
    dict = {"key": "value"}
    match dict:
        case {"key": value}:
            print(value)  # used, no warning
    match dict:
        case {"key": value}:
            pass  # unused, warning
    match dict:
        case {"key": _value}:
            pass  # unused, suppressed warning from underscore


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
