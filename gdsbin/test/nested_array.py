class_name = "Nested_array"


def test():
    array = [[[[[[[[[[15]]]]]]]]]]
    print(array[0][0][0][0][0][0][0][0])
    print(array[0][0][0][0][0][0][0][0][0])
    print(array[0][0][0][0][0][0][0][0][0][0])


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
