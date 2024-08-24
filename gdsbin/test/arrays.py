class_name = "Arrays"


def test():
    case  # Indexing from the beginning:
    print([1, 2, 3][0])
    print([1, 2, 3][1])
    print([1, 2, 3][2])
    case  # Indexing from the end:
    print([1, 2, 3][-1])
    print([1, 2, 3][-2])
    print([1, 2, 3][-3])
    # Float indices are currently allowed, but should probably be an error?
    print([1, 2, 3][0.4])
    print([1, 2, 3][0.8])
    print([1, 2, 3][1.0])
    print([1, 2, 3][-1.0])


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
