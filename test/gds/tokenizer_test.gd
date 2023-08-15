# GdUnit generated TestSuite
class_name TokenizerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://gds/tokenizer.gd'

func test_tokenize() -> void:
	var input: String = "func _init() -> void:"
	var tokenizer = Tokenizer.new()
	assert_str(str(tokenizer.tokenize(input))).is_equal('["FUNCTION", "_init", "LEFT BRACKET", "RIGHT BRACKET", "MINUS", "GREATER THAN", "void", "COLON"]')
