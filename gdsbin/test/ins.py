#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    print("dot" in "Godot")
    print(not "i" in "team")
    print(true in [true, false])
    print(not None in [true, false])
    print(None in [None])
    print(26 in [8, 26, 64, 100])
    print(not i(10, 20) in [Vector2i(20, 10)])
    print("apple" in {"apple": "fruit"})
    print("apple" in {"apple": None})
    print(not "apple" in {"fruit": "apple"})


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
