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
        "#": "NUMBER SIGN",
        "!": "EXCLAMATION MARK",
        "/": "SLASH",
        "\\": "BACKSLASH",
        "class_name": "CLASS NAME",
        "extends": "EXTENDS",
        "##": "NUMBER SIGN 2",
        "func": "FUNCTION",
        "(": "LEFT BRACKET",
        ")": "RIGHT BRACKET",
        "-": "MINUS",
        "+": "PLUS",
        "*": "ASTERISK",
        ">": "GREATER THAN",
        "<": "LESS THAN",
        ":": "COLON",
        "=": "EQUALS SIGN",
        "{": "CURLY LEFT BRACKET",
        "}": "CURLY RIGHT BRACKET",
        "\t": "TAB",
        ".": "DOT",
        ",": "COMMA",
        "new": "NEW",
        "var": "VARIABLE",
        "const": "CONST",
        "for": "FOR",
        "in": "IN",
        "if": "IF",
        qu: "QUOTATION",
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
