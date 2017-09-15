# coding: utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: mathieu.courtois@edf.fr

"""
This modules will help for transitional features.
"""

from functools import wraps
from warnings import simplefilter, warn


def deprecated(replaced=True):
    """Decorator to mark a function as deprecated.

    It will do nothing at the beginning of the transitional phase.
    Then, it will warn about deprecated functions. And finally, it will raise
    an error to remove all of them.

    Arguments:
        replaced (bool): Tell if the decorated function will be replaced
            or if it will be just removed (default: *True*, replaced).
    """
    def deprecated_decorator(func):
        """Raw decorator"""
        @wraps(func)
        def wrapper(*args, **kwargs):
            """Wrapper"""
            # phase 1: does nothing but keep in mind that it will be removed.
            # phase 2: warn about deprecated functions.
            msg = ("This feature is obsoleted, {0!r} will be "
                   "removed in the future.")
            if replaced:
                msg = ("This feature has a new implementation, {0!r} will be "
                       "removed in the future.")
            warn(msg.format(func.__name__),
                 DeprecationWarning, stacklevel=2)
            return func(*args, **kwargs)
        return wrapper
    return deprecated_decorator
