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
from code_aster.Loads.MechanicalLoad cimport GenericMechanicalLoad
from code_aster.Results.ResultsContainer cimport ResultsContainer
from code_aster.NonLinear.NonLinearMethod cimport NonLinearMethod
from code_aster.Materials.MaterialOnMesh cimport MaterialOnMesh
from code_aster.Modeling.Model cimport Model


cdef class StaticNonLinearAnalysis:

    """Python wrapper on the C++ StaticNonLinearAnalysis object"""

    def __cinit__( self, bint init = True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new StaticNonLinearAnalysisPtr( new StaticNonLinearAnalysisInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, StaticNonLinearAnalysisPtr other ):
        """Point to an existing object"""
        # set must be subclassed if it is necessary
        self._cptr = new StaticNonLinearAnalysisPtr( other )

    cdef StaticNonLinearAnalysisPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef StaticNonLinearAnalysisInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addKinematicsLoad( self, KinematicsLoad currentLoad ):
        """Add a Kinematics Load"""
        self.getInstance().addKinematicsLoad( deref( currentLoad.getPtr() ) )

    def addMechanicalLoad( self, GenericMechanicalLoad currentLoad ):
        """Add a Mechanical Load"""
        self.getInstance().addMechanicalLoad( deref( currentLoad.getPtr() ) )

    def execute_op70( self ):
        """Solve the problem"""
        self.getInstance().execute_op70()

    def execute( self ):
        """Solve the problem"""
        results = ResultsContainer()
        results.set( self.getInstance().execute() )
        return results
    
    def setNonLinearMethod( self, NonLinearMethod curNonLinearMethod ):
        """Set the nonlinear method """
        self.getInstance().setNonLinearMethod( deref( curNonLinearMethod.getPtr() ) )

    def setMaterialOnMesh( self, MaterialOnMesh curMatOnMesh ):
        """Set the base elementary matrix used to build the assembly matrix"""
        self.getInstance().setMaterialOnMesh( deref( curMatOnMesh.getPtr() ) )

    def setSupportModel( self, Model curModel ):
        """Set the base elementary matrix used to build the assembly matrix"""
        self.getInstance().setSupportModel( deref( curModel.getPtr() ) )
