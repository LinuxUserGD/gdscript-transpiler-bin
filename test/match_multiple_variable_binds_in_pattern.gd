class_name Match_multiple_variable_binds_in_pattern

func test():
	match [1, 2, 3]:
		[var a, var b, var c]:
			print(a == 1)
			print(b == 2)
			print(c == 3)
