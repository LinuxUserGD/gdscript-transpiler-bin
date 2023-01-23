class_name Benchmark

var _for_time = 0
var _test_results = []
const PRINT_PER_TEST_TIME = false
var _test_a = 1

func run() -> void:
	var __init__ = preload("res://test/__init__.gd").new()
	info("add")
	var start_ms: int = Time.get_ticks_msec()
	check(start_ms, add(), 0)
	info("product")
	start_ms = Time.get_ticks_msec()
	check(start_ms, product(), 3988008998000)
	info("rec")
	start_ms = Time.get_ticks_msec()
	check(start_ms, rec(), 0)
	info("arr_test")
	start_ms = Time.get_ticks_msec()
	check(start_ms, arr_test(), 1500)
	info("string")
	start_ms = Time.get_ticks_msec()
	check(start_ms, string(), 300000)
	info("pr_untyped")
	start_ms = Time.get_ticks_msec()
	check(start_ms, pr_untyped(), 655360)
	info("pr_typed")
	start_ms = Time.get_ticks_msec()
	check(start_ms, pr_typed(), 655360)
	info("i_arr_untyped")
	start_ms = Time.get_ticks_msec()
	check(start_ms, i_arr_untyped(), 0)
	info("i_arr_typed")
	start_ms = Time.get_ticks_msec()
	check(start_ms, i_arr_typed(), 0)
	info("str_arr_untyped")
	start_ms = Time.get_ticks_msec()
	check(start_ms, str_arr_untyped(), 0)
	info("str_arr_typed")
	start_ms = Time.get_ticks_msec()
	check(start_ms, str_arr_untyped(), 0)
	info("str_arr_packed")
	start_ms = Time.get_ticks_msec()
	check(start_ms, str_arr_packed(), 0)
	microtests()
	return	

func start() -> int:
	return Time.get_ticks_msec()

func stop(_test_name, _time_before):
	const ITERATIONS = 250000
	var time = Time.get_ticks_msec() - _time_before
	if _test_name.length() != 0:
		var test_time = time - _for_time
		
		if PRINT_PER_TEST_TIME:
			# Time taken for 1 test
			var k = 1000000.0 / ITERATIONS
			test_time = k * test_time
		
		print(_test_name + ": " + str(test_time))# + " (with for: " + str(time) + ")")
		_test_results.append({"name" : _test_name,"time" : test_time})
	return time

func microtests():
	const ITERATIONS = 250000
	print("-------------------")
	var _time_before = Time.get_ticks_msec()
	start()
	for i in range(0,ITERATIONS):
		pass
	_for_time = stop("", _time_before)
	print("For time: " + str(_for_time))
	print("")
	if PRINT_PER_TEST_TIME:
		print("The following times are in microseconds taken for 1 test.")
	else:
		print("The following times are in seconds for the whole test.")
	print("")
	#-------------------------------------------------------
	test_empty_func()
	test_increment()
	test_increment_x5()
	test_increment_with_member_var()
	test_increment_with_local_outside_loop()
	test_increment_with_local_inside_loop()
	test_unused_local()
	test_divide()
	test_increment_with_dictionary_member()
	test_increment_with_array_member()
	test_while_time()
	test_if_true()
	test_if_true_else()
	test_variant_array_resize()
	test_variant_array_assign()
	test_int_array_resize()
	test_int_array_assign()
	print("-------------------")
	print("Done.")

func str_arr_packed() -> int:
	const ITERATIONS: int = 80_000
	var array: PackedStringArray = []
	for i in range(0, ITERATIONS):
		# Insert elements.
		array.push_back("Godot " + str(i))
	for i in range(0, ITERATIONS):
		# Update elements in order.
		array[i] = ""
	for _i in range(0, ITERATIONS):
		# Delete elements from the front (non-constant complexity).
		array.remove_at(0)
	return array.size()

