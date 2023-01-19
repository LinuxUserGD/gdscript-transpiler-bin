class_name Operator
extends Token

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-tokenizer-py

func _init(value: String):
	super(value, true)

func _to_string():
	return "OperatorToken{%s}" % [_token]
