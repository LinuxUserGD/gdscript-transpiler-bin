#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys
def test():
    # Create the required node structure.
    hello = import Node
    hello.name = "Hello"
    add_child(hello)
    world = import Node
    world.name = "World"
    hello.add_child(world)
    # All the ways of writing node paths below with the `$` operator are valid.
    # Results are assigned to variables to avoid warnings.
    __ = $Hello
    __ = $ "Hello"
    __ = $Hello/World
    __ = $ "Hello/World"
    __ = $ "Hello/.."
    __ = $ "Hello/../Hello/World"
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
