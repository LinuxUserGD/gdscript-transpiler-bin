class_name = "Semicolon_as_terminator"


# GDTEST_OK
def test():
    a()
    b()
    c()
    d()
    e()


def a():
    print("a")


def b():
    print("b1")
    print("b2")


def c():
    print("c1")
    print("c2")


def d():
    print("d1")
    print("d2")


def e():
    print("e1")
    print("e2")


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
