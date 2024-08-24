class_name = "Match_multiple_patterns_with_array"


def foo(x):
    match x:
        case 1, [2]:
            print("1, [2]")
        case _:
            print("wildcard")


def bar(x):
    match x:
        case [[1], [2], [3]]:
            print("[1], [2], [3]")
        case [4]:
            print("[4]")
        case _:
            print("wildcard")


def test():
    foo(1)
    foo([2])
    foo(2)
    bar([1])
    bar([2])
    bar([3])
    bar([4])
    bar([5])


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
