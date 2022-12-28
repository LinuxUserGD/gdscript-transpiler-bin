#!/usr/bin/godot -s
extends SceneTree
class_name GDS

## GDScript Wrapper
##
## Wrapper script for __main__.gd
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-__main__-py


## Run main application
func _init() -> void:
	var gds: Dictionary = {"__main__" : ""}
	gds.__main__ = __Main__.new()
	self.quit()
	return
