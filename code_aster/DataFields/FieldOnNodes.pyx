# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

from libcpp.string cimport string
from cython.operator cimport dereference as deref

from cFieldOnNodes cimport cFieldOnNodesDouble


cdef class FieldOnNodesDouble:
    """Python wrapper on the C++ FieldOnNodes object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        self._cptr = new cFieldOnNodesDouble( )

    cdef copy( self, cFieldOnNodesDouble& other ):
        """Refer to an existing C++ object"""
        self._cptr.copy( other )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr:
            del self._cptr

    def __getitem__( self, i ):
        """Return the value at the given index"""
        inst = self._cptr.getInstance()
        cdef double val = deref(inst)[i]
        return val

    def isEmpty( self ):
        """Tell if the object is empty"""
        return self._cptr.isEmpty()
