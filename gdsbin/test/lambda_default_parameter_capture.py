class_name = "Lambda_default_parameter_capture"
# https://github.com/godotengine/godot/issues/56751
def test():
    x = "local"
    lambda = func(param = x):
        print(param)
    lambda.call()
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script