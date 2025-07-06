class_name Ast

## GDScript Transpiler Properties Class
##
## Properties for Transpiler
##
## Method to process input string and list of tokens

var key = Key.new()
var keyword = Keyword.new()

func ast(startln: int, endln: int, level: int, root, unit: Array, con: Array):
	for i in range(startln, endln, 1):
		var input = unit[i]
		var conline = con[i]
		if input.size() < level+1:
			continue
		var tabcount: int = 0
		for ii in range(0, input.size(), 1):
			if input[ii].id == key.KEY_TAB:
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
		if input[level].id == key.KEY_NUMBERSIGN:
			_number_sign(root, conline, level)
			continue
		if input[level].id == keyword.KW_NUMBERSIGN2:
			_number_sign(root, conline, level)
			continue
		if input[level].id == keyword.KW_CLASSNAME:
			_classname(root, input, level)
			continue
		if input[level].id == keyword.KW_EXTENDS:
			_extend(root, input, level)
			continue
		if input[level].id == keyword.KW_FUNCTION:
			_function(i, endln, level, root, input, unit, con)
			continue
		if input[level].id == keyword.KW_FOR:
			_for_in(i, endln, level, root, input, unit, con)
			continue
		if input[level].id == keyword.KW_IF:
			_if_cond(i, endln, level, root, input, unit, con)
			continue
		if input[level].id == keyword.KW_VARIABLE:
			const is_const: bool = false
			_variable(root, input, level, is_const)
			continue
		if input[level].id == keyword.KW_CONST:
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
	classn.classn = input[level+1].value
	root.elem.append(classn)
	#print(input)

func _extend(root, input: Array, level: int):
	var extend = Extend.new()
	extend.extend = input[level+1].value
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
		if input[level+1].id == key.KEY_PERIOD:
			callnew.name = input[level].value
			callnew.callnew = _new_call(input, level+2)
		elif input.size() > 2:
			callnew.name = _eval_string(input, 0).string
	else:
		callnew.name = input[level].value
	return callnew

func _new_call(input: Array, level: int):
	var callnew = Callnew.new()
	var s = input.size()
	if level+1 < s:
		if input[level+1].id == key.KEY_PERIOD:
			callnew.name = input[level].value
			callnew.callnew = _new_call(input, level+2)
		elif input[level+1].id == key.KEY_EQUAL:
			callnew.name = input[level].value
			callnew.equ = true
			var array: Array = []
			for i in range(level+2, input.size()):
				array.append(input[i])
			callnew.res = _eval(array)
		elif input[level+1].id in [key.KEY_PLUS, key.KEY_MINUS, key.KEY_ASTERISK, key.KEY_SLASH]:
			callnew.name = input[level].value
			callnew.equ = true
			callnew.op = input[level+1].value
			var array: Array = []
			for i in range(level+2, input.size()):
				array.append(input[i])
			callnew.res = _eval(array)
		elif input[level+1].id == key.KEY_PARENLEFT and key.KEY_PARENRIGHT in _get_ids(input):
			var end = _get_ids(input).find(key.KEY_PARENRIGHT, level+2)
			callnew.name = input[level].value
			callnew.function = true
			callnew.builtin_function = _builtin_function(input[level])
			var args: Array = []
			for i in range(level+2, end):
				args.append(input[i])
			if args.size() != 0:
				callnew.args = _eval_function_args(args)
		elif input.size() > 2:
			callnew.name = _eval_string(input, 0).string
	elif level+1 == s:
		callnew.name = input[level].value
	return callnew

func _get_ids(tokens) -> Array:
	var arr = []
	for i in tokens:
		arr.append(i.id)
	return arr

func _eval_dictionary(_array: Array):
	var dictionaryname = Dictionaryname.new()
	dictionaryname.items = []
	return dictionaryname

func _cut_string(msg: String, level: int):
	var l = msg.length()
	return msg.right(l-level)

func _eval_string(array: Array, level: int):
	var s: String = ""
	for i in range(level, level+3):
		s += array[i].value
	var stringname = Stringname.new()
	stringname.string = s
	return stringname

func _eval_function_args(array: Array):
	var arr: Array = []
	var ast_arr: Array = []
	var token = Token.new()
	token.id = key.KEY_COMMA
	token.value = ","
	array.append(token)
	for i in range(0, array.size()):
		if array[i].id == key.KEY_COMMA:
			ast_arr.append(_arg_call(arr, 0))
			arr = []
		else:
			arr.append(array[i])
	return ast_arr

func _variable(root, input: Array, level: int, is_const: bool):
	var variable = Variable.new()
	variable.variable = input[level+1].value
	variable.is_const = is_const
	if input[level+2].id == key.KEY_COLON:
		variable.st = true
		level += 1
		if input[level+2].id != key.KEY_EQUAL:
			variable.type = input[level+2].value
			level += 1
	if input[level+2].id == key.KEY_EQUAL:
		variable.equ = true
		level += 1
		var array: Array = []
		for i in range(level+2, input.size()):
			array.append(input[i])
		variable.res = _eval(array)
	root.elem.append(variable)
	#print(input)

func _builtin_function(function) -> bool:
	return (function.id == keyword.KW_NEW)

func _eval(array: Array):
	var s: int = array.size()
	var variable
	if array[0].id == key.KEY_BRACELEFT && array[s-1].id == key.KEY_BRACERIGHT:
		variable = _eval_dictionary(array)
		return variable
	if array.size() == 3:
		if array[0].id == key.KEY_QUOTEDBL && array[2].id == key.KEY_QUOTEDBL:
			variable = _eval_string(array, 0)
			return variable
	variable = _new_call(array, 0)
	return variable

func _for_in(startln: int, endln: int, level: int, root, input: Array, unit: Array, con: Array):
	var forloop = Forloop.new()
	var begin: int = -1
	if keyword.KW_IN in _get_ids(input):
		begin = _get_ids(input).find(keyword.KW_IN, level+2)
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
	var ifcond = Ifcond.new()
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
	function.function = input[level+1].value
	var begin: int = -1
	if key.KEY_PARENLEFT in _get_ids(input):
		begin = _get_ids(input).find(key.KEY_PARENLEFT, level+2)
	var end: int = -1
	if key.KEY_PARENRIGHT in _get_ids(input):
		end = _get_ids(input).find(key.KEY_PARENRIGHT, begin+1)
	var arrow1: int = -1
	if key.KEY_MINUS in _get_ids(input):
		arrow1 = _get_ids(input).find(key.KEY_MINUS, end+1)
	var arrow2: int = -1
	if key.KEY_GREATER in _get_ids(input):
		arrow2 = _get_ids(input).find(key.KEY_GREATER, arrow1+1)
	var colon: int = -1
	if key.KEY_COLON in _get_ids(input):
		colon = _get_ids(input).find(key.KEY_COLON, end+1)
	if (arrow1>0 and arrow2>0):
		function.ret = true
		function.res = input[colon-1].value
	var add: bool = true
	while (end-begin > 1):
		if add:
			var stringname = Stringname.new()
			stringname.string = input[begin+1].value
			function.args.append(stringname)
			add = false
		if input[begin+1].id == key.KEY_COMMA:
			add = true
		begin += 1
	function.root = ast(startln+1, endln, level+1, function.root, unit, con)
	root.elem.append(function)
	#print(input)
