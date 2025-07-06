class_name Tokenizer

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
var key = Key.new()
var keyword = Keyword.new()

## Method to process input string and list of tokens
func tokenize(input_string: String) -> Array:
	var delimiter : Array = ['(', ')', ':', ',', '.', '=', '+', '-', '*', '/', '<', '>', '!', '&', '|', '~', '%', ' ', '[', ']', '{', '}', '"', '\t']
	const qu: String = '"'
	var token : Dictionary = {
		"#": key.KEY_NUMBERSIGN,
		"!": key.KEY_EXCLAM,
		"/": key.KEY_SLASH,
		"\\": key.KEY_BACKSLASH,
		"(": key.KEY_PARENLEFT,
		")": key.KEY_PARENRIGHT,
		"-": key.KEY_MINUS,
		"+": key.KEY_PLUS,
		"*": key.KEY_ASTERISK,
		">": key.KEY_GREATER,
		"<": key.KEY_LESS,
		":": key.KEY_COLON,
		"=": key.KEY_EQUAL,
		"{": key.KEY_BRACELEFT,
		"}": key.KEY_BRACERIGHT,
		"\t": key.KEY_TAB,
		".": key.KEY_PERIOD,
		",": key.KEY_COMMA,
		"class_name": keyword.KW_CLASSNAME,
		"extends": keyword.KW_EXTENDS,
		"##": keyword.KW_NUMBERSIGN2,
		"func": keyword.KW_FUNCTION,
		"new": keyword.KW_NEW,
		"var": keyword.KW_VARIABLE,
		"const": keyword.KW_CONST,
		"for": keyword.KW_FOR,
		"in": keyword.KW_IN,
		"if": keyword.KW_IF,
		qu: key.KEY_QUOTEDBL
	}
	var tokens: Array = []
	var buffer: String = ""
	var str: bool = false
	for ch in input_string:
		if ch in delimiter:
			if ch == '"':
				str = false if str else true
			elif str:
				buffer += ch
				continue
			if buffer != "":
				tokens.append(char_to_token(buffer, token))
				buffer = ""
			if ch != " ":
				tokens.append(char_to_token(ch, token))
		else:
			buffer += ch
	if buffer != "":
		tokens.append(char_to_token(buffer, token))
	return tokens

## Convert each character to token
func char_to_token(buffer: String, token_index: Dictionary):
	var token = Token.new()
	token.id = token_index[buffer] if buffer in token_index else keyword.KW_NONE
	token.value = buffer
	return token
