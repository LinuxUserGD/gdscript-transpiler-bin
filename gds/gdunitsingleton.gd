class_name GdUnitSingleton
extends GdUnitStaticDictionary

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-tokenizer-py

################################################################################
# Provides access to a global accessible singleton 
# 
# This is a workarount to the existing auto load singleton because of some bugs 
# around plugin handling 
################################################################################

func get_singleton(name: String) -> Object:
	var singleton = get_value(name)
	if singleton == null:
		push_error("No singleton instance with '" + name + "' found.")
	return singleton

func add_singleton(name: String, path: String) -> Object:
	var singleton :Object = load(path).new()
	if singleton.has_method("set_name"):
		singleton.set_name(name)
	add_value(name, singleton)
	#print_debug("Added singleton ", name, " ",singleton)
	return singleton

func get_or_create_singleton(name: String, path: String) -> Object:
	if has_key(name):
		return get_value(name)
	return add_singleton(name, path)

func remove_singleton(name: String) -> void:
	if !erase(name):
		push_error("Remove singleton '" + name + "' failed. No global instance found.")
