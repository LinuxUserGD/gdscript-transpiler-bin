class_name Lexer
extends RefCounted

## Indentation-aware tokenizer. Emits INDENT/DEDENT, and suppresses them
## inside brackets the way GDScript does.

const _T := {
	"NEWLINE": 0,
	"INDENT": 1,
	"DEDENT": 2,
	"EOF": 3,
	"IDENT": 4,
	"KEYWORD": 5,
	"NUMBER": 6,
	"STRING": 7,
	"FSTRING": 8,
	"ANNOTATION": 9,
	"NODEPATH": 10,
	"COMMENT": 11,
	"OP": 12
}

const isTrue: bool = true

const KEYWORDS := {
	"if": isTrue, "elif": isTrue, "else": isTrue, "for": isTrue, "while": isTrue, "match": isTrue,
	"when": isTrue, "break": isTrue, "continue": isTrue, "pass": isTrue, "return": isTrue,
	"class": isTrue, "class_name": isTrue, "extends": isTrue, "is": isTrue, "in": isTrue,
	"as": isTrue, "self": isTrue, "super": isTrue, "signal": isTrue, "func": isTrue,
	"static": isTrue, "const": isTrue, "enum": isTrue, "var": isTrue, "breakpoint": isTrue,
	"preload": isTrue, "await": isTrue, "assert": isTrue, "void": isTrue, "abstract": isTrue,
	"and": isTrue, "or": isTrue, "not": isTrue, "isTrue": isTrue, "false": isTrue, "null": isTrue,
	"struct": isTrue, "interface": isTrue, "trait": isTrue, "namespace": isTrue,
	"implements": isTrue, "with": isTrue, "pub": isTrue, "priv": isTrue,
	"override": isTrue, "virtual": isTrue, "final": isTrue, "operator": isTrue,
	"requires": isTrue,
}

const GATE_ONLY := {
	"struct": isTrue, "interface": isTrue, "trait": isTrue, "namespace": isTrue,
	"implements": isTrue, "with": isTrue, "pub": isTrue, "priv": isTrue,
	"override": isTrue, "virtual": isTrue, "final": isTrue, "operator": isTrue,
	"requires": isTrue,
}


func is_gate_only_keyword(v: String) -> bool:
	return GATE_ONLY.has(v)

const CONTEXTUAL_KEYWORDS := {"match": isTrue, "when": isTrue, "abstract": isTrue}


func is_contextual_keyword(v: String) -> bool:
	return v in CONTEXTUAL_KEYWORDS

const OPS3 := ["**=", "<<=", ">>=", "..."]
const OPS2 := [
	"==", "!=", "<=", ">=", "->", "=>", ":=", "+=", "-=", "*=", "/=", "%=",
	"**", "<<", ">>", "&&", "||", "??", "?.", "?[", "&=", "|=", "|>", "^=", "..",
]


func substring(str: String, from_string: int, sizelen: int = -1):
	var strlen = str.length()
	var r = str.right(strlen - from_string)
	if sizelen != -1:
		return r.left(sizelen)
	return r

func _col(tokenprops, _i: int) -> int:
	return _i - tokenprops["_line_start"] + 1


func _is_quote(c: String) -> bool:
	return c == "'" or c == '"'

func to_output(token: Dictionary) -> String:
	const Tc_rev: Array = ["NEWLINE", "INDENT", "DEDENT", "EOF", "IDENT", "KEYWORD", "NUMBER", "STRING", "FSTRING", "ANNOTATION", "NODEPATH", "COMMENT", "OP"]
	return "[" + Tc_rev[token["tc_type"]] + " " + token["tc_value"] + " @" + str(token["tc_line"]) + ":" + str(token["tc_col"]) + "]"

func _push(tokenprops, _i: int, t: int, v: String, line: int = -1, col: int = -1):
	var l = line if line >= 0 else tokenprops["_line"]
	var c = col if col >= 0 else _col(tokenprops, _i)
	var tokenclass: Dictionary = {
		"tc_type": t,
		"tc_value": v,
		"tc_line": l,
		"tc_col": c,
	}
	tokenclass["tc_type"] = t
	tokenclass["tc_value"] = v
	tokenclass["tc_line"] = l
	tokenclass["tc_col"] = c
	tokenprops["tokens"].append(tokenclass)
	return tokenclass


