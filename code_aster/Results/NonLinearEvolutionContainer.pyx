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
from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDouble

#### NonLinearEvolutionContainer

cdef class NonLinearEvolutionContainer:
    """Python wrapper on the C++ NonLinearEvolutionContainer Object"""

    def __cinit__( self, bint init = True ):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new NonLinearEvolutionContainerPtr( new NonLinearEvolutionContainerInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, NonLinearEvolutionContainerPtr other ):
        """Point to an existing object"""
        self._cptr = new NonLinearEvolutionContainerPtr( other )

    cdef NonLinearEvolutionContainerPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef NonLinearEvolutionContainerInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

    def getRealFieldOnNodes( self, name, rank ):
        """Get a real FieldOnNodes from name and rank"""
        returnField = FieldOnNodesDouble()
        returnField.set( self.getInstance().getRealFieldOnNodes( name, rank ) )
        return returnField

    def printMedFile( self, name ):
        """Print MED file from NonLinearEvolutionContainer"""
        return self.getInstance().printMedFile( name )
