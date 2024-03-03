#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    None_var = None
    true_var = True
    false_var = False
    print(str(None_var))
    print(str(true_var))
    print(str(false_var))


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
