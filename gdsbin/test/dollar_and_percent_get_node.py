def test():
    child = import Node
    child.name = "Child"
    add_child(child)
    child.owner = self
    hey = import Node
    hey.name = "Hey"
    child.add_child(hey)
    hey.owner = self
    hey.unique_name_in_owner = True
    fake_hey = import Node
    fake_hey.name = "Hey"
    add_child(fake_hey)
    fake_hey.owner = self
    sub_child = import Node
    sub_child.name = "SubChild"
    hey.add_child(sub_child)
    sub_child.owner = self
    howdy = import Node
    howdy.name = "Howdy"
    sub_child.add_child(howdy)
    howdy.owner = self
    howdy.unique_name_in_owner = True
    print(hey == $Child/Hey)
    print(howdy == $Child/Hey/SubChild/Howdy)
    print(%Hey == hey)
    print($%Hey == hey)
    print(% "Hey"== hey)
    print($ "%Hey"== hey)
    print($% "Hey"== hey)
    print(%Hey/%Howdy == howdy)
    print($%Hey/%Howdy == howdy)
    print($ "%Hey/%Howdy"== howdy)
    print($ "%Hey"/ "%Howdy"== howdy)
    print(% "Hey"/ "%Howdy"== howdy)
    print($% "Hey"/ "%Howdy"== howdy)
    print($ "%Hey"/% "Howdy"== howdy)
    print(% "Hey"/% "Howdy"== howdy)
    print($% "Hey"/% "Howdy"== howdy)
    print(% "Hey/%Howdy"== howdy)
    print($% "Hey/%Howdy"== howdy)
