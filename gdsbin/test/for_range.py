#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    for i in range(5):
        print(i)
    print("\n")
    case  # Equivalent to the above `for` loop:
    for i in 5:
        print(i)
    print("\n")
    for i in range(1, 5):
        print(i)
    print("\n")
    for i in range(1, -5, -1):
        print(i)
    print("\n")
    for i in [2, 4, 6, -8]:
        print(i)
    print("\n")
    for i in [true, false]:
        print(i)
    print("\n")
    for i in [Vector2i(10, 20), i(-30, -40)]:
        print(i)
    print("\n")
    for i in "Hello_Unicôde_world!_🦄":
        print(i)


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
