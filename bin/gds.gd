#!/usr/bin/godot -s
class_name GDScriptTranspiler
extends SceneTree

## GDScript Wrapper
##
## Wrapper script for __main__.gd


## Run main application
func _init() -> void:
	var gdspy: Dictionary = {}
	gdspy.__main__ = __Main__.new()
	gdspy.__main__._ready()
	quit()
