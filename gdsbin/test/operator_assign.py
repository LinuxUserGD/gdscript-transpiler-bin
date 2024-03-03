#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    i = 0
    i += 5
    i -= 4
    i *= 10
    i %= 8
    i /= 0.25
    print(round(i))


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
