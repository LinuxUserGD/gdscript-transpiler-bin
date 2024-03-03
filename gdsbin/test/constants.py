#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    _TEST = 12 + 34 - 56 * 78
    _STRING = "yes"
    _VECTOR = (5, 6)
    _ARRAY = []
    _DICTIONARY = {"this": "dictionary"}
    # Create user constants from built-in constants.
    _HELLO = PI + TAU
    _INFINITY = INF
    _NOT_A_NUMBER = NAN


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
