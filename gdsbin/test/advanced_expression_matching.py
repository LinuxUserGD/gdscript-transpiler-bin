def foo(x):
    match x:
        case 1 + 1:
            print( "1+1")
        case [1,2,[1,{1:2,2:var z,..}]]:
            print( "[1,2,[1,{1:2,2:var z,..}]]")
            print(z)
        case 1 if True else 2:
            print( "1 if true else 2")
        case 1 < 2:
            print( "1 < 2")
        case 1 or 2 and 1:
            print( "1 or 2 and 1")
        case 6 | 1:
            print( "1 | 1")
        case 1 >> 1:
            print( "1 >> 1")
        case 1, 2 or 3, 4:
            print( "1, 2 or 3, 4")
        case _:
            print( "wildcard")
def test():
    foo(6 | 1)
    foo(1 >> 1)
    foo(2)
    foo(1)
    foo(1+1)
    foo(1 < 2)
    foo([2, 1])
    foo(4)
    foo([1, 2, [1, {1 : 2, 2:3}]])
    foo([1, 2, [1, {1 : 2, 2:[1,3,5, "123"], 4:2}]])
    foo([1, 2, [1, {1 : 2}]])
