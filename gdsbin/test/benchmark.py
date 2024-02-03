import datetime
import math
import random
import sys

_for_time = 0
_test_results = []
PRINT_PER_TEST_TIME = False
_test_a = 1


def run():
    import gdsbin.__init__

    __init__ = type(gdsbin.__init__)(gdsbin.__init__.__name__, gdsbin.__init__.__doc__)
    __init__.__dict__.update(gdsbin.__init__.__dict__)
    info("add")
    start_ms = round(datetime.datetime.utcnow().timestamp() * 1000)
    check(start_ms, add(), 0)
    info("product")
    start_ms = round(datetime.datetime.utcnow().timestamp() * 1000)
    check(start_ms, product(), 3988008998000)
    info("rec")
    start_ms = round(datetime.datetime.utcnow().timestamp() * 1000)
    check(start_ms, rec(), 0)
    info("arr_test")
    start_ms = round(datetime.datetime.utcnow().timestamp() * 1000)
    check(start_ms, arr_test(), 1500)
    info("string")
    start_ms = round(datetime.datetime.utcnow().timestamp() * 1000)
    check(start_ms, string(), 300000)
    info("pr_untyped")
    start_ms = round(datetime.datetime.utcnow().timestamp() * 1000)
    check(start_ms, pr_untyped(), 655360)
    info("pr_typed")
    start_ms = round(datetime.datetime.utcnow().timestamp() * 1000)
    check(start_ms, pr_typed(), 655360)
    info("i_arr_untyped")
    start_ms = round(datetime.datetime.utcnow().timestamp() * 1000)
    check(start_ms, i_arr_untyped(), 0)
    info("i_arr_typed")
    start_ms = round(datetime.datetime.utcnow().timestamp() * 1000)
    check(start_ms, i_arr_typed(), 0)
    info("str_arr_untyped")
    start_ms = round(datetime.datetime.utcnow().timestamp() * 1000)
    check(start_ms, str_arr_untyped(), 0)
    info("str_arr_typed")
    start_ms = round(datetime.datetime.utcnow().timestamp() * 1000)
    check(start_ms, str_arr_untyped(), 0)
    info("str_arr_packed")
    start_ms = round(datetime.datetime.utcnow().timestamp() * 1000)
    check(start_ms, str_arr_packed(), 0)
    microtests()
    return


def start():
    return round(datetime.datetime.utcnow().timestamp() * 1000)


def stop(_test_name, _time_before):
    ITERATIONS = 250000
    time = round(datetime.datetime.utcnow().timestamp() * 1000) - _time_before
    if len(_test_name) != 0:
        test_time = time - _for_time

        if PRINT_PER_TEST_TIME:
            # Time taken for 1 test
            k = 1000000.0 / ITERATIONS
            test_time = k * test_time

        print(_test_name + ": " + str(test_time))  # + " (with for: "+ str(time) + ")")
        _test_results.append({"name": _test_name, "time": test_time})
    return time


def microtests():
    ITERATIONS = 250000
    print("-------------------")
    _time_before = round(datetime.datetime.utcnow().timestamp() * 1000)
    start()
    for i in range(0, ITERATIONS):
        pass
    _for_time = stop("", _time_before)
    print("For time: " + str(_for_time))
    print("")
    if PRINT_PER_TEST_TIME:
        print("The following times are in microseconds taken for 1 test.")
    else:
        print("The following times are in seconds for the whole test.")
    print("")
    # -------------------------------------------------------
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


def str_arr_packed():
    ITERATIONS = 80_000
    array = []
    for i in range(0, ITERATIONS):
        # Insert elements.
        array.append("Godot " + str(i))
    for i in range(0, ITERATIONS):
        # Update elements in order.
        array[i] = ""
    for _i in range(0, ITERATIONS):
        # Delete elements from the front (non-constant complexity).
        array.pop(0)
    return len(array)


