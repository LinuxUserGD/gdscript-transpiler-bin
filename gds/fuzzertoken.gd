class_name FuzzerToken
extends Token

## Token to parse Fuzzers
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-tokenizer-py

var _name: String

func _init(regex: RegEx):
	super("", false, regex)

func match(input: String, pos: int) -> bool:
	if _regex:
		var result := _regex.search(input, pos)
		if result == null:
			return false
		_name = result.strings[1]
		_consumed = result.get_end() - result.get_start()
		return pos == result.get_start()
	return input.findn(_token, pos) == pos

func name() -> String:
	return _name

func type() -> int:
	return GdObjects.TYPE_FUZZER

func _to_string():
	return "FuzzerToken{%s: '%s'}" % [_name, _token]
