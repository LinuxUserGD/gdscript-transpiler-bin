class_name = "Whiles"


def test():
    i = 0
    while i < 5:
        print(i)
        i += 1


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