func str_arr_typed() -> int:
	const ITERATIONS: int = 80_000
	var array: Array[String] = []
	for i in range(0, ITERATIONS):
		# Insert elements.
		array.push_back("Godot " + str(i))
	for i in range(0, ITERATIONS):
		# Update elements in order.
		array[i] = ""
	for _i in range(0, ITERATIONS):
		# Delete elements from the front (non-constant complexity).
		array.pop_front()
	return array.size()

func str_arr_untyped() -> int:
	const ITERATIONS = 80_000
	var array = []
	for i in range(0, ITERATIONS):
		# Insert elements.
		array.push_back("Godot " + str(i))
	for i in range(0, ITERATIONS):
		# Update elements in order.
		array[i] = ""
	for _i in range(0, ITERATIONS):
		# Delete elements from the front (non-constant complexity).
		array.pop_front()
	return array.size()

func i_arr_untyped() -> int:
	const ITERATIONS = 80_000
	var array = []
	for i in range(0, ITERATIONS):
		# Insert elements.
		array.push_back(i)
	for i in range(0, ITERATIONS):
		# Update elements in order.
		array[i] = 0
	for _i in range(0, ITERATIONS):
		# Delete elements from the front (non-constant complexity).
		array.pop_front()
	return array.size()

func i_arr_typed() -> int:
	const ITERATIONS: int = 80_000
	var array: Array[int] = []
	for i in range(0, ITERATIONS):
		# Insert elements.
		array.push_back(i)
	for i in range(0, ITERATIONS):
		# Update elements in order.
		array[i] = 0
	for i in range(0, ITERATIONS):
		# Delete elements from the front (non-constant complexity).
		array.pop_front()
	return array.size()

func pr_untyped() -> int:
	const elems = 655360
	var arr = []
	for x in range(elems):
		arr.append(randi() % elems)
	var acc = 0.0
	for e in arr:
		var e2 = arr[e]
		var e3 = arr[e2]
		acc += e * e2
		acc *= e3 + e
		acc = sqrt(acc)
	return arr.size()

func pr_typed() -> int:
	const elems: int = 655360
	var arr: PackedInt32Array = []
	for x in range(elems):
		arr.append(randi() % elems)
	var acc : float = 0.0
	for e in arr:
		var e2 :int = arr[e]
		var e3 :int = arr[e2]
		acc += e * e2
		acc *= e3 + e
		acc = sqrt(acc)
	return arr.size()

func arr_test() -> int:
	var array: Array = []
	while array.size() < 1500:
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
	var x := -10000000
	for i in range(0, 10000000):
		x += 1
	return x

func product() -> int:
	var prod: int = 0
	for x in range(1, 2000):
		for y in range(1, 2000):
			prod += x*y
			prod -= x
			prod -= y
	return prod

func rec() -> int:
	for x in range(1, 10):
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

func check(start_ms: int, _a, b) -> void:
	if _a != b:
		not_passed()
	else:
		passed()
		var result_ms: float = Time.get_ticks_msec()-start_ms
		print("Time to run: " + str(result_ms/1000) + "s")
	return


#-------------------------------------------------------------------------------
func test_empty_func():
	const ITERATIONS = 250000
	var _time_before = start()
	
	for i in range(0,ITERATIONS):
		empty_func()
	
	stop("Empty func (void function call cost)", _time_before)

func empty_func():
	pass

#-------------------------------------------------------------------------------
func test_increment():
	const ITERATIONS = 250000
	var __a = 0
	var _time_before = start()
	
	for i in range(0,ITERATIONS):
		__a += 1
	
	stop("Increment", _time_before)

#-------------------------------------------------------------------------------
func test_increment_x5():
	const ITERATIONS = 250000
	var _a = 0
	var _time_before = start()
	
	for i in range(0,ITERATIONS):
		_a += 1
		_a += 1
		_a += 1
		_a += 1
		_a += 1
	
	stop("Increment x5", _time_before)

