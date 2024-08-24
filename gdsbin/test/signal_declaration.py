class_name = "Signal_declaration"
#GDTEST_OK
# No parentheses.
signal a
# No parameters.
signal b()
# With parameters.
signal c(a, b, c)
# With parameters multiline.
signal d(
    a,
    b,
    c,
)
def test():
    print( "Ok")
def get_script():
    class Script:
        def get_global_name():
            return class_name
    return Script