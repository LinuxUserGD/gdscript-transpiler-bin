class_name = "Lexer"
_T = {
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
    "OP": 12,
}
isTrue = True
KEYWORDS = {
    "if": isTrue,
    "elif": isTrue,
    "else": isTrue,
    "for": isTrue,
    "while": isTrue,
    "match": isTrue,
    "when": isTrue,
    "break": isTrue,
    "continue": isTrue,
    "pass": isTrue,
    "return": isTrue,
    "class": isTrue,
    "class_name": isTrue,
    "extends": isTrue,
    "is": isTrue,
    "in": isTrue,
    "as": isTrue,
    "self": isTrue,
    "super": isTrue,
    "signal": isTrue,
    "func": isTrue,
    "static": isTrue,
    "const": isTrue,
    "enum": isTrue,
    "var": isTrue,
    "breakpoint": isTrue,
    "preload": isTrue,
    "await": isTrue,
    "assert": isTrue,
    "void": isTrue,
    "abstract": isTrue,
    "and": isTrue,
    "or": isTrue,
    "not": isTrue,
    "isTrue": isTrue,
    "false": isTrue,
    "null": isTrue,
    "struct": isTrue,
    "interface": isTrue,
    "trait": isTrue,
    "namespace": isTrue,
    "implements": isTrue,
    "with": isTrue,
    "pub": isTrue,
    "priv": isTrue,
    "override": isTrue,
    "virtual": isTrue,
    "final": isTrue,
    "operator": isTrue,
    "requires": isTrue,
}
GATE_ONLY = {
    "struct": isTrue,
    "interface": isTrue,
    "trait": isTrue,
    "namespace": isTrue,
    "implements": isTrue,
    "with": isTrue,
    "pub": isTrue,
    "priv": isTrue,
    "override": isTrue,
    "virtual": isTrue,
    "final": isTrue,
    "operator": isTrue,
    "requires": isTrue,
}


def is_gate_only_keyword(v):
    return GATE_ONLY.has(v)


CONTEXTUAL_KEYWORDS = {"match": isTrue, "when": isTrue, "abstract": isTrue}


def is_contextual_keyword(v):
    return v in CONTEXTUAL_KEYWORDS


OPS3 = ["**=", "<<=", ">>=", "..."]
OPS2 = [
    "==",
    "!=",
    "<=",
    ">=",
    "->",
    "=>",
    ":=",
    "+=",
    "-=",
    "*=",
    "/=",
    "%=",
    "**",
    "<<",
    ">>",
    "&&",
    "||",
    "??",
    "?.",
    "?[",
    "&=",
    "|=",
    "|>",
    "^=",
    "..",
]


def substring(str, from_string, sizelen=-1):
    strlen = len(str)
    r = right(str, strlen - from_string)
    if sizelen != -1:
        return left(r, sizelen)
    return r


def _col(tokenprops, _i):
    return _i - tokenprops["_line_start"] + 1


def _is_quote(c):
    return c == "'" or c == '"'


def to_output(token):
    Tc_rev = [
        "NEWLINE",
        "INDENT",
        "DEDENT",
        "EOF",
        "IDENT",
        "KEYWORD",
        "NUMBER",
        "STRING",
        "FSTRING",
        "ANNOTATION",
        "NODEPATH",
        "COMMENT",
        "OP",
    ]
    return (
        "["
        + Tc_rev[token["tc_type"]]
        + " "
        + token["tc_value"]
        + " @"
        + str(token["tc_line"])
        + ":"
        + str(token["tc_col"])
        + "]"
    )


def _push(tokenprops, _i, t, v, line=-1, col=-1):
    l = line if line >= 0 else tokenprops["_line"]
    c = col if col >= 0 else _col(tokenprops, _i)
    tokenclass = {
        "tc_type": t,
        "tc_value": v,
        "tc_line": l,
        "tc_col": c,
        "tc_extra": "",
        "tc_prefix": "",
    }
    tokenclass["tc_type"] = t
    tokenclass["tc_value"] = v
    tokenclass["tc_line"] = l
    tokenclass["tc_col"] = c
    tokenprops["tokens"].append(tokenclass)
    return tokenclass


