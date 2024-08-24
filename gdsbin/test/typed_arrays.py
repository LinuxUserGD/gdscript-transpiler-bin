class_name = "Typed_arrays"


def test():
    my_array: [int] = [1, 2, 3]
    inferred_array = [1, 2, 3]  # This is [int].
    print(my_array)
    print(inferred_array)


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
