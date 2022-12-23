extends SceneTree

func _init() -> void:
	print(give_me_value())
	print(unit_test())
	print(benchmark1())
	print(benchmark2())
	self.quit()
	return


func give_me_value() -> int:
	return 5


func unit_test() -> int:
	var tmp1 := -(1 + 2) * 3 - 4 / 5
	var tmp2 := 4
	var tmp3 := give_me_value()
	var i := 0
	while i < 5:
		i += 1
	i = 0
	if 1 != 0 && 1 >= 0:
		i += 1
	if 1 == 0 || 1 <= 0:
		i += 1
	if true or false:
		i += 1
	for j in range(0, 4, 2):
		i += j
	return tmp1 + tmp2 + tmp3 + i


func benchmark1() -> int:
	var result : int = 0
	for i in range(0, 20): # 1 000 000
		result = result * 3 / 2 + 1
	return result


func benchmark2() -> int:
	var sum := 0
	var n1 := 0
	var n2 := 1
	for i in range(0, 20): # 1 000 000
		var n := n2
		n2 = n2 + n1
		n1 = n
		sum += n2
	return sum
