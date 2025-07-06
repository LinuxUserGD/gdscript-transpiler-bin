class_name Parsertree

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##

## Method to process input string and list of tokens

func printtree(element, level: int) -> Dictionary:
	match element.get_script().get_global_name():
		"Root":
			var dictionary: Dictionary = {}
			if element.elem.size() > 0:
				for i in range (0, element.elem.size()):
					dictionary["Root" + str(i)] = printtree(element.elem[i], level)
			return dictionary
		"Comment":
			return {"Comment": {element.comment: null}}
		"Classn":
			return {"class_name": {element.classn: null}}
		"Extend":
			return {"extends": {element.extend: null}}
		"Function":
			return {"Function": null}
		"Variable":
			return {"Variable": {element.variable: null}}
		"Forloop":
			return {"Forloop": null}
		"Ifcond":
			return {"Ifconf": null}
		"Callnew":
			return {"Callnew": null}
	return {"": null}

func printpt(element, level: int) -> String:
	match element.get_script().get_global_name():
		"Root":
			var out: String = ""
			if element.elem.size() > 0:
				for e in element.elem:
					for i in range(level):
						out += "	"
					out += printpt(e, level)
			return out
		"Comment":
			return element.comment + "\n"
		"Classn":
			return "class_name " + element.classn + "\n"
		"Extend":
			return "extends " + element.extend + "\n"
		"Function":
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
		"Variable":
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
		"Forloop":
			var out = "for"
			out += " " + parse_call(element.f)
			out += " " + "in"
			out += " " + parse_call(element.i)
			out += ":"
			out += "\n"
			if (element.root != null):
				out += printpt(element.root, level+1)
			return out
		"Ifcond":
			var out = "i"
			out += "f"
			out += " " + parse_call(element.i)
			out += ":"
			out += "\n"
			if (element.root != null):
				out += printpt(element.root, level+1)
			return out
		"Callnew":
			return parse_call(element) + "\n"
	return ""

func eval_call(element):
	var out: String = ""
	if element != null:
		if element.get_script().get_global_name() == "Stringname":
			out += element.string
		elif element.get_script().get_global_name() == "Dictionaryname":
			out += "{}"
		elif element.get_script().get_global_name() == "Callnew":
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

func printrec(e: Dictionary, ch: String) -> String:
	var s: String = ""
	var k: Array = e.keys()
	var i: int = k.size() - 1
	for item in k:
		s += ch
		s += ("├─" if i != 0 else "└─" if ch != "" else "──")
		s += ("┐ " if e[item] != null else "  ")
		s += item
		s += "\n"
		if e[item] != null:
			s += printrec(e[item], ch + ("│ " if i != 0 else "  "))
		i -= 1
	return s
