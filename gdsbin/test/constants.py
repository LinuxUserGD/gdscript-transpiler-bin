class_name = "Constants"


def test():
    _TEST = 12 + 34 - 56 * 78
    _STRING = "yes"
    _VECTOR = (5, 6)
    _ARRAY = []
    _DICTIONARY = {"this": "dictionary"}
    # Create user constants from built-in constants.
    _HELLO = PI + TAU
    _INFINITY = INF
    _NOT_A_NUMBER = NAN


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