func tokenize(src: String, first_line: int = 1):

	var tokenprops: Dictionary = {
		"_line": 1,
		"_line_start": 0,
		"_indents": [0],
		"_indent_char": "",
		"_depth": 0,
		"tokens": [],
		"bracket_comments": []
	}
	
	
	if src.length() > 0 and ord(src[0]) == 0xFEFF:
		src = substring(src, 1, -1)
	var _src = src
	var _n: int = 0
	_n = src.length()
	var _i: int = 0
	tokenprops["_line"] = first_line
	tokenprops["_line_start"] = 0
	tokenprops["_indents"] = [0]
	tokenprops["_indent_char"] = ""
	tokenprops["_depth"] = 0

	var at_line_start: bool = true

	while _i < _n:
		if at_line_start and tokenprops["_depth"] == 0:
			at_line_start = false
			var arr: Array = _handle_indent(tokenprops, _i, _src, _n)
			_i = arr[0]
			tokenprops = arr[1]
			continue

		var c: String = _src[_i]

		if c == "\n":
			var arr: Array = _newline_token(tokenprops, _i)
			_i = arr[0]
			tokenprops = arr[1]
			at_line_start = tokenprops["_depth"] == 0
			continue
		if c == "\r":
			_i += 1
			continue
		if c == " " or c == "\t":
			_i += 1
			continue
		if c == "\\":
			var bs_col: int = _col(tokenprops, _i)
			_i += 1
			if _i < _n and _src[_i] == "\r":
				_i += 1
			if _i >= _n or _src[_i] != "\n":
				pass
			while _i < _n and _src[_i] != "\n":
				_i += 1
			if _i < _n:
				_i += 1
				tokenprops["_line"] += 1
				tokenprops["_line_start"] = _i
			while _i < _n:
				var j: int = _i
				while j < _n and (_src[j] == " " or _src[j] == "\t" or _src[j] == "\r"):
					j += 1
				if j >= _n or _src[j] != "#":
					break
				_i = j
				var arr: Array = _skip_comment(tokenprops, _i, _src, _n)
				_i = arr[0]
				tokenprops = arr[1]
				if _i < _n and _src[_i] == "\n":
					_i += 1
					tokenprops["_line"] += 1
					tokenprops["_line_start"] = _i
			continue
		if c == "#":
			if tokenprops["_depth"] > 0:
				var arr: Array = _note_bracket_comment(tokenprops, _i, _src, _n)
				_i = arr[0]
				tokenprops = arr[1]
			else:
				var arr: Array = _lex_comment(tokenprops, _i, _src, _n)
				_i = arr[0]
				tokenprops = arr[1]
			continue
		if c == '"' or c == '\'':
			var arr: Array = _lex_string(tokenprops, _i, _src, _n, false)
			_i = arr[0]
			tokenprops = arr[1]
			continue
		if c in ["f", "r", "&", "^"] and _i + 1 < _n and _is_quote(_src[_i + 1]):
			var is_f: bool = c == "f"
			_i += 1
			var arr: Array = _lex_string(tokenprops, _i, _src, _n, is_f, "" if is_f else c)
			_i = arr[0]
			tokenprops = arr[1]
			continue
		if c >= "0" and c <= "9":
			var arr: Array = _lex_number(tokenprops, _i, _src, _n)
			_i = arr[0]
			tokenprops = arr[1]
			continue
		if (c == "." and _i + 1 < _n and _src[_i + 1] >= "0" and _src[_i + 1] <= "9" and not _prev_ends_expr(tokenprops)):
			var arr: Array = _lex_number(tokenprops, _i, _src, _n)
			_i = arr[0]
			tokenprops = arr[1]
			continue
		if c == "@":
			var arr: Array = _lex_prefixed(tokenprops, _T["ANNOTATION"], _i, _src, _n)
			_i = arr[0]
			tokenprops = arr[1]
			continue
		if c == "$" or c == "%":
			# `%` is a unique-node path only in prefix position. After anything that can end
			# an expression it is modulo, which is how Godot's own tokenizer decides.
			# Godot allows whitespace between the sigil and the name.
			var k: int = _i + 1
			while k < _n and (_src[k] == " " or _src[k] == "	"):
				k += 1
			var nxt: String = ""
			if k < _n:
				nxt = _src[k]
			var path_like: bool = nxt != "" and (_is_word_start(nxt) or _is_quote(nxt))
			if c == "%" and (not path_like or _prev_ends_expr(tokenprops)):
				var arr: Array = _lex_operator(tokenprops, _i, _src, _n)
				_i = arr[0]
				tokenprops = arr[1]
				continue
			var arr: Array = _lex_nodepath(tokenprops, _i, _src, _n)
			_i = arr[0]
			tokenprops = arr[1]
			continue
		if _is_word_start(c):
			var arr: Array = _lex_word(tokenprops, _i, _src, _n)
			_i = arr[0]
			tokenprops = arr[1]
			continue
		var arr: Array = _lex_operator(tokenprops, _i, _src, _n)
		_i = arr[0]
		tokenprops = arr[1]

	if tokenprops["_depth"] != 0:
		pass
	_push(tokenprops, _i, _T["NEWLINE"], "")
	
	var indents = tokenprops["_indents"]
	while indents.size() > 1:
		tokenprops["_indents"].pop_back()
		indents = tokenprops["_indents"]
		_push(tokenprops, _i, _T["DEDENT"], "")
	_push(tokenprops, _i, _T["EOF"], "")
	return tokenprops["tokens"]


