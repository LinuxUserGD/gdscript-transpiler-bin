class_name = "Multiline_vector"


def test():
    (1, 2)
    (
        3,
        3.5,
        4,  # Trailing comma should work.
    )
    i(
        1,
        2,
    )  # Trailing comma should work.
    i(6, 9, 12)


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