def tokenize(src, first_line=1):
    tokenprops = {
        "_line": 1,
        "_line_start": 0,
        "_indents": [0],
        "_indent_char": "",
        "_depth": 0,
        "tokens": [],
        "bracket_comments": [],
    }

    if len(src) > 0 and ord(src[0]) == 0xFEFF:
        src = substring(src, 1, -1)
    _src = src
    _n = 0
    _n = len(src)
    _i = 0
    tokenprops["_line"] = first_line
    tokenprops["_line_start"] = 0
    tokenprops["_indents"] = [0]
    tokenprops["_indent_char"] = ""
    tokenprops["_depth"] = 0
    at_line_start = True
    while _i < _n:
        if at_line_start and tokenprops["_depth"] == 0:
            at_line_start = False
            arr = _handle_indent(tokenprops, _i, _src, _n)
            _i = arr[0]
            tokenprops = arr[1]
            continue
        c = _src[_i]
        if c == "\n":
            arr = _newline_token(tokenprops, _i)
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
            bs_col = _col(tokenprops, _i)
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
                j = _i
                while j < _n and (_src[j] == " " or _src[j] == "\t" or _src[j] == "\r"):
                    j += 1
                if j >= _n or _src[j] != "#":
                    break
                _i = j
                arr = _skip_comment(tokenprops, _i, _src, _n)
                _i = arr[0]
                tokenprops = arr[1]
                if _i < _n and _src[_i] == "\n":
                    _i += 1
                    tokenprops["_line"] += 1
                    tokenprops["_line_start"] = _i
            continue
        if c == "#":
            if tokenprops["_depth"] > 0:
                arr = _note_bracket_comment(tokenprops, _i, _src, _n)
                _i = arr[0]
                tokenprops = arr[1]
            else:
                arr = _lex_comment(tokenprops, _i, _src, _n)
                _i = arr[0]
                tokenprops = arr[1]
            continue
        if c == '"' or c == "'":
            _false = False
            arr = _lex_string(tokenprops, _i, _src, _n, _false)
            _i = arr[0]
            tokenprops = arr[1]
            continue
        if c in ["f", "r", "&", "^"] and _i + 1 < _n and _is_quote(_src[_i + 1]):
            is_f = c == "f"
            _i += 1
            arr = _lex_string(tokenprops, _i, _src, _n, is_f, "" if is_f else c)
            _i = arr[0]
            tokenprops = arr[1]
            continue
        if c >= "0" and c <= "9":
            arr = _lex_number(tokenprops, _i, _src, _n)
            _i = arr[0]
            tokenprops = arr[1]
            continue
        if (
            c == "."
            and _i + 1 < _n
            and _src[_i + 1] >= "0"
            and _src[_i + 1] <= "9"
            and not _prev_ends_expr(tokenprops)
        ):
            arr = _lex_number(tokenprops, _i, _src, _n)
            _i = arr[0]
            tokenprops = arr[1]
            continue
        if c == "@":
            arr = _lex_prefixed(tokenprops, _T["ANNOTATION"], _i, _src, _n)
            _i = arr[0]
            tokenprops = arr[1]
            continue
        if c == "$" or c == "%":
            # `%` is a unique-node path only in prefix position. After anything that can end
            # an expression it is modulo, which is how Godot's own tokenizer decides.
            # Godot allows whitespace between the sigil and the name.
            k = _i + 1
            while k < _n and (_src[k] == " " or _src[k] == "	"):
                k += 1
            nxt = ""
            if k < _n:
                nxt = _src[k]
            path_like = nxt != "" and (_is_word_start(nxt) or _is_quote(nxt))
            if c == "%" and (not path_like or _prev_ends_expr(tokenprops)):
                arr = _lex_operator(tokenprops, _i, _src, _n)
                _i = arr[0]
                tokenprops = arr[1]
                continue
            arr = _lex_nodepath(tokenprops, _i, _src, _n)
            _i = arr[0]
            tokenprops = arr[1]
            continue
        if _is_word_start(c):
            arr = _lex_word(tokenprops, _i, _src, _n)
            _i = arr[0]
            tokenprops = arr[1]
            continue
        arr = _lex_operator(tokenprops, _i, _src, _n)
        _i = arr[0]
        tokenprops = arr[1]
    if tokenprops["_depth"] != 0:
        pass
    _push(tokenprops, _i, _T["NEWLINE"], "")

    indents = tokenprops["_indents"]
    while len(indents) > 1:
        tokenprops["_indents"].pop()
        indents = tokenprops["_indents"]
        _push(tokenprops, _i, _T["DEDENT"], "")
    _push(tokenprops, _i, _T["EOF"], "")
    return tokenprops["tokens"]


