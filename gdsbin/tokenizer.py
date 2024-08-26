class_name = "Tokenizer"
import gdsbin.key

key = type(gdsbin.key)(gdsbin.key.__name__, gdsbin.key.__doc__)
key.__dict__.update(gdsbin.key.__dict__)
import gdsbin.keyword

keyword = type(gdsbin.keyword)(gdsbin.keyword.__name__, gdsbin.keyword.__doc__)
keyword.__dict__.update(gdsbin.keyword.__dict__)


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
        "class_name": keyword.KW_CLASSNAME,
        "extends": keyword.KW_EXTENDS,
        "##": keyword.KW_NUMBERSIGN2,
        "func": keyword.KW_FUNCTION,
        "new": keyword.KW_NEW,
        "var": keyword.KW_VARIABLE,
        "const": keyword.KW_CONST,
        "for": keyword.KW_FOR,
        "in": keyword.KW_IN,
        "if": keyword.KW_IF,
        qu: key.KEY_QUOTEDBL,
    }
    tokens = []
    buffer = ""
    str = False
    for ch in input_string:
        if ch in delimiter:
            if ch == '"':
                str = False if str else True
            elif str:
                buffer += ch
                continue
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


def char_to_token(buffer, token_index):
    import gdsbin.token

    token = type(gdsbin.token)(gdsbin.token.__name__, gdsbin.token.__doc__)
    token.__dict__.update(gdsbin.token.__dict__)
    token.id = token_index[buffer] if buffer in token_index else keyword.KW_NONE
    token.value = buffer
    return token


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
