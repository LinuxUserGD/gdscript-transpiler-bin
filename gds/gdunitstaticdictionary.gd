class_name GdUnitStaticDictionary
extends RefCounted

## Implements a Dictionary with static accessors
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-tokenizer-py

var __store := [{}]

func add_value(key : Variant, value : Variant, overwrite := false) -> Variant:
	if overwrite and __store[0].has(key):
		push_error("An value already exists with key: %s" % key)
		return null
	__store[0][key] = value
	return value

func erase(key: Variant) -> bool:
	if __store[0].has(key):
		__store[0].erase(key)
		return true
	return false

func clear() -> void:
	__store[0].clear()

func find_key(value: Variant) -> Variant:
	return __store[0].find_key(value)

func get_value(key: Variant, default: Variant = null) -> Variant:
	return __store[0][key]

func has_key(key: Variant) -> bool:
	return __store[0].has(key)

func has_keys(keys: Array)  -> bool:
	return __store[0].has_all(keys)

func hash() -> int:
	return __store[0].hash()

func is_empty() -> bool:
	prints(__store)
	return __store[0].is_empty()
	
func keys() -> Array:
	return __store[0].keys()
	
func size() -> int:
	return __store[0].size()
	
func values() -> Array:
	return __store[0].values()

func _to_string() -> String:
	return str(__store[0].keys())
