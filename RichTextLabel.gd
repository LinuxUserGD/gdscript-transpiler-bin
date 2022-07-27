extends HBoxContainer

const Main := preload("res://main.gd")
var main = Main.new()
var _main = main.Main.new()

func _on_text_edit_text_changed():
	$TextEdit2.set_text(_main.transpile($TextEdit.get_text()))
