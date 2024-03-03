#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


# GDTEST_OK
def test():
    a()
    b()
    c()
    d()
    e()


def a():
    print("a")


def b():
    print("b1")
    print("b2")


def c():
    print("c1")
    print("c2")


def d():
    print("d1")
    print("d2")


def e():
    print("e1")
    print("e2")


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
