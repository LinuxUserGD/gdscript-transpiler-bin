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
    number = 1234
    match number:
        case 1234:
            print("1")
            match number:
                case 1234:
                    print("2")
                    match number:
                        case 1234:
                            print("3")
                            # TODO: not working in python yet
                            # continue
                        case _:
                            print("Should also be printed")
                            match number:
                                case 1234:
                                    print("4")
                                    match number:
                                        case _:
                                            print("5")
                                            match number:
                                                case false:
                                                    print("Should not be printed")
                                                case true:
                                                    print("Should not be printed")
                                                case "hello":
                                                    print("Should not be printed")
                                                case 1234:
                                                    print("6")
                                                    match number:
                                                        case _:
                                                            print("7")
                                                            match number:
                                                                case 1234:
                                                                    print("8")
                                                                    match number:
                                                                        case _:
                                                                            print("9")
                                                                            match number:
                                                                                case (
                                                                                    1234
                                                                                ):
                                                                                    print(
                                                                                        "10"
                                                                                    )
                                                                                    match number:
                                                                                        case _:
                                                                                            print(
                                                                                                "11"
                                                                                            )
                                                                                            match number:
                                                                                                case 1234:
                                                                                                    print(
                                                                                                        "12"
                                                                                                    )
                                                                                                    match number:
                                                                                                        case _:
                                                                                                            print(
                                                                                                                "13"
                                                                                                            )
                                                                                                            match number:
                                                                                                                case 1234:
                                                                                                                    print(
                                                                                                                        "14"
                                                                                                                    )
                                                                                                                    match number:
                                                                                                                        case _:
                                                                                                                            print(
                                                                                                                                "15"
                                                                                                                            )
                                                                                                                            match number:
                                                                                                                                case _:
                                                                                                                                    print(
                                                                                                                                        "16"
                                                                                                                                    )
                                                                                                                                    match number:
                                                                                                                                        case 1234:
                                                                                                                                            print(
                                                                                                                                                "17"
                                                                                                                                            )
                                                                                                                                            match number:
                                                                                                                                                case _:
                                                                                                                                                    print(
                                                                                                                                                        "18"
                                                                                                                                                    )
                                                                                                                                                    match number:
                                                                                                                                                        case 1234:
                                                                                                                                                            print(
                                                                                                                                                                "19"
                                                                                                                                                            )
                                                                                                                                                            match number:
                                                                                                                                                                case _:
                                                                                                                                                                    print(
                                                                                                                                                                        "20"
                                                                                                                                                                    )
                                                                                                                                                                    match number:
                                                                                                                                                                        case (
                                                                                                                                                                            []
                                                                                                                                                                        ):
                                                                                                                                                                            print(
                                                                                                                                                                                "Should not be printed"
                                                                                                                                                                            )
                case _:
                    print("Should not be printed")
        case 5678:
            print("Should not be printed either")


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
