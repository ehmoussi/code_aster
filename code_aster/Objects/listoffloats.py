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

# person_in_charge: mathieu.courtois@edf.fr
"""
:py:class:`ListOfFloats` --- List of floats
*******************************************
"""

import numpy as np

from libaster import ResultNaming
from ..Utilities import deprecated
from .datastructure_ext import DataStructure


class ListOfFloats(DataStructure):
    """Object that defines a list of float numbers as a *proxy* to a
    :py:class:`numpy.array`.
    """
    _array = _name = None

    def __init__(self):
        """Initialization"""
        self._name = ResultNaming.getNewResultName()
        self._array = np.array([])

    def getName(self):
        """Override :py:method:`code_aster.Objects.DataStructure.getName`."""
        return self._name

    def getType(self):
        """Override :py:method:`code_aster.Objects.DataStructure.getType`."""
        return "LISTR8"

    def debugPrint(self, unit):
        """Does nothing for this object."""

    def __getattr__(self, attr):
        """Returns the attribute of the underlying :py:class:`numpy.array`
        object if it does not exist."""
        return getattr(self._array, attr)

    def __len__(self):
        """Returns the number of values in the list.

        Returns:
            int: NUmber of values.
        """
        return len(self._array)

    def getValuesAsArray(self) :
        """Returns the values as a :py:class:`numpy.array`.

        Returns:
            list: The :py:class:`numpy.array` containing the values (by
                reference).
        """
        return self._array

    def getValues(self) :
        """Returns the values as a list.

        Returns:
            list: A Python *list* of the values.
        """
        return self._array.tolist()

    def setValues(self, values) :
        """Set new values for the list.

        If *values* is :py:class:`numpy.array` it is referenced (without making
        a copy).

        Arguments:
            values (list or numpy.array): New values as a Python *list* or as
                a 1D-:py:class:`numpy.array`.
        """
        if isinstance(values, np.ndarray):
            pass
        elif isinstance(values, (list, tuple, array)):
            values = np.array(values)
        else:
            raise TypeError("unsupported object: {0}".format(type(values)))
        if not np.issubdtype(values.dtype, float):
            raise TypeError("Only support float values, not: {0}"
                            .format(values.dtype))
        if len(values.shape) != 1:
            raise ValueError("Expecting unidimensional array, not: {0}"
                             .format(values.shape))
        self._array = values


    @deprecated(help="Use `getValues()` instead.")
    def Valeurs(self):
        return self.values()