def _newline_token(tokenprops, _i):
    if tokenprops["_depth"] == 0:
        _push(tokenprops, _i, _T["NEWLINE"], "")
    _i += 1
    tokenprops["_line"] += 1
    tokenprops["_line_start"] = _i
    return [_i, tokenprops]


def _handle_indent(tokenprops, _i, _src, _n):
    col = 0
    start = _i
    while _i < _n:
        c = _src[_i]
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
    c2 = _src[_i]
    if c2 == "\n" or c2 == "\r":
        return [_i, tokenprops]
    if c2 == "#":
        return [_i, tokenprops]
    if not _indent_chars_agree(tokenprops, substring(_src, start, _i - start)):
        _i = _n  # Godot stops here; what follows would only report the same mistake again
        return [_i, tokenprops]
    if col > tokenprops["_indents"][-1]:
        tokenprops["_indents"].append(col)
        _push(
            tokenprops,
            _i,
            _T["INDENT"],
            "",
            tokenprops["_line"],
            start - tokenprops["_line_start"] + 1,
        )
    else:
        while col < tokenprops["_indents"][-1]:
            tokenprops["_indents"].pop()
            _push(
                tokenprops,
                _i,
                _T["DEDENT"],
                "",
                tokenprops["_line"],
                start - tokenprops["_line_start"] + 1,
            )
        if col != tokenprops["_indents"][-1]:
            pass
    return [_i, tokenprops]


def _indent_chars_agree(tokenprops, ws):
    if ws == "":
        return True
    if 0 <= ws.find(" ") and 0 <= ws.find("	"):
        pass
        return False
    ch = ws[0]
    if tokenprops["_indent_char"] == "":
        tokenprops["_indent_char"] = ch
        return True
    if ch == tokenprops["_indent_char"]:
        return True
    used = "space"
    if ch == "	":
        used = "tab"
    before = "space"
    if tokenprops["_indent_char"] == "	":
        before = "tab"
    return False


def _skip_comment(tokenprops, _i, _src, _n):
    while _i < _n and _src[_i] != "\n":
        _i += 1
    return [_i, tokenprops]


def _note_bracket_comment(tokenprops, _i, _src, _n):
    line = tokenprops["_line"]
    col = _col(tokenprops, _i)
    start = _i
    arr = _skip_comment(tokenprops, _i, _src, _n)
    _i = arr[0]
    tokenprops = arr[1]
    tsize = tokenprops["tokens"]
    tsize = len(tsize)
    own = (
        not tokenprops["tokens"].is_empty()
        and tokenprops["tokens"][tsize - 1].line == line
    )
    tokenprops["bracket_comments"].append(
        {
            "line": line,
            "col": col,
            "text": substring(_src, start, _i - start),
            "own_line": not own,
        }
    )
    return [_i, tokenprops]


def _lex_comment(tokenprops, _i, _src, _n):
    line = tokenprops["_line"]
    col = _col(tokenprops, _i)
    start = _i
    while _i < _n and _src[_i] != "\n":
        _i += 1
    _push(tokenprops, _i, _T["COMMENT"], substring(_src, start, _i - start), line, col)
    return [_i, tokenprops]


