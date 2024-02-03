class_name Lambda_capture_callable

func test():
	var x = 42
	var my_lambda = func(): print(x)
	my_lambda.call() # Prints "42".
