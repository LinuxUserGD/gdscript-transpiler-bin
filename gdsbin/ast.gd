class_name Ast

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
## Method to process input string and list of tokens

func ast(startln: int, endln: int, level: int, root, unit: Array, con: Array):
	for i in range(startln, endln, 1):
		var input = unit[i]
		var conline = con[i]
		if input.size() < level+1:
			continue
		var tabcount: int = 0
		for ii in range(0, input.size(), 1):
			if input[ii] == "TAB":
				tabcount += 1
			else:
				break
		if tabcount > level:
			continue
		elif tabcount < level:
			break
		if root == null:
			root = Root.new()
			root.elem = []
		if input[level] == "NUMBER SIGN":
			_number_sign(root, conline, level)
			continue
		if input[level] == "NUMBER SIGN 2":
			_number_sign(root, conline, level)
			continue
		if input[level] == "CLASS NAME":
			_classname(root, input, level)
			continue
		if input[level] == "EXTENDS":
			_extend(root, input, level)
			continue
		if input[level] == "FUNCTION":
			_function(i, endln, level, root, input, unit, con)
			continue
		if input[level] == "FOR":
			_for_in(i, endln, level, root, input, unit, con)
			continue
		if input[level] == "IF":
			_if_cond(i, endln, level, root, input, unit, con)
			continue
		if input[level] == "VARIABLE":
			const is_const: bool = false
			_variable(root, input, level, is_const)
			continue
		if input[level] == "CONST":
			const is_const: bool = true
			_variable(root, input, level, is_const)
			continue
		_call(root, input, level)
	return root

func _number_sign(root, conline: String, level: int):
	var comment = Comment.new()
	comment.comment = _cut_string(conline, level)
	root.elem.append(comment)
	#print(input)

func _number_sign_2(root, conline: String, level: int):
	var comment = Comment.new()
	comment.comment = _cut_string(conline, level)
	root.elem.append(comment)
	#print(input)

func _classname(root, input: Array, level: int):
	var classn = Classn.new()
	classn.classn = input[level+1]
	root.elem.append(classn)
	#print(input)

func _extend(root, input: Array, level: int):
	var extend = Extend.new()
	extend.extend = input[level+1]
	root.elem.append(extend)
	#print(input)

func _call(root, input: Array, level: int):
	var callx = _new_call(input, level)
	root.elem.append(callx)
	#print(input)

func _arg_call(input: Array, level: int):
	var callnew = Callnew.new()
	var s = input.size()
	if level+1 < s:
		if input[level+1] == "DOT":
			callnew.name = input[level]
			callnew.callnew = _new_call(input, level+2)
		else:
			callnew.name = _eval_string(input, 0).string
	else:
		callnew.name = input[level]
	return callnew

func _new_call(input: Array, level: int):
	var callnew = Callnew.new()
	var s = input.size()
	if level+1 < s:
		if input[level+1] == "DOT":
			callnew.name = input[level]
			callnew.callnew = _new_call(input, level+2)
		elif input[level+1] == "EQUALS SIGN":
			callnew.name = input[level]
			callnew.equ = true
			var array: Array = []
			for i in range(level+2, input.size()):
				array.append(input[i])
			callnew.res = _eval(array)
		elif input[level+1] in ["PLUS", "MINUS", "ASTERISK", "SLASH"]:
			callnew.name = input[level]
			callnew.equ = true
			callnew.op = input[level+1]
			var array: Array = []
			for i in range(level+3, input.size()):
				array.append(input[i])
			callnew.res = _eval(array)
		elif input[level+1] == "LEFT BRACKET" and "RIGHT BRACKET" in input:
			var end = input.find("RIGHT BRACKET", level+2)
			callnew.name = input[level]
			callnew.function = true
			callnew.builtin_function = _builtin_function(input[level])
			var args: Array = []
			for i in range(level+2, end):
				args.append(input[i])
			if args.size() != 0:
				callnew.args = _eval_function_args(args)
		else:
			callnew.name = _eval_string(input, 0).string
	elif level+1 == s:
		callnew.name = input[level]
	return callnew

func _eval_dictionary(_array: Array):
	var dictionary = DICTIONARY.new()
	dictionary.items = []
	return dictionary

func _cut_string(msg: String, level: int):
	var l = msg.length()
	return msg.right(l-level)

