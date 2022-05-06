import gdsbin.tg

tg = type(gdsbin.tg)(gdsbin.tg.__name__, gdsbin.tg.__doc__)
tg.__dict__.update(gdsbin.tg.__dict__)


def start(function):
    tg.t = Thread()
    tg.t.start(function)


def is_alive():
    return tg.t.is_alive()


def wait_to_finish():
    tg.t.wait_to_finish()
    tg.t = None


class Thread:
    def start(self, function):
        return

    def is_alive(self):
        return True
