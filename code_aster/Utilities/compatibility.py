# coding: utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

import sys
import warnings
from functools import wraps
from warnings import showwarning, warn

from .base_utils import array_to_list, force_list


def warn_to_stdout(message, category, filename, lineno, file=None, line=None):
    """Same as `showwarning` but on stdout"""
    return showwarning(message, category, filename, lineno,
                       file=sys.stdout, line=line)

warnings.showwarning = warn_to_stdout


def deprecate(feature, case=1, help=None, level=4):
    """Deprecate a feature, emit a deprecation warning depending on the case.

    Arguments:
        feature (str): Deprecated feature.
        case (int):
            Case 1: the feature still works but it will be removed.
            Case 2: the feature does nothing, it has been removed.
            Case 3: the feature still works but has a new implementation.
            Case 4: the feature does nothing but has a new implementation.
        help (str): Additional help message, should be present for case 3.
        level (int): Level of the caller in the stack.
    """
    if case == 1:
        msg = ("This feature is obsoleted, {0!r} will be "
               "removed in the future.")
    elif case == 2:
        msg = "This feature is obsoleted, {0!r} has been removed."
    elif case == 3:
        msg = ("This feature has a new implementation, {0!r} will be "
               "removed in the future.")
    elif case == 4:
        msg = ("This feature has a new implementation, {0!r} has been "
               "removed.")
    else:
        msg = "This feature is obsoleted: {0!r}"
    if help:
        msg += " " + help
    warn(msg.format(feature), DeprecationWarning, stacklevel=level)


def deprecated(case=1, help=None):
    """Decorator to mark a function as deprecated.

    It will do nothing at the beginning of the transitional phase.
    Then, it will warn about deprecated functions. And finally, it will raise
    an error to remove all of them.

    Arguments:
        case (int):
            Case 1: the feature still works but it will be removed.
            Case 2: the feature does nothing, it has been removed.
            Case 3: the feature still works but has a new implementation.
            Case 4: the feature does nothing but has a new implementation.
        help (str): Additional help message.
    """
    def deprecated_decorator(func):
        """Raw decorator"""
        @wraps(func)
        def wrapper(*args, **kwargs):
            """Wrapper"""
            deprecate(func.__name__, case, help, level=3)
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
        if factor_keyword not in keywords:
            return
        fact = force_list(keywords[factor_keyword])
        for occ in fact:
            compat_listr8(occ, None, list_keyword, float_keyword)
    else:
        try:
            keywords[float_keyword] = array_to_list(keywords.pop(list_keyword))
        except KeyError:
            pass


def _if_exists(keywords, factor_keyword, simple_keyword, callback):
    """Call a *callback* if the couple *(factor_keyword, simple_keyword)* is
    found in the user's keywords.

    Arguments:
        keywords (dict): Dict of keywords passed to a command, changed in place.
        factor_keyword (str): Name of the factor keyword or an empty string if
            the keywords are at the top level.
        simple_keyword (str): Name of the simple keyword. It it is an empty
            string the factor keyword is entirely removed.
        callback (function): Callback function with signature *(container, key)*
            where *(container, key)* is *(keywords, factor_keyword)* if
            *factor_keyword* is empty or *(factor keyword dict, simple_keyword)*
            otherwise.
    """
    if factor_keyword.strip():
        if factor_keyword not in keywords:
            return
        if simple_keyword.strip():
            fact = force_list(keywords[factor_keyword])
            for occ in fact:
                if simple_keyword in occ:
                    callback(occ, simple_keyword)
            return
        callback(keywords, factor_keyword)
    elif simple_keyword.strip():
        if simple_keyword in keywords:
            callback(keywords, simple_keyword)


def _if_not_exists(keywords, factor_keyword, simple_keyword, callback):
    """Call a *callback* if the couple *(factor_keyword, simple_keyword)* is
    **not found** in the user's keywords.

    Arguments:
        keywords (dict): Dict of keywords passed to a command, changed in place.
        factor_keyword (str): Name of the factor keyword or an empty string if
            the keywords are at the top level.
        simple_keyword (str): Name of the simple keyword. It it is an empty
            string the factor keyword is entirely removed.
        callback (function): Callback function with signature *(container, key)*
            where *(container, key)* is *(keywords, factor_keyword)* if
            *factor_keyword* is empty or *(factor keyword dict, simple_keyword)*
            otherwise.
    """
    if factor_keyword.strip():
        if factor_keyword not in keywords:
            callback(keywords, factor_keyword)
            return
        if simple_keyword.strip():
            fact = force_list(keywords[factor_keyword])
            for occ in fact:
                if simple_keyword not in occ:
                    callback(occ, simple_keyword)
    elif simple_keyword.strip():
        if simple_keyword not in keywords:
            callback(keywords, simple_keyword)


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
    def _warn(container, key):
        if not warning:
            return
        msg = ("This keyword is not yet supported and are currently "
               "removed: {0}{1}{2}")
        sep = "/" if factor_keyword.strip() and simple_keyword.strip() else ""
        warn(msg.format(factor_keyword, sep, simple_keyword))
        del container[key]

    _if_exists(keywords, factor_keyword, simple_keyword, _warn)


def unsupported(keywords, factor_keyword, simple_keyword, warning=False):
    """Raises a *NotImplementedError* exception or a *SyntaxWarning* if
    the couple *(factor_keyword, simple_keyword)* exists in the user's keywords.

    Arguments:
        keywords (dict): Dict of keywords passed to a command, changed in place.
        factor_keyword (str): Name of the factor keyword or an empty string if
            the keywords are at the top level.
        simple_keyword (str): Name of the simple keyword. It it is an empty
            string the factor keyword is entirely removed.
        warning (bool): If *True* *DeprecationWarning* is emitted. Otherwise
            a *NotImplementedError* is raised.
    """
    def _raise(container, key):
        msg = ("This keyword is not yet supported: {0}{1}{2}")
        sep = "/" if factor_keyword.strip() and simple_keyword.strip() else ""
        text_msg = msg.format(factor_keyword, sep, simple_keyword)
        if not warning:
            raise NotImplementedError(text_msg)
        else:
            warn(text_msg, SyntaxWarning)

    _if_exists(keywords, factor_keyword, simple_keyword, _raise)


def required(keywords, factor_keyword, simple_keyword):
    """Raises a *NotImplementedError* exception if the couple
    *(factor_keyword, simple_keyword)* **does not** exists in the
    user's keywords.

    Arguments:
        keywords (dict): Dict of keywords passed to a command, changed in place.
        factor_keyword (str): Name of the factor keyword or an empty string if
            the keywords are at the top level.
        simple_keyword (str): Name of the simple keyword. It it is an empty
            string the factor keyword is entirely removed.
    """
    def _raise(container, key):
        msg = ("This keyword is currently required: {0}{1}{2}")
        sep = "/" if factor_keyword.strip() and simple_keyword.strip() else ""
        text_msg = msg.format(factor_keyword, sep, simple_keyword)
        raise NotImplementedError(text_msg)

    _if_not_exists(keywords, factor_keyword, simple_keyword, _raise)
