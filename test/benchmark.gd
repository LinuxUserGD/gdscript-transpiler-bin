extends SceneTree

func _init() -> void:
	info("string")
	check(string(), 300000)
	info("add")
	check(add(), 0)
	info("product")
	check(product(), 2498500224990000)
	info("rec")
	check(rec(), 0)
	info("arr")
	check(arr(), 7500)
	self.quit()
	return

func arr() -> int:
	var array: Array = []
	while array.size() < 7500:
		var s: int = array.size()
		array.append(str(s))
		var array2: Array = []
		for arr_elem in array:
			var elem: String = str(arr_elem)
			var size: int = elem.length()
			array2.append(size)
		array = array2
	return array.size()

func string() -> int:
	var x : String = ""
	for i in range(0, 300000):
		x += " "
	return x.length()

func add() -> int:
	var x := -100000000
	for i in range(0, 100000000):
		x += 1
	return x

func product() -> int:
	var prod: int = 0
	for x in range(1, 10000):
		for y in range(1, 10000):
			prod += x*y
			prod -= x
			prod -= y
	return prod

func rec() -> int:
	for x in range(1, 1000):
		var c: int = 600
		while (c > 0):
			recursion(c)
			c-=1
	return recursion(0)

func recursion(count: int) -> int:
	if count > 0:
		return recursion(count-1)
	else:
		return 0

func info(test: String) -> void:
	printraw(test.to_upper() + "...")

func not_passed() -> void:
	print(" [FAILED]")

func passed() -> void:
	print(" [OK]")

func check(a, b) -> void:
	if a != b:
		not_passed()
		self.quit()
	else:
		passed()
	return
