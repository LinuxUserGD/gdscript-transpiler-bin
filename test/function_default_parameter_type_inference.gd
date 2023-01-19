class_name Function_default_parameter_type_inference

func example(_number: int, _number2: int = 5, number3 := 10):
	return number3

func test():
	print(example(3))
