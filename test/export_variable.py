@export example = 99
@export_range(0, 100) example_range = 100
@export_range(0, 100, 1) example_range_step = 101
@export_range(0, 100, 1, "or_greater") example_range_step_or_greater = 102
@export color:
def test():
    print(example)
    print(example_range)
    print(example_range_step)
    print(example_range_step_or_greater)
    print(color)
