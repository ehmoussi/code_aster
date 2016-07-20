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

from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDouble
from code_aster.Results.ResultsContainer cimport ResultsContainer
from code_aster.Results.NonLinearEvolutionContainer cimport NonLinearEvolutionContainer 

cdef class State:
    """Python wrapper on the C++ State Object"""

    def __cinit__( self, int index = 0 , double step = 0.0 ):
        """Initialization: stores the pointer to the C++ object"""
        self._cptr = new StatePtr( new StateInstance( index, step ) )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, StatePtr other ):
        """Point to an existing object"""
        self._cptr = new StatePtr( other )

    cdef StatePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef StateInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def setFromNonLinearEvolution( self, ResultsContainer evol_noli, double sourceStep, precision = 1.E-06 ):
         """ Define current step from a previous nonlinear analysis"""
         self.getInstance().setFromNonLinearEvolution(  deref( <NonLinearEvolutionContainerPtr*>(evol_noli.getPtr())) , sourceStep, precision )

    def setFromNonLinearEvolution( self,  ResultsContainer evol_noli, int sourceIndex ):
         """ Define current state from a previous nonlinear analysis"""
         self.getInstance().setFromNonLinearEvolution(  deref( <NonLinearEvolutionContainerPtr*>(evol_noli.getPtr())), sourceIndex )

    def setCurrentStep ( self, double step ):
         """ Define the value of the current time or load step"""
         self.getInstance().setCurrentStep ( step )

    def setDisplacement ( self, FieldOnNodesDouble depl ): 
         """ Define displacement field of the current state"""
         self.getInstance().setDisplacement(  deref( depl.getPtr() ) ) 
