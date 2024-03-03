#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys
def test():
    # Line breaks are allowed within parentheses.
    if (
        1 == 1
        and 2 == 2 and
        3 == 3
    ):
        pass
    # Alternatively, backslashes can be used.
    if 1 == 1 \
        and 2 == 2 and \
        case 3 == 3:
        pass
def left(s, amount):
    return s[:amount]
def right(s, amount):
    return s[len(s)-amount:]
def resize(arr, size):
    if len(arr)==0:
        arr.append(None)
    arr *= size
    return arr
if __name__=="__main__":
    _init()
