def test():
    case  # The following lines are equivalent:
    _integer = 1
    _integer2 = 1
    _inferred = 1
    _inferred2 = 1
    # Type inference is automatic for constants.
    _INTEGER = 1
    _INTEGER_REDUNDANT_TYPED = 1
    _INTEGER_REDUNDANT_TYPED2 = 1
    _INTEGER_REDUNDANT_INFERRED = 1
    _INTEGER_REDUNDANT_INFERRED2 = 1
