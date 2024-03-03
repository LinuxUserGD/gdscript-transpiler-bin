#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    case  # Indexing from the beginning:
    print([1, 2, 3][0])
    print([1, 2, 3][1])
    print([1, 2, 3][2])
    case  # Indexing from the end:
    print([1, 2, 3][-1])
    print([1, 2, 3][-2])
    print([1, 2, 3][-3])
    # Float indices are currently allowed, but should probably be an error?
    print([1, 2, 3][0.4])
    print([1, 2, 3][0.8])
    print([1, 2, 3][1.0])
    print([1, 2, 3][-1.0])


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