def _lex_string(tokenprops, _i, _src, _n, is_fstring, prefix=""):
    line = tokenprops["_line"]
    col = _col(tokenprops, _i) - (1 if prefix != "" or is_fstring else 0)
    quote = _src[_i]
    triple = False
    if _i + 2 < _n and _src[_i + 1] == quote and _src[_i + 2] == quote:
        triple = True
        _i += 3
    else:
        _i += 1
    body_start = _i
    closed = False
    spans_lines = False
    while _i < _n:
        c = _src[_i]
        if c == "\\":
            if _i + 1 < _n and ord(_src[_i + 1]) == 10:
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
                spans_lines = True
            continue
        if c == quote:
            if triple:
                if _i + 2 < _n and _src[_i + 1] == quote and _src[_i + 2] == quote:
                    closed = True
                    break
                _i += 1
                continue
            closed = True
            break
        _i += 1
    if not closed:
        pass
        t = _push(tokenprops, _i, _T["STRING"], ' ""', line, col)
        return [_i, tokenprops]
    if spans_lines:
        pass
    body = substring(_src, body_start, _i - body_start)
    _i += 3 if triple else 1
    tok = _push(
        tokenprops, _i, _T["FSTRING"] if is_fstring else _T["STRING"], body, line, col
    )
    tok["tc_extra"] = quote if not triple else quote.repeat(3)
    tok["tc_prefix"] = prefix
    return [_i, tokenprops]


def _lex_number(tokenprops, _i, _src, _n):
    line = tokenprops["_line"]
    col = _col(tokenprops, _i)
    start = _i
    seen_dot = False
    is_hex = False
    if _src[_i] == "0" and _i + 1 < _n and (_src[_i + 1] == "x" or _src[_i + 1] == "b"):
        is_hex = True
        _i += 2
    while _i < _n:
        c = _src[_i]
        if c >= "0" and c <= "9":
            _i += 1
        elif c == "_":
            _i += 1
        elif is_hex and ((c >= "a" and c <= "f") or (c >= "A" and c <= "F")):
            _i += 1
        elif c == "." and not seen_dot and not is_hex:
            if _i + 1 < _n and _src[_i + 1] == ".":
                break
            seen_dot = True
            _i += 1
        elif (
            not is_hex
            and (c == "e" or c == "E")
            and _i + 1 < _n
            and (
                _src[_i + 1].is_valid_int()
                or _src[_i + 1] == "-"
                or _src[_i + 1] == "+"
            )
        ):
            _i += 2
        else:
            break
    _push(tokenprops, _i, _T["NUMBER"], substring(_src, start, _i - start), line, col)
    return [_i, tokenprops]


def _lex_prefixed(tokenprops, kind, _i, _src, _n):
    line = tokenprops["_line"]
    col = _col(tokenprops, _i)
    start = _i
    _i += 1
    while _i < _n and _is_word(_src[_i]):
        _i += 1
    _push(tokenprops, _i, kind, substring(_src, start, _i - start), line, col)
    return [_i, tokenprops]


def _lex_nodepath(tokenprops, _i, _src, _n):
    line = tokenprops["_line"]
    col = _col(tokenprops, _i)
    start = _i
    _i += 1
    k = _i
    while k < _n and (_src[k] == " " or _src[k] == "	"):
        k += 1
    if k < _n and (_is_word_start(_src[k]) or _is_quote(_src[k])):
        _i = k
    if _i < _n and (_src[_i] == '"' or _src[_i] == "'"):
        q = _src[_i]
        _i += 1
        while _i < _n and _src[_i] != q:
            _i += 1
        _i += 1
    else:
        while _i < _n and (_is_word(_src[_i]) or _src[_i] == "/" or _src[_i] == "%"):
            _i += 1
    _push(tokenprops, _i, _T["NODEPATH"], substring(_src, start, _i - start), line, col)
    return [_i, tokenprops]


