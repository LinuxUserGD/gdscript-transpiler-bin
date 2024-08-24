class_name = "Multiline_arrays"


def test():
    __ = [
        "this",
        "is",
        "a",
        "multiline",
        "array",
        "with mixed indentation and trailing comma",
    ]


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
