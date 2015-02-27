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

from code_aster.Loads.KinematicsLoad cimport KinematicsLoadPtr
from code_aster.Loads.MechanicalLoad cimport GenericMechanicalLoadPtr
from code_aster.Results.ResultsContainer cimport ResultsContainerPtr
from code_aster.LinearAlgebra.LinearSolver cimport LinearSolverPtr
from code_aster.Materials.MaterialOnMesh cimport MaterialOnMeshPtr
from code_aster.Modeling.Model cimport ModelPtr


cdef extern from "Solvers/StaticMechanicalSolver.h":

    cdef cppclass StaticMechanicalSolverInstance:

        StaticMechanicalSolverInstance()
        void addKinematicsLoad( KinematicsLoadPtr& currentLoad )
        void addMechanicalLoad( GenericMechanicalLoadPtr& currentLoad )
        ResultsContainerPtr execute()
        void setLinearSolver( LinearSolverPtr& curLinSolv )
        void setMaterialOnMesh( MaterialOnMeshPtr& curMatOnMesh )
        void setSupportModel( ModelPtr& curModel )
        const string getType()

    cdef cppclass StaticMechanicalSolverPtr:

        StaticMechanicalSolverPtr( StaticMechanicalSolverPtr& )
        StaticMechanicalSolverPtr( StaticMechanicalSolverInstance * )
        StaticMechanicalSolverInstance* get()


#### StaticMechanicalSolver

cdef class StaticMechanicalSolver:
    cdef StaticMechanicalSolverPtr* _cptr
    cdef set( self, StaticMechanicalSolverPtr other )
    cdef StaticMechanicalSolverPtr* getPtr( self )
    cdef StaticMechanicalSolverInstance* getInstance( self )
