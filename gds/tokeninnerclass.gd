class_name TokenInnerClass
extends Token

## Token to parse function arguments
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-tokenizer-py

var _clazz_name
var _content: PackedStringArray

static func _strip_leading_spaces(input :String) -> String:
	var characters := input.to_ascii_buffer()
	while not characters.is_empty():
		if characters[0] != 0x20:
			break
		characters.remove_at(0)
	return characters.get_string_from_ascii()

static func _consumed_bytes(row :String) -> int:
	return row.replace(" ", "").replace("	", "").length()

func _init(clazz_name :String):
	super("class")
	_clazz_name = clazz_name

func is_class_name(clazz_name :String) -> bool:
	return _clazz_name == clazz_name

func content() -> PackedStringArray:
	return _content

func parse(source_rows: PackedStringArray, offset: int) -> void:
	# add class signature
	_content.append(source_rows[offset])
	# parse class content
	for row_index in range(offset+1, source_rows.size()):
		# scan until next non tab
		var source_row := source_rows[row_index]
		var row = _strip_leading_spaces(source_row)
		if row.is_empty() or row.begins_with("\t") or row.begins_with("#"):
			# fold all line to left by removing leading tabs and spaces
			if source_row.begins_with("\t"):
				source_row = source_row.trim_prefix("\t")
			# reformat invalid empty lines
			if source_row.dedent().is_empty():
				_content.append("")
			else:
				_content.append(source_row)
			continue
		break
	_consumed += _consumed_bytes("".join(_content))

func _to_string():
	return "TokenInnerClass{%s}" % [_clazz_name]




