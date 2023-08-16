class_name Tokenizer

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-tokenizer-py

## Method to process input string and list of tokens
func tokenize(input_string: String):
	var delimiter : Array = ['(', ')', ':', ',', '.', '=', '+', '-', '*', '/', '<', '>', '!', '&', '|', '~', '%', ' ', '[', ']', '{', '}', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '"', '\t']
	var token : Dictionary = {
		"#": "NUMBER SIGN",
		"!": "EXCLAMATION MARK",
		"/": "SLASH",
		"\\": "BACKSLASH",
		"class_name": "CLASS NAME",
		"extends": "EXTENDS",
		"##": "NUMBER SIGN 2",
		"func": "FUNCTION",
		"(": "LEFT BRACKET",
		")": "RIGHT BRACKET",
		"-": "MINUS",
		"+": "PLUS",
		">": "GREATER THAN",
		"<": "LESS THAN",
		":": "COLON",
		"=": "EQUALS SIGN",
		"{": "CURLY LEFT BRACKET",
		"}": "CURLY RIGHT BRACKET",
		"\t": "TAB",
		".": "DOT",
		"new": "NEW",
		"var": "VARIABLE",
	}
	var tokens: Array = []
	var buffer: String = ""
	for ch in input_string:
		if ch in delimiter:
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
func char_to_token(buffer: String, token: Dictionary) -> String:
	return token[buffer] if buffer in token else buffer
