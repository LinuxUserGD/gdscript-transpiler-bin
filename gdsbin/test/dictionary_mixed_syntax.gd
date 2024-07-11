class_name Dictionary_mixed_syntax

func test():
	# Mixing Python-style and Lua-style syntax in the same dictionary declaration
	# is allowed.
	var dict = {
		"hello": {
			world = {
				"is": "beautiful",
			},
		},
	}

	print(dict)
