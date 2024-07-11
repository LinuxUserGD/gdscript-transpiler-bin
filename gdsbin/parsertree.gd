class_name Parsertree

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##

## Method to process input string and list of tokens

func printpt(element, level: int) -> String:
	match element.t():
		"root":
			var out: String = ""
			if element.elem.size() > 0:
				for e in element.elem:
					for i in range(level):
						out += "	"
					out += printpt(e, level)
			return out
		"comment":
			return element.comment + "\n"
		"classname":
			return "class_name " + element.classn + "\n"
		"extends":
			return "extends " + element.extend + "\n"
		"function":
			var out: String = ""
			out += "func " + element.function + "("
			var s = element.args.size()
			if s!=0:
				for i in range(0, s-1, 1):
					out += eval_call(element.args[i]) + ", "
				out += eval_call(element.args[s-1])
			out += ")"
			if element.ret:
				out += " -> "
				out += element.res
			out += ":"
			out += "\n"
			if (element.root != null):
				out += printpt(element.root, level+1)
			return out
		"variable":
			var out = "var"
			if element.is_const:
				out = "const"
			out += " " + element.variable
			if element.st:
				out += ": "
			if element.type != "":
				out += element.type
			if element.equ:
				out += " = "
				out += eval_call(element.res)
			return out + "\n"
		"forloop":
			var out = "for"
			out += " " + parse_call(element.f)
			out += " " + "in"
			out += " " + parse_call(element.i)
			out += ":"
			out += "\n"
			if (element.root != null):
				out += printpt(element.root, level+1)
			return out
		"cond":
			var out = "i"
			out += "f"
			out += " " + parse_call(element.i)
			out += ":"
			out += "\n"
			if (element.root != null):
				out += printpt(element.root, level+1)
			return out
		"call":
			return parse_call(element) + "\n"
	return ""

func eval_call(element):
	var out: String = ""
	if element != null:
		if element.t() == "string":
			out += element.string
		elif element.t() == "dictionary":
			out += "{}"
		elif element.t() == "call":
			if element.builtin_function:
				out += element.name.to_lower()
			else:
				out += element.name
			if element.function:
				out += "("
				var s = element.args.size()
				if s!=0:
					for i in range(0, s-1, 1):
						out += eval_call(element.args[i]) + ", "
					out += eval_call(element.args[s-1])
				out += ")"
			while (element.callnew != null):
				element = element.callnew
				out += "."
				if element.builtin_function:
					out += element.name.to_lower()
				else:
					out += element.name
				if element.function:
					out += "("
					var s = element.args.size()
					if s!=0:
						for i in range(0, s-1, 1):
							out += eval_call(element.args[i])
							out += ", "
						out += eval_call(element.args[s-1])
					out += ")"
		else:
			out += str(element).replace(" ", "")
	return out

func parse_call(element):
	var out = ""
	if element.builtin_function:
		out += element.name.to_lower()
	else:
		out += element.name
	if element.function:
		out += "("
		var s = element.args.size()
		if s!=0:
			for i in range(0, s-1, 1):
				out += eval_call(element.args[i]) + ", "
			out += eval_call(element.args[s-1])
		out += ")"
	while (element.callnew != null):
		element = element.callnew
		out += "."
		if element.builtin_function:
			out += element.name.to_lower()
		else:
			out += element.name
		if element.function:
			out += "("
			var s = element.args.size()
			if s!=0:
				for i in range(0, s-1, 1):
					out += eval_call(element.args[i])
					out += ", "
				out += eval_call(element.args[s-1])
			out += ")"
	if element.equ:
		if element.op == "":
			out += " = "
		elif element.op == "PLUS":
			out += " += "
		elif element.op == "MINUS":
			out += " -= "
		elif element.op == "ASTERISK":
			out += " *= "
		elif element.op == "SLASH":
			out += " /= "
		out += eval_call(element.res)
	return out