func _newline_token(tokenprops, _i: int) -> Array:
	if tokenprops["_depth"] == 0:
		_push(tokenprops, _i, _T["NEWLINE"], "")
	_i += 1
	tokenprops["_line"] += 1
	tokenprops["_line_start"] = _i
	return [_i, tokenprops]


func _handle_indent(tokenprops, _i: int, _src: String, _n: int) -> Array:
	var col: int = 0
	var start: int = _i
	while _i < _n:
		var c: String = _src[_i]
		if c == " ":
			col += 1
			_i += 1
		elif c == "\t":
			col += 4
			_i += 1
		else:
			break
	if _i >= _n:
		return [_i, tokenprops]
	var c2: String = _src[_i]
	if c2 == "\n" or c2 == "\r":
		return [_i, tokenprops]
	if c2 == "#":
		return [_i, tokenprops]
	if not _indent_chars_agree(tokenprops, substring(_src, start, _i - start)):
		_i = _n   # Godot stops here; what follows would only report the same mistake again
		return [_i, tokenprops]
	if col > tokenprops["_indents"][-1]:
		tokenprops["_indents"].append(col)
		_push(tokenprops, _i, _T["INDENT"], "", tokenprops["_line"], start - tokenprops["_line_start"] + 1)
	else:
		while col < tokenprops["_indents"][-1]:
			tokenprops["_indents"].pop_back()
			_push(tokenprops, _i, _T["DEDENT"], "", tokenprops["_line"], start - tokenprops["_line_start"] + 1)
		if col != tokenprops["_indents"][-1]:
			pass
	return [_i, tokenprops]


## Godot fixes the indentation character at the first indented line of code -
## blank lines, comments, string contents and continuations do not count - and
## refuses a later line indented with the other one, or with both.
func _indent_chars_agree(tokenprops, ws: String) -> bool:
	if ws == "":
		return true
	if ws.contains(" ") and ws.contains("	"):
		pass
		return false
	var ch: String = ws[0]
	if tokenprops["_indent_char"] == "":
		tokenprops["_indent_char"] = ch
		return true
	if ch == tokenprops["_indent_char"]:
		return true
	var used: String  = "space"
	if ch == "	":
		used = "tab"
	var before: String = "space"
	if tokenprops["_indent_char"] == "	":
		before = "tab"
	return false


func _skip_comment(tokenprops, _i: int, _src: String, _n: int) -> Array:
	while _i < _n and _src[_i] != "\n":
		_i += 1
	return [_i, tokenprops]


func _note_bracket_comment(tokenprops, _i: int, _src: String, _n: int) -> Array:
	var line: int = tokenprops["_line"]
	var col: int = _col(tokenprops, _i)
	var start: int = _i
	var arr: Array = _skip_comment(tokenprops, _i, _src, _n)
	_i = arr[0]
	tokenprops = arr[1]
	var tsize = tokenprops["tokens"]
	tsize = tsize.size()
	var own: bool = not tokenprops["tokens"].is_empty() and tokenprops["tokens"][tsize - 1].line == line
	tokenprops["bracket_comments"].append({"line": line, "col": col,
		"text": substring(_src, start, _i - start), "own_line": not own})
	return [_i, tokenprops]


