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
:py:mod:`base_utils` --- General purpose utilities
**************************************************

This modules gives some basic utilities.
"""

import sys
from array import array
from decimal import Decimal
from functools import wraps

import numpy


def no_new_attributes(wrapped_setattr):
    """ Raise an error on attempts to add a new attribute, while
        allowing existing attributes to be set to new values.

        Taken from ?
        'Python Cookbook' by Alex Martelli, Anna Ravenscroft, David Ascher,
        ?6.3. 'Restricting Attribute Setting'
    """
    def __setattr__(self, name, value):
        if hasattr(self, name): # not a new attribute, allow setting
            wrapped_setattr(self, name, value)
        else:
            message = "Can't add attribute %r to %s" % (name, self)
            raise AttributeError(message)

    return __setattr__

def import_object(uri):
    """Load and return a python object (class, function...).
    Its `uri` looks like "mainpkg.subpkg.module.object", this means
    that "mainpkg.subpkg.module" is imported and "object" is
    the object to return.

    Arguments:
        uri (str): Path to the object to import.

    Returns:
        object: Imported object.
    """
    path = uri.split('.')
    modname = '.'.join(path[:-1])
    if len(modname) == 0:
        raise ImportError("invalid uri: {0}".format(uri))
    mod = obj = '?'
    objname = path[-1]
    try:
        __import__(modname)
        mod = sys.modules[modname]
    except ImportError as err:
        raise ImportError("can not import module : {0} ({1})"
                          .format(modname, str(err)))
    try:
        obj = getattr(mod, objname)
    except AttributeError as err:
        raise AttributeError("object ({0}) not found in module {1!r}. "
                             "Module content is: {2}"
                             .format(objname, modname, tuple(dir(mod))))
    return obj

def force_list(values):
    """Ensure `values` is iterable (list, tuple, array...) and return it as
    a list."""
    if not value_is_sequence(values):
        values = [values]
    return list(values)

def force_tuple(values):
    """Ensure `values` is iterable (list, tuple, array...) and return it as
    a tuple.
    """
    return tuple(force_list(values))

def value_is_sequence(value):
    """Tell if *value* is a valid object if max > 1."""
    return isinstance(value, (list, tuple, array, numpy.ndarray))

def is_int(obj, onvalue=False):
    """Tell if an object is an integer.

    Arguments:
        obj (misc): Object to be tested.
        onvalue (bool, optional): If *onvalue* is True, accept a float number
            that is equal to its integer part. If *False*, acceptance is
            only based on the object type.
    """
    return (isinstance(obj, (int, numpy.integer))
            or (onvalue and is_float(obj) and obj == int(obj)))

def is_float(obj):
    """Tell if an object is a float number."""
    return isinstance(obj, (float, Decimal, numpy.float))

def is_float_or_int(obj):
    """Tell if an object is a float or an integer."""
    return is_float(obj) or is_int(obj)

def is_complex(obj):
    """Tell if an object is a complex number."""
    if isinstance(obj, (list, tuple)) and len(obj) == 3 \
        and obj[0] in ('RI', 'MP') and is_float_or_int(obj[1]) \
        and is_float_or_int(obj[2]):
        return True
    return isinstance(obj, complex)

def is_number(obj):
    """Tell if an object is a number."""
    return is_float_or_int(obj) or is_complex(obj)

def is_str(obj):
    """Tell if an object is a string."""
    return isinstance(obj, str)

def is_sequence(obj):
    """Is a sequence (allow iteration, not a string)?"""
    return isinstance(obj, (list, tuple, numpy.ndarray))

def array_to_list(obj):
    """Convert an object to a list if possible (using `tolist()`) or keep it
    unchanged otherwise.

    Arguments:
        obj (misc): Object to convert.

    Returns:
        misc: Object unchanged or a list.
    """
    try:
        return obj.tolist()
    except AttributeError:
        return obj

def accept_array(func):
    """Decorator that automatically converts numpy arrays to lists.

    Needed to pass an array as argument to a boost method.
    """
    @wraps(func)
    def wrapper(*args, **kwargs):
        """Wrapper"""
        args = [array_to_list(i) for i in args]
        return func(*args, **kwargs)
    return wrapper


class Singleton(type):
    """Singleton implementation in python (Metaclass)."""
    # add _singleton_id attribute to the subclasses to be independant of import
    # path used
    __inst = {}

    def __call__(cls, *args, **kws):
        cls_id = getattr(cls, '_singleton_id', cls)
        if cls_id not in cls.__inst:
            cls.__inst[cls_id] = super(Singleton, cls).__call__(*args, **kws)
        return cls.__inst[cls_id]
