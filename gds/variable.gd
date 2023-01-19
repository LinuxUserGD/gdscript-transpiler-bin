class_name Variable
extends Token

## Token to parse function arguments
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-tokenizer-py

var _plain_value
var _typed_value
var _type := TYPE_NIL

func _init(value: String):
	super(value)
	_type = _scan_type(value)
	_plain_value = value
	_typed_value = _cast_to_type(value, _type)

func _scan_type(value: String) -> int:
	if value.begins_with("\"") and value.ends_with("\""):
		return TYPE_STRING
	var type: Variant = GdObjects.string_to_type(value)
	if type != TYPE_NIL:
		return type
	if value.is_valid_int():
		return TYPE_INT
	if value.is_valid_float():
		return TYPE_FLOAT
	if value.is_valid_hex_number():
		return TYPE_INT
	return TYPE_OBJECT

func _cast_to_type(value :String, type: int) -> Variant:
	match type:
		TYPE_STRING:
			return value#.substr(1, value.length() - 2)
		TYPE_INT:
			return value.to_int()
		TYPE_FLOAT:
			return value.to_float()
	return value

func is_variable() -> bool:
	return true

func type() -> int:
	return _type

func value():
	return _typed_value

func plain_value():
	return _plain_value

func _to_string():
	return "Variable{%s: %s : '%s'}" % [_plain_value, GdObjects.type_as_string(_type), _token]
