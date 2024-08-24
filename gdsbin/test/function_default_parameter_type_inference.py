class_name = "Function_default_parameter_type_inference"


def example(_number, _number2=5, number3=10):
    return number3


def test():
    print(example(3))


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
