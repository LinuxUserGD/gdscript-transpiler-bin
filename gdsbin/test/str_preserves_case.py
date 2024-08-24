class_name = "Str_preserves_case"


def test():
    None_var = None
    true_var = True
    false_var = False
    print(str(None_var))
    print(str(true_var))
    print(str(false_var))


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
