# See https://github.com/godotengine/godot/issues/41066.
def f(
    p,
):  ## <-- no errors
    print(p)


def test():
    f(
        0,
    )  ## <-- no error
