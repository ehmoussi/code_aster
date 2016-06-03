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
from code_aster.Modeling.Model cimport Model
from code_aster.LinearAlgebra.ElementaryMatrix cimport ElementaryMatrix
from code_aster.LinearAlgebra.LinearSolver cimport LinearSolver
from code_aster.Loads.MechanicalLoad cimport GenericMechanicalLoad
from code_aster.Loads.KinematicsLoad cimport KinematicsLoad

#### DOFNumbering

cdef class DOFNumbering( DataStructure ):
    """Python wrapper on the C++ DOFNumbering Object"""

    def __cinit__( self, bint init = True ):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new DOFNumberingPtr( new DOFNumberingInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, DOFNumberingPtr other ):
        """Point to an existing object"""
        self._cptr = new DOFNumberingPtr( other )

    cdef DOFNumberingPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DOFNumberingInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addKinematicsLoad( self, KinematicsLoad load ):
        """Add a mechanical load"""
        self.getInstance().addKinematicsLoad( deref( load.getPtr() ) )

    def addMechanicalLoad( self, GenericMechanicalLoad load ):
        """Add a mechanical load"""
        self.getInstance().addMechanicalLoad( deref( load.getPtr() ) )

    def computeNumerotation( self ):
        """Compute the numerotation"""
        return self.getInstance().computeNumerotation()

    def setElementaryMatrix( self, ElementaryMatrix curElemMat ):
        """Set the elementary matrix"""
        self.getInstance().setElementaryMatrix( deref( curElemMat.getPtr() ) )

    def setLinearSolver( self, LinearSolver curLinSolv ):
        """Set the linear solver"""
        self.getInstance().setLinearSolver( deref( curLinSolv.getPtr() ) )

    def setSupportModel( self, Model curModel ):
        """Set the support model"""
        self.getInstance().setSupportModel( deref( curModel.getPtr() ) )

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )
