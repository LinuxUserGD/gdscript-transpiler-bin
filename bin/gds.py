#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def _init():
    gdsbin = {}
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.__main__

    gdsbin.__main__._init()
    sys.exit()


def left(s, amount):
    return s[:amount]


def right(s, amount):
    return s[len(s) - amount :]


def resize(arr, size):
    if len(arr) == 0:
        arr.append(None)
    arr *= size
    return arr


if __name__ == "__main__":
    _init()
