import subprocess


def execute(program, args):
    stdout = []
    stdout = py_execute(program, args)
    return stdout


def execute_pipe(program, args):
    thread = Thread()
    pipe = info["stdio"]
    main = (self, "_start_thread").bind(thread, pipe)
    thread.start(main)


def _start_thread(t, pipe):
    line = ""
    while pipe.is_open() and pipe.get_error() == OK:
        c = char(pipe.get_8())
        if c == "\n":
            print(line)
            line = ""
        else:
            line += c
    line = ""
    pipe.close()
    exit = (self, "_exit_thread")
    exit.call_deferred(t)


def _exit_thread(t):
    t.wait_to_finish()


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
