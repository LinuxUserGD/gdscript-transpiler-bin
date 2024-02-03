class_name Export_variable

@export var example = 99
@export_range(0, 100) var example_range = 100
@export_range(0, 100, 1) var example_range_step = 101
@export_range(0, 100, 1, "or_greater") var example_range_step_or_greater = 102
@export var color: Color


func test():
	print(example)
	print(example_range)
	print(example_range_step)
	print(example_range_step_or_greater)
	print(color)
