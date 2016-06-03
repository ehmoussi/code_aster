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

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.LinearAlgebra.AssemblyMatrix cimport AssemblyMatrixDouble
from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDouble


cdef class LinearSolver( DataStructure ):
    """Python wrapper on the C++ LinearSolver Object"""

    def __cinit__( self, LinearSolverEnum curLinSolv, Renumbering curRenum,
                   bint init = True ):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new LinearSolverPtr( new LinearSolverInstance(curLinSolv, curRenum) )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, LinearSolverPtr other ):
        """Point to an existing object"""
        self._cptr = new LinearSolverPtr( other )

    cdef LinearSolverPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef LinearSolverInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def solveDoubleLinearSystem( self, AssemblyMatrixDouble currentMatrix, FieldOnNodesDouble currentRHS ):
        """Assembly elementary vector"""
        result = FieldOnNodesDouble()
        result.set( self.getInstance().solveDoubleLinearSystem( deref( currentMatrix.getPtr() ),
                                                                deref( currentRHS.getPtr() ) ) )
        return result