func _eval_string(array: Array, level: int):
	var s: String = ""
	const qu: String = '"'
	const token : Dictionary = {
		"NUMBER SIGN": "#",
		"EXCLAMATION MARK": "!",
		"SLASH": "/",
		"BACKSLASH": "\\",
		"CLASS NAME": "class_name",
		"EXTENDS": "extends",
		"NUMBER SIGN 2": "##",
		"FUNCTION": "func",
		"LEFT BRACKET": "(",
		"RIGHT BRACKET": ")",
		"MINUS": "-",
		"PLUS": "+",
		"GREATER THAN": ">",
		"LESS THAN": "<",
		"COLON": ":",
		"EQUALS SIGN": "=",
		"CURLY LEFT BRACKET": "{",
		"CURLY RIGHT BRACKET": "}",
		"TAB": "\t",
		"DOT": ".",
		"NEW": "new",
		"VARIABLE": "var",
		"CONST": "const",
		"QUOTATION": qu
	}
	for i in range(level, array.size()):
		s += token[array[i]] if array[i] in token else array[i]
	var string = STRING.new()
	string.string = s
	return string

func _eval_function_args(array: Array):
	var arr: Array = []
	var ast_arr: Array = []
	array.append("COMMA")
	for i in range(0, array.size()):
		if array[i] == "COMMA":
			ast_arr.append(_arg_call(arr, 0))
			arr = []
		else:
			arr.append(array[i])
	return ast_arr

func _variable(root, input: Array, level: int, is_const: bool):
	var variable = VARIABLE.new()
	variable.variable = input[level+1]
	variable.is_const = is_const
	if input[level+2]=="COLON":
		variable.st = true
		level += 1
		if input[level+2]!="EQUALS SIGN":
			variable.type = input[level+2]
			level += 1
	if input[level+2]=="EQUALS SIGN":
		variable.equ = true
		level += 1
		var array: Array = []
		for i in range(level+2, input.size()):
			array.append(input[i])
		variable.res = _eval(array)
	root.elem.append(variable)
	#print(input)

func _builtin_function(function: String) -> bool:
	return (function == "NEW")

func _eval(array: Array):
	var s: int = array.size()
	var variable
	if array[0] == "CURLY LEFT BRACKET" && array[s-1] == "CURLY RIGHT BRACKET":
		variable = _eval_dictionary(array)
		return variable
	if array[0] == "QUOTATION" && array[s-1] == "QUOTATION":
		variable = _eval_string(array, 0)
		return variable
	variable = _new_call(array, 0)
	return variable

func _for_in(startln: int, endln: int, level: int, root, input: Array, unit: Array, con: Array):
	var forloop = FORLOOP.new()
	var begin: int = -1
	if "IN" in input:
		begin = input.find("IN", level+2)
	var end: int = input.size()
	var f: Array = []
	for i in range(level+1, begin):
		f.append(input[i])
	var x: Array = []
	for i in range(begin+1, end-1):
		x.append(input[i])
	forloop.f = _new_call(f, 0)
	forloop.i = _new_call(x, 0)
	forloop.root = ast(startln+1, endln, level+1, forloop.root, unit, con)
	root.elem.append(forloop)

func _if_cond(startln: int, endln: int, level: int, root, input: Array, unit: Array, con: Array):
	var ifcond = IFCOND.new()
	var end: int = input.size()
	var i: Array = []
	for x in range(level+1, end-1):
		i.append(input[x])
	ifcond.i = _new_call(i, 0)
	ifcond.root = ast(startln+1, endln, level+1, ifcond.root, unit, con)
	root.elem.append(ifcond)

func _function(startln: int, endln: int, level: int, root, input: Array, unit: Array, con: Array):
	var function = Function.new()
	function.args = []
	function.function = input[level+1]
	var begin: int = -1
	if "LEFT BRACKET" in input:
		begin = input.find("LEFT BRACKET", level+2)
	var end: int = -1
	if "RIGHT BRACKET" in input:
		end = input.find("RIGHT BRACKET", begin+1)
	var arrow1: int = -1
	if "MINUS" in input:
		arrow1 = input.find("MINUS", end+1)
	var arrow2: int = -1
	if "GREATER THAN" in input:
		arrow2 = input.find("GREATER THAN", arrow1+1)
	var colon: int = -1
	if "COLON" in input:
		colon = input.find("COLON", end+1)
	if (arrow1>0 and arrow2>0):
		function.ret = true
		function.res = input[colon-1]
	var add: bool = true
	while (end-begin > 1):
		if add:
			var string = STRING.new()
			string.string = input[begin+1]
			function.args.append(string)
			add = false
		if input[begin+1] == "COMMA":
			add = true
		begin += 1
	function.root = ast(startln+1, endln, level+1, function.root, unit, con)
	root.elem.append(function)
	#print(input)
