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
This modules gives some basic utilities.
"""

from functools import wraps
import sys

import numpy


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


def force_list(obj):
    """Return `obj` if it's an instance of list or tuple, [obj,] otherwise.
    """
    if not isinstance(obj, (list, tuple)):
        obj = [obj, ]
    return list(obj)


def ndarray_to_list(obj):
    """Convert an object to a list if it is a `numpy.ndarray` or keep it
    unchanged otherwise.

    Arguments:
        obj (misc): Object to convert.

    Returns:
        misc: Object unchanged or a list.
    """
    return list(obj) if isinstance(obj, numpy.ndarray) else obj


def accept_ndarray(func):
    """Decorator that automatically converts numpy arrays to lists."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        """Wrapper"""
        args = [ndarray_to_list(i) for i in args]
        return func(*args, **kwargs)
    return wrapper


class Singleton(object):
    """Singleton implementation in python."""
    # add _singleton_id attribute to the class to be independant of import
    # path used
    __inst = {}

    def __new__(cls, *args, **kargs):
        cls_id = getattr(cls, '_singleton_id', cls)
        if Singleton.__inst.get(cls_id) is None:
            Singleton.__inst[cls_id] = object.__new__(cls)
        return Singleton.__inst[cls_id]