def str_arr_typed():
    ITERATIONS = 80_000
    array: [String] = []
    for i in range(0, ITERATIONS):
        # Insert elements.
        array.append("Godot " + str(i))
    for i in range(0, ITERATIONS):
        # Update elements in order.
        array[i] = ""
    for _i in range(0, ITERATIONS):
        # Delete elements from the front (non-constant complexity).
        array.pop(0)
    return len(array)


def str_arr_untyped():
    ITERATIONS = 80_000
    array = []
    for i in range(0, ITERATIONS):
        # Insert elements.
        array.append("Godot " + str(i))
    for i in range(0, ITERATIONS):
        # Update elements in order.
        array[i] = ""
    for _i in range(0, ITERATIONS):
        # Delete elements from the front (non-constant complexity).
        array.pop(0)
    return len(array)


def i_arr_untyped():
    ITERATIONS = 80_000
    array = []
    for i in range(0, ITERATIONS):
        # Insert elements.
        array.append(i)
    for i in range(0, ITERATIONS):
        # Update elements in order.
        array[i] = 0
    for _i in range(0, ITERATIONS):
        # Delete elements from the front (non-constant complexity).
        array.pop(0)
    return len(array)


def i_arr_typed():
    ITERATIONS = 80_000
    array: [int] = []
    for i in range(0, ITERATIONS):
        # Insert elements.
        array.append(i)
    for i in range(0, ITERATIONS):
        # Update elements in order.
        array[i] = 0
    for i in range(0, ITERATIONS):
        # Delete elements from the front (non-constant complexity).
        array.pop(0)
    return len(array)


def pr_untyped():
    elems = 655360
    arr = []
    for x in range(elems):
        arr.append(random.randint(0, 2147483647) % elems)
    acc = 0.0
    for e in arr:
        e2 = arr[e]
        e3 = arr[e2]
        acc += e * e2
        acc *= e3 + e
        acc = math.sqrt(acc)
    return len(arr)


def pr_typed():
    elems = 655360
    arr = []
    for x in range(elems):
        arr.append(random.randint(0, 2147483647) % elems)
    acc = 0.0
    for e in arr:
        e2: int = arr[e]
        e3: int = arr[e2]
        acc += e * e2
        acc *= e3 + e
        acc = math.sqrt(acc)
    return len(arr)


def arr_test():
    array = []
    while len(array) < 1500:
        s = len(array)
        array.append(str(s))
        array2 = []
        for arr_elem in array:
            elem = str(arr_elem)
            size = len(elem)
            array2.append(size)
        array = array2
    return len(array)


def string():
    x = ""
    for i in range(0, 300000):
        x += " "
    return len(x)


def add():
    x = -10000000
    for i in range(0, 10000000):
        x += 1
    return x


def product():
    prod = 0
    for x in range(1, 2000):
        for y in range(1, 2000):
            prod += x * y
            prod -= x
            prod -= y
    return prod


def rec():
    for x in range(1, 10):
        c = 600
        while c > 0:
            recursion(c)
            c -= 1
    return recursion(0)


def recursion(count):
    if count > 0:
        return recursion(count - 1)
    else:
        return 0


def info(test):
    sys.stdout.write(test.upper() + "...")


def not_passed():
    print(" [FAILED]")


def passed():
    print(" [OK]")


def check(start_ms, _a, b):
    if _a != b:
        not_passed()
    else:
        passed()
        result_ms = round(datetime.datetime.utcnow().timestamp() * 1000) - start_ms
        print("Time to run: " + str(result_ms / 1000) + "s")
    return


# -------------------------------------------------------------------------------
def test_empty_func():
    ITERATIONS = 250000
    _time_before = start()

    for i in range(0, ITERATIONS):
        empty_func()

    stop("Empty func (void function call cost)", _time_before)


def empty_func():
    pass


# -------------------------------------------------------------------------------
def test_increment():
    ITERATIONS = 250000
    __a = 0
    _time_before = start()

    for i in range(0, ITERATIONS):
        __a += 1

    stop("Increment", _time_before)


# -------------------------------------------------------------------------------
def test_increment_x5():
    ITERATIONS = 250000
    _a = 0
    _time_before = start()

    for i in range(0, ITERATIONS):
        _a += 1
        _a += 1
        _a += 1
        _a += 1
        _a += 1

    stop("Increment x5", _time_before)