def _lex_word(tokenprops, _i, _src, _n):
    line = tokenprops["_line"]
    col = _col(tokenprops, _i)
    start = _i
    while _i < _n and _is_word(_src[_i]):
        _i += 1
    w = substring(_src, start, _i - start)
    _push(tokenprops, _i, _T["KEYWORD"] if w in KEYWORDS else _T["IDENT"], w, line, col)
    return [_i, tokenprops]


def _value(a, b):
    if a > b:
        return a
    return b


def _lex_operator(tokenprops, _i, _src, _n):
    line = tokenprops["_line"]
    col = _col(tokenprops, _i)
    c = _src[_i]
    if c == "(" or c == "[" or c == "{":
        tokenprops["_depth"] += 1
    elif c == ")" or c == "]" or c == "}":
        tokenprops["_depth"] = _value(0, tokenprops["_depth"] - 1)
    if _i + 2 < _n:
        three = substring(_src, _i, 3)
        if three in OPS3:
            _i += 3
            _push(tokenprops, _i, _T["OP"], three, line, col)
            return [_i, tokenprops]
    if _i + 1 < _n:
        two = substring(_src, _i, 2)
        if two in OPS2:
            _i += 2
            _push(tokenprops, _i, _T["OP"], two, line, col)
            return [_i, tokenprops]
    _i += 1
    _push(tokenprops, _i, _T["OP"], c, line, col)
    return [_i, tokenprops]


def _prev_ends_expr(tokenprops):
    mytokens = tokenprops["tokens"]
    for i in range(len(mytokens) - 1, -1, -1):
        t = mytokens[i]
        if t["tc_type"] == _T["COMMENT"]:
            continue
        if (
            t["tc_type"] == _T["IDENT"]
            or t["tc_type"] == _T["NUMBER"]
            or t["tc_type"] == _T["STRING"]
            or t["tc_type"] == _T["FSTRING"]
            or t["tc_type"] == _T["NODEPATH"]
        ):
            return True
        elif t["tc_type"] == _T["KEYWORD"]:
            if t["tc_value"] in CONTEXTUAL_KEYWORDS:
                return _contextual_is_name(tokenprops, i)
            return t["tc_value"] in [
                "self",
                "super",
                "true",
                "false",
                "null",
            ] or GATE_ONLY.has(t["tc_value"])
        elif t["tc_type"] == _T["OP"]:
            return t["tc_value"] in [")", "]", "}"]
        else:
            return False
    return False


def _contextual_is_name(tokenprops, i):
    t = tokenprops["tokens"][i]
    j = i - 1
    while j >= 0 and tokenprops["tokens"][j]["tc_type"] == _T["COMMENT"]:
        j -= 1
    prev = tokenprops["tokens"][j] if j >= 0 else None
    if prev != None and prev["tc_type"] == _T["OP"] and prev["tc_value"] == ".":
        return True
    if t["tc_value"] == "match":
        return prev != None and not (
            prev["tc_type"] in [_T["NEWLINE"], _T["INDENT"], _T["DEDENT"]]
            or (prev["tc_type"] == _T["OP"] and prev["tc_value"] == ";")
        )
    elif t["tc_value"] == "when":
        if prev == None:
            return True
        after_pattern = (
            prev["tc_type"] in [_T["IDENT"], _T["NUMBER"], _T["STRING"], _T["NODEPATH"]]
            or (prev["tc_type"] == _T["OP"] and prev["tc_value"] in [")", "]", "}"])
            or (
                prev["tc_type"] == _T["KEYWORD"]
                and prev["tc_value"] in ["true", "false", "null"]
            )
        )
        return not after_pattern
    return True


def _is_word_start(c):
    return (
        (c >= "a" and c <= "z")
        or (c >= "A" and c <= "Z")
        or c == "_"
        or ord(c[0]) >= 0x80
    )


def _is_word(c):
    return _is_word_start(c) or (c >= "0" and c <= "9")


def left(s, amount):
    return s[:amount]


def right(s, amount):
    if amount < 0:
        return s[-amount:]
    else:
        return s[len(s) - amount :]


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
