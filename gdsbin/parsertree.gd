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
					out += element.args[i] + ", "
				out += element.args[s-1]
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
			var out = "var " + element.variable
			if element.st:
				out += ": "
			if element.type != "":
				out += element.type
			if element.equ:
				out += " = "
				if element.res != null:
					out += str(element.res).replace(" ", "")
			return out + "\n"
		"call":
			var out = ""
			if element.builtin_function:
				out += element.name.to_lower()
			else:
				out += element.name
			if element.function:
				out += "()"
			while (element.callnew != null):
				element = element.callnew
				out += "."
				if element.builtin_function:
					out += element.name.to_lower()
				else:
					out += element.name
				if element.function:
					out += "()"
			if element.equ:
				out += " = "
				if element.res != null:
					if element.res.t() == "call":
						if element.res.builtin_function:
							out += element.res.name.to_lower()
						else:
							out += element.res.name
						if element.res.function:
							out += "()"
						while (element.res.callnew != null):
							element.res = element.res.callnew
							out += "."
							if element.res.builtin_function:
								out += element.res.name.to_lower()
							else:
								out += element.res.name
							if element.res.function:
								out += "()"
					else:
						out += str(element.res).replace(" ", "")
			return out + "\n"
	return ""
