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

cimport cCataBuilder


cdef class CataBuilder:

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        self._cptr = new cCataBuilder.CataBuilder()

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr:
            del self._cptr

    def run( self ):
        """Build the elements catalog"""
        self._cptr.run()
