class_name = "Trailing_comma_in_function_args"


# See https://github.com/godotengine/godot/issues/41066.
def f(
    p,
):  ## <-- no errors
    print(p)


def test():
    f(
        0,
    )  ## <-- no error


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
