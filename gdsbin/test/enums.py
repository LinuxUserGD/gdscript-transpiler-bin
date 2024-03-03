#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys
enum Size {
    S = -10,
    M,
    L = 0,
    XL = 10,
    XXL,
}
def test():
    print(Size.S)
    print(Size.M)
    print(Size.L)
    print(Size.XL)
    print(Size.XXL)
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
