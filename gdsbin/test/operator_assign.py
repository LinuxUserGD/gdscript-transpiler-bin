class_name = "Operator_assign"


def test():
    i = 0
    i += 5
    i -= 4
    i *= 10
    i %= 8
    i /= 0.25
    print(round(i))


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
