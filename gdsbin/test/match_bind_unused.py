#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


# https://github.com/godotengine/godot/pull/61666
def test():
    dict = {"key": "value"}
    match dict:
        case {"key": value}:
            print(value)  # used, no warning
    match dict:
        case {"key": value}:
            pass  # unused, warning
    match dict:
        case {"key": _value}:
            pass  # unused, suppressed warning from underscore


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
