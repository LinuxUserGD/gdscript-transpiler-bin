#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys
def test():
    # `_` can be used as a separator for numbers in GDScript.
    # It can be placed anywhere in the number, except at the beginning.
    # Currently, GDScript in the `master` branch only allows using one separator
    # per number.
    # Results are assigned to variables to avoid warnings.
    __ = 1_23
    __ = 123_ # Trailing number separators are OK.
    __ = 12_3
    __ = 123_456
    __ = 0x1234_5678
    __ = 0b1001_0101
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
