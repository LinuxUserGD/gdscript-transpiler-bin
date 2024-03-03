#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys

py_imp = False
debug = False
verbose = False
init_def = False
thread_def = False
resize_def = False
right_def = False
left_def = False
newinstance_def = False
sys_imp = False
os_imp = False
nuitka_imp = False
black_imp = False
math_imp = False
rand_imp = False
datetime_imp = False
zig_imp = False


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
