#!/usr/bin/env python
import datetime
import black
from nuitka import Version
import math
import random
import os
import sys

setuptools_min_ver = 42
package_name = "gdsbin"
author = "LinuxUserGD"
author_email = "hugegameartgd@gmail.com"
project_url = "https://codeberg.org/LinuxUserGD/gdscript-transpiler-bin"
download_url = "https://linuxusergd.itch.io/gdscript-transpiler-bin"
documentation_url = "https://codeberg.org/LinuxUserGD/gdscript-transpiler-bin/wiki"
source_url = "https://codeberg.org/LinuxUserGD/gdscript-transpiler-bin"
tracker_url = "https://codeberg.org/LinuxUserGD/gdscript-transpiler-bin/issues"
description = "GDScript and Python runtime environment"
proj_license = "MIT"


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
