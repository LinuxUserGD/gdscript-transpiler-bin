#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys
def test():
    __ = """"
    This is a standalone string, not a multiline comment.
    Writing both "double"quotes and 'simple' quotes is fine as
    long as there is only ""one ""or ''two'' of those in a row, not more.
    If you have more quotes, they need to be escaped like this: \ "\"\ ""
     """"
    __ = '''
    Another standalone string, this time with single quotes.
    Writing both "double"quotes and 'simple' quotes is fine as
    long as there is only ""one ""or ''two'' of those in a row, not more.
    If you have more quotes, they need to be escaped like this: \'\'\'
    '''
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
