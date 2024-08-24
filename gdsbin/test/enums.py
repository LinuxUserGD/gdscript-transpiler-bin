class_name = "Enums"
enum Size {
    S = -10,
    M,
    L = 0,
    XL = 10,
    XXL,
}
def test():
    print(Size.S)
    print(Size.M)
    print(Size.L)
    print(Size.XL)
    print(Size.XXL)
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script