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
			_number_sign(root, conline)
		elif input[level] == "NUMBER SIGN 2":
			_number_sign(root, conline)
		elif input[level] == "CLASS NAME":
			_classname(root, input, level)
		elif input[level] == "EXTENDS":
			_extend(root, input, level)
		elif input[level] == "FUNCTION":
			_function(i, endln, level, root, input, unit, con)
		elif input[level] == "VARIABLE":
			_variable(root, input, level)
		else:
			_call(root, input, level)
	return root

func _number_sign(root, conline: String):
	var comment = Comment.new()
	comment.comment = conline
	root.elem.append(comment)
	#print(input)

func _number_sign_2(root, conline: String):
	var comment = Comment.new()
	comment.comment = conline
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

func _new_call(input: Array, level: int):
	var callnew = Callnew.new()
	var s = input.size()
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
	elif input[level+1] == "LEFT BRACKET" && input[s-1] == "RIGHT BRACKET":
		callnew.name = input[level]
		callnew.function = true
		callnew.builtin_function = _builtin_function(input[level])
	else:
		callnew.name = input[level]
	return callnew

func _variable(root, input: Array, level: int):
	var variable = Variable.new()
	variable.variable = input[level+1]
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
	if function == "NEW":
		return true
	return false

func _eval(array: Array):
	var s: int = array.size()
	var variable = null
	if array[0] == "CURLY LEFT BRACKET" && array[s-1] == "CURLY RIGHT BRACKET":
		variable = {}
		return variable
	variable = _new_call(array, 0)
	return variable

func _function(startln: int, endln: int, level: int, root, input: Array, unit: Array, con: Array):
	var function = Function.new()
	function.args = []
	function.function = input[level+1]
	var begin = input.find("LEFT BRACKET", level+2)
	var end = input.find("RIGHT BRACKET", level+3)
	var arrow1 = input.find("MINUS", level+4)
	var arrow2 = input.find("GREATER THAN", level+5)
	var colon = input.find("COLON", level+4)
	if (arrow1>0 and arrow2>0):
		function.ret = true
		function.res = input[colon-1]
	var add: bool = true
	while (end-begin > 1):
		if add:
			function.args.append(input[begin+1])
			add = false
		if input[begin+1] == ",":
			add = true
		begin += 1
	function.root = ast(startln+1, endln, level+1, function.root, unit, con)
	root.elem.append(function)
	#print(input)