func _lex_comment(tokenprops, _i: int, _src: String, _n: int) -> Array:
	var line: int = tokenprops["_line"]
	var col: int = _col(tokenprops, _i)
	var start: int = _i
	while _i < _n and _src[_i] != "\n":
		_i += 1
	_push(tokenprops, _i, _T["COMMENT"], substring(_src, start, _i - start), line, col)
	return [_i, tokenprops]


func _lex_string(tokenprops, _i: int, _src: String, _n: int, is_fstring: bool, prefix: String = "") -> Array:
	var line: int = tokenprops["_line"]
	var col: int = _col(tokenprops, _i) - (1 if prefix != "" or is_fstring else 0)
	var quote: String = _src[_i]
	var triple: bool = false
	if _i + 2 < _n and _src[_i + 1] == quote and _src[_i + 2] == quote:
		triple = true
		_i += 3
	else:
		_i += 1
	var body_start: int = _i
	var closed: bool = false
	var spans_lines: bool = false
	while _i < _n:
		var c: String = _src[_i]
		if c == "\\":
			if _i + 1 < _n and _src.unicode_at(_i + 1) == 10:
				tokenprops["_line"] += 1
				_i += 2
				tokenprops["_line_start"] = _i
				continue
			_i += 2
			continue
		if c == "\n":
			tokenprops["_line"] += 1
			_i += 1
			tokenprops["_line_start"] = _i
			if not triple:
				spans_lines = true
			continue
		if c == quote:
			if triple:
				if _i + 2 < _n and _src[_i + 1] == quote and _src[_i + 2] == quote:
					closed = true
					break
				_i += 1
				continue
			closed = true
			break
		_i += 1
	if not closed:
		pass
		var t = _push(tokenprops, _i, _T["STRING"], '""', line, col)
		return [_i, tokenprops]
	if spans_lines:
		pass
	var body: String = substring(_src, body_start, _i - body_start)
	_i += 3 if triple else 1
	var tok = _push(tokenprops, _i, _T["FSTRING"] if is_fstring else _T["STRING"], body, line, col)
	tok.extra = quote if not triple else quote.repeat(3)
	tok.prefix = prefix
	return [_i, tokenprops]


func _lex_number(tokenprops, _i: int, _src: String, _n: int) -> Array:
	var line: int = tokenprops["_line"]
	var col: int = _col(tokenprops, _i)
	var start: int = _i
	var seen_dot: bool = false
	var is_hex: bool = false
	if _src[_i] == "0" and _i + 1 < _n and (_src[_i + 1] == "x" or _src[_i + 1] == "b"):
		is_hex = true
		_i += 2
	while _i < _n:
		var c: String = _src[_i]
		if c >= "0" and c <= "9":
			_i += 1
		elif c == "_":
			_i += 1
		elif is_hex and ((c >= "a" and c <= "f") or (c >= "A" and c <= "F")):
			_i += 1
		elif c == "." and not seen_dot and not is_hex:
			if _i + 1 < _n and _src[_i + 1] == ".":
				break
			seen_dot = true
			_i += 1
		elif not is_hex and (c == "e" or c == "E") and _i + 1 < _n \
			and (_src[_i + 1].is_valid_int() or _src[_i + 1] == "-" or _src[_i + 1] == "+"):
			_i += 2
		else:
			break
	_push(tokenprops, _i, _T["NUMBER"], substring(_src, start, _i - start), line, col)
	return [_i, tokenprops]


func _lex_prefixed(tokenprops, kind: int, _i: int, _src: String, _n: int) -> Array:
	var line: int = tokenprops["_line"]
	var col: int = _col(tokenprops, _i)
	var start: int = _i
	_i += 1
	while _i < _n and _is_word(_src[_i]):
		_i += 1
	_push(tokenprops, _i, kind, substring(_src, start, _i - start), line, col)
	return [_i, tokenprops]


