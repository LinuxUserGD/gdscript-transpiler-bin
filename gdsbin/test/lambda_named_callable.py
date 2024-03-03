#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys
def i_take_lambda(lambda, param):
    lambda.call(param)
def test():
    my_lambda = def this_is_lambda(x):
        print( "Hello")
        print( "This is %s"% x)
    i_take_lambda(my_lambda, "a lambda")
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
