#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def printpt(element, level):
    match element.t():
        case "root":
            out = ""
            if len(element.elem) > 0:
                for e in element.elem:
                    for i in range(level):
                        out += "	"
                    out += printpt(e, level)
            return out
        case "comment":
            return element.comment + "\n"
        case "classname":
            return "class_name " + element.classn + "\n"
        case "extends":
            return "extends " + element.extend + "\n"
        case "function":
            out = ""
            out += "func " + element.function + "("
            s = len(element.args)
            if s != 0:
                for i in range(0, s - 1, 1):
                    out += element.args[i] + ", "
                out += element.args[s - 1]
            out += ")"
            if element.ret:
                out += " -> "
                out += element.res
            out += ":"
            out += "\n"
            if element.root != None:
                out += printpt(element.root, level + 1)
            return out
        case "variable":
            out = "var"
            if element.is_const:
                out = "const"
            out += " " + element.variable
            if element.st:
                out += ": "
            if element.type != "":
                out += element.type
            if element.equ:
                out += " = "
                if element.res != None:
                    out += str(element.res).replace(" ", "")
            return out + "\n"
        case "call":
            out = ""
            if element.builtin_function:
                out += element.name.lower()
            else:
                out += element.name
            if element.function:
                out += "("
                s = len(element.args)
                if s != 0:
                    for i in range(0, s - 1, 1):
                        out += element.args[i] + ", "
                    out += element.args[s - 1]
                out += ")"
            while element.callnew != None:
                element = element.callnew
                out += "."
                if element.builtin_function:
                    out += element.name.lower()
                else:
                    out += element.name
                if element.function:
                    out += "("
                    s = len(element.args)
                    if s != 0:
                        for i in range(0, s - 1, 1):
                            out += element.args[i] + ", "
                        out += element.args[s - 1]
                    out += ")"
            if element.equ:
                out += " = "
                if element.res != None:
                    if element.res.t() == "call":
                        if element.res.builtin_function:
                            out += element.res.name.lower()
                        else:
                            out += element.res.name
                        if element.res.function:
                            out += "("
                            s = len(element.res.args)
                            if s != 0:
                                for i in range(0, s - 1, 1):
                                    out += element.res.args[i] + ", "
                                out += element.res.args[s - 1]
                            out += ")"
                        while element.res.callnew != None:
                            element.res = element.res.callnew
                            out += "."
                            if element.res.builtin_function:
                                out += element.res.name.lower()
                            else:
                                out += element.res.name
                            if element.res.function:
                                out += "("
                                s = len(element.res.args)
                                if s != 0:
                                    for i in range(0, s - 1, 1):
                                        out += element.res.args[i] + ", "
                                    out += element.res.args[s - 1]
                                out += ")"
                    else:
                        out += str(element.res).replace(" ", "")
            return out + "\n"
    return ""


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
