#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    (1, 2)
    (
        3,
        3.5,
        4,  # Trailing comma should work.
    )
    i(
        1,
        2,
    )  # Trailing comma should work.
    i(6, 9, 12)


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
