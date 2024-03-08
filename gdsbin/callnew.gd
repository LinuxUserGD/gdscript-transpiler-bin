class_name Callnew
## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##

## Method to process input string and list of tokens

var equ: bool = false
var res
var name: String = ""
var function: bool = false
var args: Array = []
var builtin_function: bool = false
var callnew: Callnew

func t() -> String:
	return "call"
