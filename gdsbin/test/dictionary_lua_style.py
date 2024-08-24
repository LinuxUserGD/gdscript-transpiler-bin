class_name = "Dictionary_lua_style"
def test():
    lua_dict = {
        a = 1,
         "b"= 2, # Using strings are allowed too.
         "with spaces"= 3, # Especially useful when key has spaces...
         "2"= 4, # ... or invalid identifiers.
    }
    print(lua_dict)
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script