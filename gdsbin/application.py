import subprocess


def execute(program, args):
    stdout = []
    stdout = py_execute(program, args)
    return stdout


def py_execute(program, args):
    args = [program] + args
    proc = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = proc.communicate()
    return [stdout.decode("utf-8")]
