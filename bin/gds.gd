#!/usr/bin/godot -s
class_name GDScriptTranspiler
extends SceneTree

## GDScript Wrapper
##
## Wrapper script for __main__.gd


## Run main application
func _init() -> void:
	var gdsbin: Dictionary = {}
	gdsbin.__main__ = __Main__.new()
	gdsbin.__main__._ready()
	quit()
