m1 # No init. = None
m2 = 22 # Init.
m3: # No init, typed. = None
m4= "44"# Init, typed.
def test():
    loc5 # No init, local. = None
    loc6 = 66 # Init, local.
    loc7: # No init, typed. = None
    loc8= "88"# Init, typed.
    m1 = 11
    m3 = "33"
    loc5 = 55
    loc7 = "77"
    prints(m1, m2, m3, m4, loc5, loc6, loc7, loc8)
    print( "OK")
