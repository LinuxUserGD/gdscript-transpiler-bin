extends HBoxContainer

const Main := preload("res://main.gd")
var main = Main.new()
var _main = main.Main.new()
var _self : String = ""

func _on_text_edit_text_changed():
	$TextEdit2.set_text(_main.transpile(_self, $TextEdit.get_text()))
