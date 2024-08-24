class_name = "Semicolon_as_end_statement"
def test():
    print( "A"); print( "B")
    # Multiple semicolons and whitespace between them is also valid.
    print( "A"); ;;;;; ; print( "B");;
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script