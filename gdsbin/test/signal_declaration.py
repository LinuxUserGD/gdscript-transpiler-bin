#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys
#GDTEST_OK
# No parentheses.
signal a
# No parameters.
signal b()
# With parameters.
signal c(a, b, c)
# With parameters multiline.
signal d(
    a,
    b,
    c,
)
def test():
    print( "Ok")
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
