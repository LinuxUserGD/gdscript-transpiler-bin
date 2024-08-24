class_name = "Float_notation"


def test():
    case  # The following ing-point notations are all valid:
    print(is_equal_approx(123.0, 123))
    print(is_equal_approx(0.123, 0.123))
    print(is_equal_approx(0.123e4, 1230))
    print(is_equal_approx(123.0e4, 1.23e6))
    print(is_equal_approx(0.123e-1, 0.0123))
    print(is_equal_approx(123.0e-1, 12.3))
    # Same as above, but with negative numbers.
    print(is_equal_approx(-123.0, -123))
    print(is_equal_approx(-0.123, -0.123))
    print(is_equal_approx(-0.123e4, -1230))
    print(is_equal_approx(-123.0e4, -1.23e6))
    print(is_equal_approx(-0.123e-1, -0.0123))
    print(is_equal_approx(-123.0e-1, -12.3))
    # Same as above, but with explicit positive numbers (which is redundant).
    print(is_equal_approx(+123.0, +123))
    print(is_equal_approx(+0.123, +0.123))
    print(is_equal_approx(+0.123e4, +1230))
    print(is_equal_approx(+123.0e4, +1.23e6))
    print(is_equal_approx(+0.123e-1, +0.0123))
    print(is_equal_approx(+123.0e-1, +12.3))


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
