class_name = "Lambda_capture_callable"
def test():
    x = 42
    my_lambda = func(): print(x)
    my_lambda.call() # Prints "42".
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script