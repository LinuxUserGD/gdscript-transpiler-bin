def foo(x):
    match x:
        case { "key1": "value1", "key2": "value2"}:
            print('{ "key1": "value1", "key2": "value2"}')
        case { "key1": "value1", "key2"}:
            print('{ "key1": "value1", "key2"}')
        case { "key1", "key2": "value2"}:
            print('{ "key1", "key2": "value2"}')
        case { "key1", "key2"}:
            print('{ "key1", "key2"}')
        case { "key1": "value1"}:
            print('{ "key1": "value1"}')
        case { "key1"}:
            print('{ "key1"}')
        case _:
            print( "wildcard")
def bar(x):
    match x:
        case {0}:
            print( "0")
        case {1}:
            print( "1")
        case {2}:
            print( "2")
        case _:
            print( "wildcard")
def test():
    foo({ "key1": "value1", "key2": "value2"})
    foo({ "key1": "value1", "key2": ""})
    foo({ "key1": "", "key2": "value2"})
    foo({ "key1": "", "key2": ""})
    foo({ "key1": "value1"})
    foo({ "key1": ""})
    foo({ "key1": "value1", "key2": "value2", "key3": "value3"})
    foo({ "key1": "value1", "key3": ""})
    foo({ "key2": "value2"})
    foo({ "key3": ""})
    bar({0: "0"})
    bar({1: "1"})
    bar({2: "2"})
    bar({3: "3"})
