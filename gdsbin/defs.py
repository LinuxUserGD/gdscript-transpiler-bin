class_name = "Defs"
py_imp = False
debug = False
verbose = False
init_def = False
thread_def = False
resize_def = False
right_def = False
left_def = False
execute_def = False
execute_pipe_def = False
classname_def = False
sys_imp = False
subprocess_imp = False
os_imp = False
math_imp = False
rand_imp = False
datetime_imp = False


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
