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
:py:mod:`compatibility` --- Manage compatibility with *legacy* version
**********************************************************************

This modules will help for transitional features.
It defines *decorators* or conversion functions for step by step migration
from *legacy* code_aster source code and C++ code_aster code.
"""

from functools import wraps
from warnings import simplefilter, warn

from .base_utils import array_to_list


def deprecated(replaced=True, help=None):
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
            if help:
                msg += " " + help
            warn(msg.format(func.__name__),
                 DeprecationWarning, stacklevel=2)
            return func(*args, **kwargs)
        return wrapper
    return deprecated_decorator


def compat_listr8(keywords, factor_keyword, list_keyword, float_keyword):
    """Pass values given to a keyword that expects a *listr8* to the similar
    keyword that takes a list of floats, eventually under a factor keyword.

    Arguments:
        keywords (dict): Dict of keywords passed to a command, changed in place.
        factor_keyword (str): Name of the factor keyword or an empty string if
            the keywords are at the top level.
        list_keyword (str): Name of the keyword that needs a *listr8*.
        float_keyword (str): Name of the keyword that takes a list of floats.
    """
    if factor_keyword and factor_keyword.strip():
        if not keywords.has_key(factor_keyword):
            return
        fact = keywords[factor_keyword]
        if not isinstance(fact, (list, tuple)):
            fact = [fact]
        for occ in fact:
            compat_listr8(occ, None, list_keyword, float_keyword)
    else:
        try:
            keywords[float_keyword] = array_to_list(keywords.pop(list_keyword))
        except KeyError:
            pass


def remove_keyword(keywords, factor_keyword, simple_keyword, warning=False):
    """Remove a couple *(factor_keyword, simple_keyword)* for the user's
    keywords.

    Arguments:
        keywords (dict): Dict of keywords passed to a command, changed in place.
        factor_keyword (str): Name of the factor keyword or an empty string if
            the keywords are at the top level.
        simple_keyword (str): Name of the simple keyword. It it is an empty
            string the factor keyword is entirely removed.
        warning (bool): If *True* a warning message is emitted.
    """
    def _warn():
        if not warning:
            return
        msg = ("These keywords is not yet supported: {0}{1}{2}")
        sep = "/" if simple_keyword and simple_keyword.strip() else ""
        warn(msg.format(factor_keyword, sep, simple_keyword))

    if factor_keyword and factor_keyword.strip():
        if not keywords.has_key(factor_keyword):
            return
        if simple_keyword and simple_keyword.strip():
            fact = keywords[factor_keyword]
            if fact.has_key(simple_keyword):
                _warn()
                del fact[simple_keyword]
            return
        _warn()
        del keywords[factor_keyword]
