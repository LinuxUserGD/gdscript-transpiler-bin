#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    i = "Hello"
    match i:
        case "Hello":
            print("hello")
            # This will fall through to the default case below.
            # TODO: not working in python yet
            # continue
        case "Good bye":
            print("bye")
        case _:
            print("default")
    j = 25
    match j:
        case 26:
            print("This won't match")
        case _:
            print("This will match")


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
