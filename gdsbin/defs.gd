class_name Defs

## GDScript Transpiler Import Definitions Class
##
## Properties for Transpiler
##

## Add additional python import to transpiled script if required
var py_imp: bool = false
## Print additional parsing information if true
var debug: bool = false
## Print transpiled script as output to console
var verbose: bool = false
## Add additional python code for _init() method to transpiled script if required
var init_def: bool = false
## Add additional python code for Thread class to transpiled script if required
var thread_def: bool = false
## Add additional python code for resize() method to transpiled script if required
var resize_def: bool = false
## Add additional python code for right() method to transpiled script if required
var right_def: bool = false
## Add additional python code for left() method to transpiled script if required
var left_def: bool = false
## Add additional python code for newinstance() method to transpiled script if required
var newinstance_def: bool = false
## Add additional python sys import to transpiled script if required
var sys_imp: bool = false
## Add additional python os import to transpiled script if required
var os_imp: bool = false
## Add additional python nuitka version import to transpiled script if required
var nuitka_imp: bool = false
## Add additional python black import to transpiled script if required
var black_imp: bool = false
## Add additional python math import to transpiled script if required
var math_imp: bool = false
## Add additional python random import to transpiled script if required
var rand_imp: bool = false
## Add additional python datetime import to transpiled script if required
var datetime_imp: bool = false
## Add additional python zig import to transpiled script if required
var zig_imp: bool = false
