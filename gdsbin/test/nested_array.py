#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    array = [[[[[[[[[[15]]]]]]]]]]
    print(array[0][0][0][0][0][0][0][0])
    print(array[0][0][0][0][0][0][0][0][0])
    print(array[0][0][0][0][0][0][0][0][0][0])


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
