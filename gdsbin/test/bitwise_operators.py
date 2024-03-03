#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys
enum Flags {
    FIRE = 1 << 1,
    ICE = 1 << 2,
    SLIPPERY = 1 << 3,
    STICKY = 1 << 4,
    NONSOLID = 1 << 5,
    ALL = FIRE | ICE | SLIPPERY | STICKY | NONSOLID,
}
def test():
    flags = Flags.FIRE | Flags.SLIPPERY
    print(flags)
    flags = Flags.FIRE & Flags.SLIPPERY
    print(flags)
    flags = Flags.FIRE ^ Flags.SLIPPERY
    print(flags)
    flags = Flags.ALL & (Flags.FIRE | Flags.ICE)
    print(flags)
    flags = (Flags.ALL & Flags.FIRE) | Flags.ICE
    print(flags)
    flags = Flags.ALL & Flags.FIRE | Flags.ICE
    print(flags)
    # Enum value must be casted to an eger. Otherwise, a parser error is emitted.
    flags &= (Flags.ICE)
    print(flags)
    flags ^= (Flags.ICE)
    print(flags)
    flags |= (Flags.STICKY | Flags.SLIPPERY)
    print(flags)
    print('\n')
    num = 2 << 4
    print(num)
    num <<= 2
    print(num)
    num >>= 2
    print(num)
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
