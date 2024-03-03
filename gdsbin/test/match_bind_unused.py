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
