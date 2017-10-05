def my_function(arg1, arg2):
    """What the function does.

    May add more detailed informations. Add a new line to start a
    new paragraph. Do not write lines longer than 80 chars following the
    `PEP8`_ recommendation.

    Example of a reference to internal objects
    :py:class:`code_aster.Objects.Mesh` with it full name or
    :py:class:`~code_aster.Objects.Mesh` with its *basename*.

    .. _PEP8: https://www.python.org/dev/peps/pep-0008/

    Arguments:
        arg1 (int): A description of the argument. If needed, it may be
            written on several lines that must be indented before next
            argument.
        arg2 (list[str]): List of strings for the second argument.

    Returns:
        dict: This function returns a *dict* object.
        There is always only one result, eventually it's a tuple. That's
        why the continued lines are not indented here.
     """
    return dict(a=arg1 + len(arg2))
