#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def foo(x):
    match x:
        case 1, [2]:
            print("1, [2]")
        case _:
            print("wildcard")


def bar(x):
    match x:
        case [1], [2], [3]:
            print("[1], [2], [3]")
        case [4]:
            print("[4]")
        case _:
            print("wildcard")


def test():
    foo(1)
    foo([2])
    foo(2)
    bar([1])
    bar([2])
    bar([3])
    bar([4])
    bar([5])


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
