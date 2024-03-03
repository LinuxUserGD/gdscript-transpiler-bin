def test():
    # Create the required node structure.
    hello = import Node
    hello.name = "Hello"
    add_child(hello)
    world = import Node
    world.name = "World"
    hello.add_child(world)
    # All the ways of writing node paths below with the `$` operator are valid.
    # Results are assigned to variables to avoid warnings.
    __ = $Hello
    __ = $ "Hello"
    __ = $Hello/World
    __ = $ "Hello/World"
    __ = $ "Hello/.."
    __ = $ "Hello/../Hello/World"
