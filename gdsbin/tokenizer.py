import gdsbin.key

key = type(gdsbin.key)(gdsbin.key.__name__, gdsbin.key.__doc__)
key.__dict__.update(gdsbin.key.__dict__)


def tokenize(input_string):
    delimiter = [
        "(",
        ")",
        ":",
        ",",
        ".",
        "=",
        "+",
        "-",
        "*",
        "/",
        "<",
        ">",
        "!",
        "&",
        "|",
        "~",
        "%",
        " ",
        "[",
        "]",
        "{",
        "}",
        '"',
        "\t",
    ]
    qu = '"'
    token = {
        "#": key.KEY_NUMBERSIGN,
        "!": key.KEY_EXCLAM,
        "/": key.KEY_SLASH,
        "\\": key.KEY_BACKSLASH,
        "class_name": "CLASS NAME",
        "extends": "EXTENDS",
        "##": "NUMBER SIGN 2",
        "func": "FUNCTION",
        "(": key.KEY_PARENLEFT,
        ")": key.KEY_PARENRIGHT,
        "-": key.KEY_MINUS,
        "+": key.KEY_PLUS,
        "*": key.KEY_ASTERISK,
        ">": key.KEY_GREATER,
        "<": key.KEY_LESS,
        ":": key.KEY_COLON,
        "=": key.KEY_EQUAL,
        "{": key.KEY_BRACELEFT,
        "}": key.KEY_BRACERIGHT,
        "\t": key.KEY_TAB,
        ".": key.KEY_PERIOD,
        ",": key.KEY_COMMA,
        "new": "NEW",
        "var": "VARIABLE",
        "const": "CONST",
        "for": "FOR",
        "in": "IN",
        "if": "IF",
        qu: key.KEY_QUOTEDBL,
    }
    tokens = []
    buffer = ""
    for ch in input_string:
        if ch in delimiter:
            if buffer != "":
                tokens.append(char_to_token(buffer, token))
                buffer = ""
            if ch != " ":
                tokens.append(char_to_token(ch, token))
        else:
            buffer += ch
    if buffer != "":
        tokens.append(char_to_token(buffer, token))
    return tokens


def char_to_token(buffer, token):
    return token[buffer] if buffer in token else buffer
