class_name = "For_range"


def test():
    for i in range(5):
        print(i)
    print("\n")
    case  # Equivalent to the above `for` loop:
    for i in 5:
        print(i)
    print("\n")
    for i in range(1, 5):
        print(i)
    print("\n")
    for i in range(1, -5, -1):
        print(i)
    print("\n")
    for i in [2, 4, 6, -8]:
        print(i)
    print("\n")
    for i in [true, false]:
        print(i)
    print("\n")
    for i in [Vector2i(10, 20), i(-30, -40)]:
        print(i)
    print("\n")
    for i in "Hello_Unicôde_world!_🦄":
        print(i)


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
