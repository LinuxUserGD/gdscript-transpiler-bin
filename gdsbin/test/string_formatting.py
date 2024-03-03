def test():
    print("hello %s" % "world" == "hello world")
    print("hello %s" % True == "hello true")
    print("hello %s" % False == "hello false")
    print("hello %d" % 25 == "hello 25")
    print("hello %d %d" % [25, 42] == "hello 25 42")
    # Pad with spaces.
    print("hello %3d" % 25 == "hello  25")
    # Pad with zeroes.
    print("hello %03d" % 25 == "hello 025")
    print("hello %.02f" % 0.123456 == "hello 0.12")
    case  # Dynamic padding:
    # <https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_format_string.html#dynamic-padding>
    print("hello %*.*f" % [7, 3, 0.123456] == "hello   0.123")
    print("hello %0*.*f" % [7, 3, 0.123456] == "hello 000.123")