func _lex_nodepath(tokenprops, _i: int, _src: String, _n: int) -> Array:
	var line: int = tokenprops["_line"]
	var col: int = _col(tokenprops, _i)
	var start: int = _i
	_i += 1
	var k: int = _i
	while k < _n and (_src[k] == " " or _src[k] == "	"):
		k += 1
	if k < _n and (_is_word_start(_src[k]) or _is_quote(_src[k])):
		_i = k
	if _i < _n and (_src[_i] == '"' or _src[_i] == '\''):
		var q: String = _src[_i]
		_i += 1
		while _i < _n and _src[_i] != q:
			_i += 1
		_i += 1
	else:
		while _i < _n and (_is_word(_src[_i]) or _src[_i] == "/" or _src[_i] == "%"):
			_i += 1
	_push(tokenprops, _i, _T["NODEPATH"], substring(_src, start, _i - start), line, col)
	return [_i, tokenprops]


func _lex_word(tokenprops, _i: int, _src: String, _n: int) -> Array:
	var line: int = tokenprops["_line"]
	var col: int = _col(tokenprops, _i)
	var start: int = _i
	while _i < _n and _is_word(_src[_i]):
		_i += 1
	var w: String = substring(_src, start, _i - start)
	_push(tokenprops, _i, _T["KEYWORD"] if w in KEYWORDS else _T["IDENT"], w, line, col)
	return [_i, tokenprops]

func max_value(a, b):
	if a > b:
		return a
	return b

func _lex_operator(tokenprops, _i: int, _src: String, _n: int) -> Array:
	var line: int = tokenprops["_line"]
	var col: int = _col(tokenprops, _i)
	var c: String = _src[_i]
	if c == "(" or c == "[" or c == "{":
		tokenprops["_depth"] += 1
	elif c == ")" or c == "]" or c == "}":
		tokenprops["_depth"] = max_value(0, tokenprops["_depth"] - 1)

	if _i + 2 < _n:
		var three: String = substring(_src, _i, 3)
		if three in OPS3:
			_i += 3
			_push(tokenprops, _i, _T["OP"], three, line, col)
			return [_i, tokenprops]
	if _i + 1 < _n:
		var two: String = substring(_src, _i, 2)
		if two in OPS2:
			_i += 2
			_push(tokenprops, _i, _T["OP"], two, line, col)
			return [_i, tokenprops]
	_i += 1
	_push(tokenprops, _i, _T["OP"], c, line, col)
	return [_i, tokenprops]


func _prev_ends_expr(tokenprops) -> bool:
	var mytokens = tokenprops["tokens"]
	for i in range(mytokens.size() - 1, -1, -1):
		var t = mytokens[i]
		if t.type == _T["COMMENT"]:
			continue
		if t.type == _T["IDENT"] or t.type == _T["NUMBER"] or t.type == _T["STRING"] or t.type == _T["FSTRING"] or t.type == _T["NODEPATH"]:
			return true
		elif t.type == _T["KEYWORD"]:
			if t.value in CONTEXTUAL_KEYWORDS:
				return _contextual_is_name(tokenprops, i)
			return (t.value in ["self", "super", "true", "false", "null"] or GATE_ONLY.has(t.value))
		elif t.type == _T["OP"]:
			return t.value in [")", "]", "}"]
		else:
			return false
	return false


func _contextual_is_name(tokenprops, i: int) -> bool:
	var t = tokenprops["tokens"][i]
	var j: int = i - 1
	while j >= 0 and tokenprops["tokens"][j].type == _T["COMMENT"]:
		j -= 1
	var prev = tokenprops["tokens"][j] if j >= 0 else null
	if prev != null and prev.type == _T["OP"] and prev.value == ".":
		return true
	if t.value == "match":
		return prev != null and not (prev.type in [_T["NEWLINE"], _T["INDENT"], _T["DEDENT"]] or (prev.type == _T["OP"] and prev.value == ";"))
	elif t.value == "when":
		if prev == null:
			return true
		var after_pattern: bool = prev.type in [_T["IDENT"], _T["NUMBER"], _T["STRING"], _T["NODEPATH"]] or (prev.type == _T["OP"] and prev.value in [")", "]", "}"]) or (prev.type == _T["KEYWORD"] and prev.value in ["true", "false", "null"])
		return not after_pattern
	return true


func _is_word_start(c: String) -> bool:
	return ((c >= "a" and c <= "z") or (c >= "A" and c <= "Z") or c == "_" or ord(c[0]) >= 0x80)

func _is_word(c: String) -> bool:
	return _is_word_start(c) or (c >= "0" and c <= "9")
