class_name = "Match_multiple_variable_binds_in_pattern"
def test():
    match [1, 2, 3]:
        case [var a, b, c]:
            print(a == 1)
            print(b == 2)
            print(c == 3)
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script