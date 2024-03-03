#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    # The assertions below should all evaluate to `true` for this test to pass.
    assert true
    assert not false
    assert 500
    assert not 0
    assert 500.5
    assert not 0.0
    assert "non-empty string"
    assert ["non-empty array"]
    assert {"non-empty": "dictionary"}
    assert Vector2(1, 0)
    assert Vector2i(-1, -1)
    assert Vector3(0, 0, 0.0001)
    assert Vector3i(0, 0, 10000)
    # Zero position is `true` only if the 's size is non-zero.
    assert Rect2(0, 0, 0, 1)
    # Zero size is `true` only if the position is non-zero.
    assert Rect2(1, 1, 0, 0)
    # Zero position is `true` only if the 's size is non-zero.
    assert Rect2i(0, 0, 0, 1)
    # Zero size is `true` only if the position is non-zero.
    assert Rect2i(1, 1, 0, 0)
    # A fully black color is only truthy if its alpha component is not equal to `1`.
    assert Color(0, 0, 0, 0.5)


def left(s, amount):
    return s[:amount]


def right(s, amount):
    return s[len(s) - amount :]


def resize(arr, size):
    if len(arr) == 0:
        arr.append(None)
    arr *= size
    return arr


if __name__ == "__main__":
    _init()
