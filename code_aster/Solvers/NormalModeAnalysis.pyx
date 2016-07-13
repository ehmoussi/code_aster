# coding: utf-8

# Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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
from code_aster.Results.MechanicalModeContainer cimport MechanicalModeContainer
from code_aster.Results.ResultsContainer cimport ResultsContainerPtr


cdef class NormalModeAnalysis( DataStructure ):

    """Python wrapper on the C++ NormalModeAnalysis object"""

    def __cinit__( self, bint init = True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new NormalModeAnalysisPtr( new NormalModeAnalysisInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, NormalModeAnalysisPtr other ):
        """Point to an existing object"""
        # set must be subclassed if it is necessary
        self._cptr = new NormalModeAnalysisPtr( other )

    cdef NormalModeAnalysisPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef NormalModeAnalysisInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def execute( self ):
        """Solve the problem"""
        results = MechanicalModeContainer()
        results.set( <ResultsContainerPtr>self.getInstance().execute() )
        return results

    def setMassMatrix( self, AssemblyMatrixDouble matr ):
        """Set the mass matrix"""
        self.getInstance().setMassMatrix( deref( matr.getPtr() ) )

    def setNumberOfFrequencies( self, number ):
        """Solve the number of frequencies to compute"""
        self.getInstance().setNumberOfFrequencies( number )

    def setRigidityMatrix( self, AssemblyMatrixDouble matr ):
        """Set the rigidity matrix"""
        self.getInstance().setRigidityMatrix( deref( matr.getPtr() ) )
