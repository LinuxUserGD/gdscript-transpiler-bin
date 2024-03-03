#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    case  # The following ing-point notations are all valid:
    print(is_equal_approx(123.0, 123))
    print(is_equal_approx(0.123, 0.123))
    print(is_equal_approx(0.123e4, 1230))
    print(is_equal_approx(123.0e4, 1.23e6))
    print(is_equal_approx(0.123e-1, 0.0123))
    print(is_equal_approx(123.0e-1, 12.3))
    # Same as above, but with negative numbers.
    print(is_equal_approx(-123.0, -123))
    print(is_equal_approx(-0.123, -0.123))
    print(is_equal_approx(-0.123e4, -1230))
    print(is_equal_approx(-123.0e4, -1.23e6))
    print(is_equal_approx(-0.123e-1, -0.0123))
    print(is_equal_approx(-123.0e-1, -12.3))
    # Same as above, but with explicit positive numbers (which is redundant).
    print(is_equal_approx(+123.0, +123))
    print(is_equal_approx(+0.123, +0.123))
    print(is_equal_approx(+0.123e4, +1230))
    print(is_equal_approx(+123.0e4, +1.23e6))
    print(is_equal_approx(+0.123e-1, +0.0123))
    print(is_equal_approx(+123.0e-1, +12.3))


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
