def test():
    x = 42
    my_lambda = func(): print(x)
    my_lambda.call() # Prints "42".
