#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys
@export example = 99
@export_range(0, 100) example_range = 100
@export_range(0, 100, 1) example_range_step = 101
@export_range(0, 100, 1, "or_greater") example_range_step_or_greater = 102
@export color:
def test():
    print(example)
    print(example_range)
    print(example_range_step)
    print(example_range_step_or_greater)
    print(color)
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
