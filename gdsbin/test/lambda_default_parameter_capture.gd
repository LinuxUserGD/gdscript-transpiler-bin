class_name Lambda_default_parameter_capture

# https://github.com/godotengine/godot/issues/56751

func test():
	var x = "local"
	var lambda = func(param = x):
		print(param)
	lambda.call()
