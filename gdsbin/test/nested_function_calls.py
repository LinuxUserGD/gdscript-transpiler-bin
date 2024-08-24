class_name = "Nested_function_calls"


def foo(x):
    return x + 1


def test():
    print(
        foo(
            foo(
                foo(
                    foo(
                        foo(
                            foo(
                                foo(
                                    foo(
                                        foo(
                                            foo(
                                                foo(
                                                    foo(
                                                        foo(
                                                            foo(
                                                                foo(
                                                                    foo(
                                                                        foo(
                                                                            foo(
                                                                                foo(
                                                                                    foo(
                                                                                        foo(
                                                                                            foo(
                                                                                                foo(
                                                                                                    foo(
                                                                                                        0
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )


def get_script():
    class Script:
        def get_global_name():
            return class_name

    return Script