# -------------------------------------------------------------------------------
def test_increment_with_member_var():
    ITERATIONS = 250000
    _a = 0
    _time_before = start()

    for i in range(0, ITERATIONS):
        _a += _test_a

    stop("Increment with member var", _time_before)


# -------------------------------------------------------------------------------
def test_increment_with_local_outside_loop():
    ITERATIONS = 250000
    _a = 0
    b = 1
    _time_before = start()

    for i in range(0, ITERATIONS):
        _a += b

    stop("Increment with local (outside loop)", _time_before)


# -------------------------------------------------------------------------------
def test_increment_with_local_inside_loop():
    ITERATIONS = 250000
    _a = 0
    _time_before = start()

    for i in range(0, ITERATIONS):
        b = 1
        _a += b

    stop("Increment with local (inside loop)", _time_before)


# -------------------------------------------------------------------------------
def test_unused_local():
    ITERATIONS = 250000
    _time_before = start()

    for i in range(0, ITERATIONS):
        _b = 1

    stop("Unused local (declaration cost)", _time_before)


# -------------------------------------------------------------------------------
def test_divide():
    ITERATIONS = 250000
    _time_before = start()

    _a = 9999
    for i in range(0, ITERATIONS):
        _a /= 1.01

    stop("Divide", _time_before)


# -------------------------------------------------------------------------------
def test_increment_with_dictionary_member():
    ITERATIONS = 250000
    _time_before = start()

    _a = 0
    dic = {"b": 1}
    for i in range(0, ITERATIONS):
        _a += dic["b"]

    stop("Increment with dictionary member", _time_before)


# -------------------------------------------------------------------------------
def test_increment_with_array_member():
    ITERATIONS = 250000
    _time_before = start()

    _a = 0
    arr = [1]
    for i in range(0, ITERATIONS):
        _a += arr[0]

    stop("Increment with array member", _time_before)


# -------------------------------------------------------------------------------
def test_while_time():
    ITERATIONS = 250000
    _time_before = start()

    i = 0
    while i < ITERATIONS:
        i += 1

    print(
        "While time (for equivalent with manual increment): "
        + str(round(datetime.datetime.utcnow().timestamp() * 1000) - _time_before)
    )


# -------------------------------------------------------------------------------
def test_if_true():
    ITERATIONS = 250000
    _time_before = start()
    ean = True
    for i in range(0, ITERATIONS):
        if ean:
            pass

    stop("if(true) time", _time_before)


# -------------------------------------------------------------------------------
def test_if_true_else():
    ITERATIONS = 250000
    _time_before = start()
    ean = True
    for i in range(0, ITERATIONS):
        if ean:
            pass
        else:
            pass

    stop("if(true)else time", _time_before)


# -------------------------------------------------------------------------------
def test_variant_array_resize():
    ITERATIONS = 250000
    _time_before = start()
    for i in range(0, ITERATIONS):
        line = []
        resize(line, 1000)
    stop("VariantArray resize", _time_before)


# -------------------------------------------------------
def test_variant_array_assign():
    ITERATIONS = 250000
    v_array = []
    resize(v_array, 100)

    _time_before = start()
    for i in range(0, ITERATIONS):
        v_array[42] = 0

    stop("VariantArray set element", _time_before)


# -------------------------------------------------------
def test_int_array_resize():
    ITERATIONS = 250000
    _time_before = start()
    for i in range(0, ITERATIONS):
        line = []
        resize(line, 1000)

    stop("PoolIntArray resize", _time_before)


# -------------------------------------------------------
def test_int_array_assign():
    ITERATIONS = 250000
    i_array = []
    resize(i_array, 100)
    _time_before = start()
    for i in range(0, ITERATIONS):
        i_array[42] = 0

    stop("PoolIntArray set element", _time_before)


def resize(arr, size):
    if len(arr) == 0:
        arr.append(None)
    arr *= size
    return arr
