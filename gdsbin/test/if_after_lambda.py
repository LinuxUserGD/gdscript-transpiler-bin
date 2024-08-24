class_name = "If_after_lambda"
# https://github.com/godotengine/godot/issues/61231
def test():
    my_lambda = func():
        print( "hello")
    if 0 == 0:
        my_lambda.call()
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script