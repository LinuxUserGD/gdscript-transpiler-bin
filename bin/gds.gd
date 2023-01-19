#!/usr/bin/godot -s
class_name GDScriptTranspiler
extends SceneTree

## GDScript Wrapper
##
## Wrapper script for __main__.gd
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-__main__-py


## Run main application
func _init() -> void:
	var gds: Dictionary = {}
	gds.__main__ = __Main__.new()
	gds.__main__._ready()
	quit()
