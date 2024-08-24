class_name = "Multiline_dictionaries"
def test():
    __ = {
         "multiline": "dictionary","should": "work",
         "even with": "a trailing comma",
    }
    __ = {
        this_also_applies = "to the",
        lua_style_syntax = None,         foo = None,
    }
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script