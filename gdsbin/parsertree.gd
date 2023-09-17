class_name Parsertree

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-tokenizer-py

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
			out += "):"
			out += "\n"
			if (element.root != null):
				out += printpt(element.root, level+1)
			return out
		"variable":
			return "var " + element.vari + "\n"
	return ""
