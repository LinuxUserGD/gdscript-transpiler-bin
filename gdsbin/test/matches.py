def test():
    i = "Hello"
    match i:
        case "Hello":
            print("hello")
            # This will fall through to the default case below.
            # TODO: not working in python yet
            # continue
        case "Good bye":
            print("bye")
        case _:
            print("default")
    j = 25
    match j:
        case 26:
            print("This won't match")
        case _:
            print("This will match")
