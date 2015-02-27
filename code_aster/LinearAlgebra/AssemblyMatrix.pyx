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

from code_aster.Loads.KinematicsLoad cimport KinematicsLoad
from code_aster.LinearAlgebra.DOFNumbering cimport DOFNumbering, ForwardDOFNumberingPtr
from code_aster.LinearAlgebra.ElementaryMatrix cimport ElementaryMatrix


cdef class AssemblyMatrixDouble:

    """Python wrapper on the C++ AssemblyMatrixDouble object"""

    def __cinit__( self, bint init = True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new AssemblyMatrixDoublePtr( new AssemblyMatrixDoubleInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, AssemblyMatrixDoublePtr other ):
        """Point to an existing object"""
        # set must be subclassed if it is necessary
        self._cptr = new AssemblyMatrixDoublePtr( other )

    cdef AssemblyMatrixDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef AssemblyMatrixDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addKinematicsLoad( self, KinematicsLoad currentLoad ):
        """ """
        self.getInstance().addKinematicsLoad( deref( currentLoad.getPtr() ) )

    def build( self ):
        """Build the assembly matrix"""
        return self.getInstance().build()

    def factorization( self ):
        """Factorization of the matrix"""
        return self.getInstance().factorization()

    def setDOFNumbering( self, DOFNumbering curDOFNumber ):
        """Set the degree of freedom numbering"""
        test = new ForwardDOFNumberingPtr( deref( curDOFNumber.getPtr() ) )
        self.getInstance().setDOFNumbering( deref( test ) )

    def setElementaryMatrix( self, ElementaryMatrix currentElemMatrix ):
        """Set the base elementary matrix used to build the assembly matrix"""
        self.getInstance().setElementaryMatrix( deref( currentElemMatrix.getPtr() ) )

    def debugPrint( self, int logicalUnit = 6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )
