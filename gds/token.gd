class_name Token
extends RefCounted

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-tokenizer-py

var _token: String
var _consumed: int
var _is_operator: bool
var _regex: RegEx

func _init(token: String, is_operator := false, regex :RegEx = null):
	_token = token
	_is_operator = is_operator
	_consumed = token.length()
	_regex = regex

func match(input: String, pos: int) -> bool:
	if _regex:
		var result := _regex.search(input, pos)
		if result == null:
			return false
		_consumed = result.get_end() - result.get_start()
		return pos == result.get_start()
	return input.findn(_token, pos) == pos

func is_operator() -> bool:
	return _is_operator

func is_inner_class() -> bool:
	return _token == "class"
	
func is_variable() -> bool:
	return false

func is_token(token_name: String) -> bool:
	return _token == token_name

func _to_string():
	return "Token{" + _token + "}"