#-------------------------------------------------------------------------------
func test_increment_with_member_var():
	const ITERATIONS = 250000
	var _a = 0
	var _time_before = start()
	
	for i in range(0,ITERATIONS):
		_a += _test_a
	
	stop("Increment with member var", _time_before)

#-------------------------------------------------------------------------------
func test_increment_with_local_outside_loop():
	const ITERATIONS = 250000
	var _a = 0
	var b = 1
	var _time_before = start()
	
	for i in range(0,ITERATIONS):
		_a += b
	
	stop("Increment with local (outside loop)", _time_before)

#-------------------------------------------------------------------------------
func test_increment_with_local_inside_loop():
	const ITERATIONS = 250000
	var _a = 0
	var _time_before = start()
	
	for i in range(0,ITERATIONS):
		var b = 1
		_a += b
	
	stop("Increment with local (inside loop)", _time_before)

#-------------------------------------------------------------------------------
func test_unused_local():
	const ITERATIONS = 250000
	var _time_before = start()
	
	for i in range(0,ITERATIONS):
		var _b = 1
	
	stop("Unused local (declaration cost)", _time_before)

#-------------------------------------------------------------------------------
func test_divide():
	const ITERATIONS = 250000
	var _time_before = start()
	
	var _a = 9999
	for i in range(0,ITERATIONS):
		_a /= 1.01
	
	stop("Divide", _time_before)

#-------------------------------------------------------------------------------
func test_increment_with_dictionary_member():
	const ITERATIONS = 250000
	var _time_before = start()
	
	var _a = 0
	var dic = {"b" : 1}
	for i in range(0,ITERATIONS):
		_a += dic["b"]
	
	stop("Increment with dictionary member", _time_before)

#-------------------------------------------------------------------------------
func test_increment_with_array_member():
	const ITERATIONS = 250000
	var _time_before = start()
	
	var _a = 0
	var arr = [1]
	for i in range(0,ITERATIONS):
		_a += arr[0]
	
	stop("Increment with array member", _time_before)

#-------------------------------------------------------------------------------
func test_while_time():
	const ITERATIONS = 250000
	var _time_before = start()
	
	var i = 0
	while i < ITERATIONS:
		i += 1
		
	print("While time (for equivalent with manual increment): " + str(Time.get_ticks_msec() - _time_before))

#-------------------------------------------------------------------------------
func test_if_true():
	const ITERATIONS = 250000
	var _time_before = start()
	const boolean: bool = true
	for i in range(0,ITERATIONS):
		if boolean:
			pass
	
	stop("if(true) time", _time_before)

#-------------------------------------------------------------------------------
func test_if_true_else():
	const ITERATIONS = 250000
	var _time_before = start()
	const boolean: bool = true
	for i in range(0,ITERATIONS):
		if boolean:
			pass
		else:
			pass
	
	stop("if(true)else time", _time_before)

#-------------------------------------------------------------------------------
func test_variant_array_resize():
	const ITERATIONS = 250000
	var _time_before = start()
	for i in range(0,ITERATIONS):
		var line = []
		line.resize(1000)
	stop("VariantArray resize", _time_before)

#-------------------------------------------------------
func test_variant_array_assign():
	const ITERATIONS = 250000
	var v_array = []
	v_array.resize(100)
	
	var _time_before = start()
	for i in range(0, ITERATIONS):
		v_array[42] = 0
	
	stop("VariantArray set element", _time_before)

#-------------------------------------------------------
func test_int_array_resize():
	const ITERATIONS = 250000
	var _time_before = start()
	for i in range(0,ITERATIONS):
		var line: PackedInt32Array = []
		line.resize(1000)
	
	stop("PoolIntArray resize", _time_before)
		
#-------------------------------------------------------
func test_int_array_assign():
	const ITERATIONS = 250000
	var i_array: PackedInt32Array = []
	i_array.resize(100)

	var _time_before = start()
	for i in range(0, ITERATIONS):
		i_array[42] = 0
	
	stop("PoolIntArray set element", _time_before)
