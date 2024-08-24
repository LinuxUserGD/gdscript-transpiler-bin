class_name = "Nested_parentheses"


def test():
    (print("Hello world!"))
    print(("Hello world 2!"))
    print(((2) + (4)))


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
