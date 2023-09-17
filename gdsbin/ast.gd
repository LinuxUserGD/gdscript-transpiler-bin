class_name Ast

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
## @tutorial(Generated python script): https://gist.github.com/LinuxUserGD/73d8e030a44eb7f91bdeaea96a321f6d#file-tokenizer-py
## Method to process input string and list of tokens
var parsertree = Parsertree.new()
var tokenizer = Tokenizer.new()

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
			_classname(root, input)
		elif input[level] == "EXTENDS":
			_extend(root, input)
		elif input[level] == "FUNCTION":
			_function(i, endln, level, root, input, unit, con)
		elif input[level] == "VARIABLE":
			_variable(root, input, level)
		else:
			pass
			#print(input)
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

func _classname(root, input: Array):
	var classn = Classn.new()
	classn.classn = input[1]
	root.elem.append(classn)
	#print(input)

func _extend(root, input: Array):
	var extend = Extend.new()
	extend.extend = input[1]
	root.elem.append(extend)
	#print(input)

func _variable(root, input: Array, level: int):
	var vari = Vari.new()
	vari.vari = input[level+1]
	root.elem.append(vari)
	#print(input)
	

func _function(startln: int, endln: int, level: int, root, input: Array, unit: Array, con: Array):
	var function = Function.new()
	function.function = input[1]
	var begin = input.find("LEFT BRACKET", 2)
	var end = input.find("RIGHT BRACKET", 3)
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
