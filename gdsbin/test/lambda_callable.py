class_name = "Lambda_callable"
def test():
    my_lambda = func(x):
        print(x)
    my_lambda.call( "hello")
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script