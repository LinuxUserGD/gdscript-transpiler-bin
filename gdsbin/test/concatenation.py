class_name = "Concatenation"


def test():
    print(20 + 20)
    print("hello" + "world")
    print([1, 2] + [3, 4])


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
