class_name = "Comment"
comment = ""


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
