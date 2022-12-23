class_name Tokenizer

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-tokenizer-py


## Method to process input string and return list of tokens
func tokenize(input_string: String):
	var delimiter : Array = ["(", ")", ":", ",", ".", "=", "+", "-", "*", "/", "<", ">", "!", "&", "|", "~", "%", " ", "[", "]", "{", "}", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", '"']
	# Initialize list of tokens
	var tokens: Array = []
	# Initialize temporary string buffer
	var buffer: String = ""
	# Iterate over input string one character at a time
	for ch in input_string:
		# Check if character is a delimiter
		if ch in delimiter:
			# If so, add preceding characters to list of tokens
			if buffer != "":
				tokens.append(buffer)
				buffer = ""
			if ch != " ":
				tokens.append(ch)
			#if ch != " ":
			#	buffer += ch
		else:
			# Otherwise, add character to buffer
			buffer += ch
	# Add any remaining characters in buffer to list of tokens
	if buffer != "":
		tokens.append(buffer)
	
	# Return list of tokens
	return tokens


func _init():
	pass
