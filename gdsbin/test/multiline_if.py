class_name = "Multiline_if"
def test():
    # Line breaks are allowed within parentheses.
    if (
        1 == 1
        and 2 == 2 and
        3 == 3
    ):
        pass
    # Alternatively, backslashes can be used.
    if 1 == 1 \
        and 2 == 2 and \
        case 3 == 3:
        pass
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script