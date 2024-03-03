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
        case 1:
            print( "1")
        case 2:
            print( "2")
        case [1, 2]:
            print( "[1, 2]")
        case 3 or 4:
            print( "3 or 4")
        case 4:
            print( "4")
        case {1 : 2, 2 : 3}:
            print( "{1 : 2, 2 : 3}")
        case _:
            print( "wildcard")
def test():
    foo(0)
    foo(1)
    foo(2)
    foo([1, 2])
    foo(3)
    foo(4)
    foo([4,4])
    foo({1 : 2, 2 : 3})
    foo({1 : 2, 4 : 3})
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
