import subprocess


def execute(program, args):
    stdout = []
    stdout = py_execute(program, args)
    return stdout


def execute_pipe(program, args):
    pipe = info["stdio"]
    main = (self, "_start_thread").bind(pipe)
    thread = Thread()
    thread.start(main)
    thread.wait_to_finish()
    pipe.close()


def _start_thread(pipe):
    line = ""
    while pipe.is_open() and pipe.get_error() == OK:
        c = char(pipe.get_8())
        if c == "\n":
            print(line)
            line = ""
        else:
            line += c


def py_execute(program, args):
    args = [program] + args
    proc = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = proc.communicate()
    return [stdout.decode("utf-8")]


class Thread:
    def start(self, function):
        return

    def is_alive(self):
        return True
