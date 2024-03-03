#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys
def test():
    lua_dict = {
        a = 1,
         "b"= 2, # Using strings are allowed too.
         "with spaces"= 3, # Especially useful when key has spaces...
         "2"= 4, # ... or invalid identifiers.
    }
    print(lua_dict)
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
