#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    case  # The following lines are equivalent:
    _integer = 1
    _integer2 = 1
    _inferred = 1
    _inferred2 = 1
    # Type inference is automatic for constants.
    _INTEGER = 1
    _INTEGER_REDUNDANT_TYPED = 1
    _INTEGER_REDUNDANT_TYPED2 = 1
    _INTEGER_REDUNDANT_INFERRED = 1
    _INTEGER_REDUNDANT_INFERRED2 = 1


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
