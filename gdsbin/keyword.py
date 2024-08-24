class_name = "Keyword"
KW_NONE = 0
KW_CLASSNAME = -1
KW_EXTENDS = -2
KW_NUMBERSIGN2 = -3
KW_FUNCTION = -4
KW_NEW = -5
KW_VARIABLE = -6
KW_CONST = -7
KW_FOR = -8
KW_IN = -9
KW_IF = -10


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
