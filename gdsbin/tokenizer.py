#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys


def tokenize(input_string):
    delimiter = [
        "(",
        ")",
        ":",
        ",",
        ".",
        "=",
        "+",
        "-",
        "*",
        "/",
        "<",
        ">",
        "!",
        "&",
        "|",
        "~",
        "%",
        " ",
        "[",
        "]",
        "{",
        "}",
        '"',
        "\t",
    ]
    qu = '"'
    token = {
        "#": "NUMBER SIGN",
        "!": "EXCLAMATION MARK",
        "/": "SLASH",
        "\\": "BACKSLASH",
        "class_name": "CLASS NAME",
        "extends": "EXTENDS",
        "##": "NUMBER SIGN 2",
        "func": "FUNCTION",
        "(": "LEFT BRACKET",
        ")": "RIGHT BRACKET",
        "-": "MINUS",
        "+": "PLUS",
        ">": "GREATER THAN",
        "<": "LESS THAN",
        ":": "COLON",
        "=": "EQUALS SIGN",
        "{": "CURLY LEFT BRACKET",
        "}": "CURLY RIGHT BRACKET",
        "\t": "TAB",
        ".": "DOT",
        ",": "COMMA",
        "new": "NEW",
        "var": "VARIABLE",
        "const": "CONST",
        qu: "QUOTATION",
    }
    tokens = []
    buffer = ""
    for ch in input_string:
        if ch in delimiter:
            if buffer != "":
                tokens.append(char_to_token(buffer, token))
                buffer = ""
            if ch != " ":
                tokens.append(char_to_token(ch, token))
        else:
            buffer += ch
    if buffer != "":
        tokens.append(char_to_token(buffer, token))
    return tokens


def char_to_token(buffer, token):
    return token[buffer] if buffer in token else buffer


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
