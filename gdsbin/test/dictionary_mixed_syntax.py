class_name = "Dictionary_mixed_syntax"
def test():
    # Mixing Python-style and Lua-style syntax in the same dictionary declaration
    # is allowed.
    dict = {
         "hello": {
            world = {
                 "is": "beautiful",
            },
        },
    }
    print(dict)
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script