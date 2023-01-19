# Copyright © 2019-2022 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.
extends Control

@onready var engine_version_label := $EngineVersion as Label


func _ready() -> void:
	var version: Dictionary = Engine.get_version_info()
	# Mimic the official version numbering.
	if version.patch >= 1:
		engine_version_label.text = "Godot %s.%s.%s.%s" % [version.major, version.minor, version.patch, version.status]
	else:
		engine_version_label.text = "Godot %s.%s.%s" % [version.major, version.minor, version.status]
