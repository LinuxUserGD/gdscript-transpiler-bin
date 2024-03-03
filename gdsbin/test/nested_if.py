#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def test():
    # 20 levels of nesting (and then some).
    if true:
        print("1")
        if true:
            print("2")
            if true:
                print("3")
                if true:
                    print("4")
                    if true:
                        print("5")
                        if true:
                            print("6")
                            if true:
                                print("7")
                                if true:
                                    print("8")
                                    if true:
                                        print("9")
                                        if true:
                                            print("10")
                                            if true:
                                                print("11")
                                                if true:
                                                    print("12")
                                                    if true:
                                                        print("13")
                                                        if true:
                                                            print("14")
                                                            if true:
                                                                print("15")
                                                                if true:
                                                                    print("16")
                                                                    if true:
                                                                        print("17")
                                                                        if true:
                                                                            print("18")
                                                                            if true:
                                                                                print(
                                                                                    "19"
                                                                                )
                                                                                if true:
                                                                                    print(
                                                                                        "20"
                                                                                    )
                                                                                    if false:
                                                                                        print(
                                                                                            "End"
                                                                                        )
                                                                                        if true:
                                                                                            if true:
                                                                                                if true:
                                                                                                    if true:
                                                                                                        if true:
                                                                                                            if true:
                                                                                                                if true:
                                                                                                                    if true:
                                                                                                                        if true:
                                                                                                                            if true:
                                                                                                                                if true:
                                                                                                                                    if true:
                                                                                                                                        print(
                                                                                                                                            "This won't be printed"
                                                                                                                                        )


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
