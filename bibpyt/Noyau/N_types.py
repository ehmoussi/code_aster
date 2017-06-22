# coding=utf-8
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

# person_in_charge: mathieu.courtois at edf.fr

"""
   Ce module contient des fonctions utilitaires pour tester les types
"""

# eficas sentinel
try:
    import numpy as NP
    _np_arr = NP.ndarray
except ImportError:
    _np_arr = None

# use isinstance() instead of type() because objects returned from numpy arrays
# inherit from python scalars but are numpy.float64 or numpy.int32...


def is_int(obj):
    return isinstance(obj, int) or type(obj) is long


def is_float(obj):
    return isinstance(obj, float)


def is_complex(obj):
    return isinstance(obj, complex)

from decimal import Decimal


def is_float_or_int(obj):
    return is_float(obj) or is_int(obj) or isinstance(obj, Decimal)


def is_number(obj):
    return is_float_or_int(obj) or is_complex(obj)


def is_str(obj):
    return isinstance(obj, (str, unicode))


def is_list(obj):
    return type(obj) is list


def is_tuple(obj):
    return type(obj) is tuple


def is_array(obj):
    """a numpy array ?"""
    return type(obj) is _np_arr


def is_sequence(obj):
    """a sequence (allow iteration, not a string) ?"""
    return is_list(obj) or is_tuple(obj) or is_array(obj)


def is_assd(obj):
    from N_ASSD import ASSD
    return isinstance(obj, ASSD)


def force_list(obj):
    """Retourne `obj` si c'est une liste ou un tuple,
    sinon retourne [obj,] (en tant que list).
    """
    if not is_sequence(obj):
        obj = [obj, ]
    return list(obj)


def force_tuple(obj):
    """Return `obj` as a tuple."""
    return tuple(force_list(obj))

# backward compatibility
from warnings import warn


def is_enum(obj):
    """same as is_sequence"""
    warn("'is_enum' is deprecated, use 'is_sequence'",
         DeprecationWarning, stacklevel=2)
    return is_sequence(obj)
