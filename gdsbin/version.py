class_name = "Version"
__version__ = "0.1.6"


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
