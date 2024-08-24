#!/usr/bin/env python
import os
import sys

class_name = "GDScriptTranspiler"


def _init():
    gdsbin = {}
    sys.path.insert(0, os.path.normpath(os.path.join(os.path.dirname(__file__), "..")))
    import gdsbin.__main__

    gdsbin.__main__._init()
    sys.exit()


if __name__ == "__main__":
    _init()


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
