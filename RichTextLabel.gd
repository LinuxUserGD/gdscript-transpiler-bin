extends HBoxContainer

func _on_text_edit_text_changed():
	$TextEdit2.set_text($"/root/Node".transpile($TextEdit.get_text()))
