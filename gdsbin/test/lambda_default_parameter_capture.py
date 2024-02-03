# https://github.com/godotengine/godot/issues/56751
def test():
    x = "local"
    lambda = func(param = x):
        print(param)
    lambda.call()
