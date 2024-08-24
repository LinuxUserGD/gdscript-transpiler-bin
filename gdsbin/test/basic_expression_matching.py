class_name = "Basic_expression_matching"
def foo(x):
    match x:
        case 1:
            print( "1")
        case 2:
            print( "2")
        case [1, 2]:
            print( "[1, 2]")
        case 3 or 4:
            print( "3 or 4")
        case 4:
            print( "4")
        case {1 : 2, 2 : 3}:
            print( "{1 : 2, 2 : 3}")
        case _:
            print( "wildcard")
def test():
    foo(0)
    foo(1)
    foo(2)
    foo([1, 2])
    foo(3)
    foo(4)
    foo([4,4])
    foo({1 : 2, 2 : 3})
    foo({1 : 2, 4 : 3})
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script