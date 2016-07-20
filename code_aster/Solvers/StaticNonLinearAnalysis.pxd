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

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.Function.Function cimport FunctionPtr
from code_aster.LinearAlgebra.LinearSolver cimport LinearSolverPtr
from code_aster.Loads.KinematicsLoad cimport KinematicsLoadPtr
from code_aster.Loads.MechanicalLoad cimport GenericMechanicalLoadPtr
from code_aster.Materials.MaterialOnMesh cimport MaterialOnMeshPtr
from code_aster.Modeling.Model cimport ModelPtr
from code_aster.NonLinear.Behaviour cimport BehaviourPtr
from code_aster.NonLinear.Driving cimport DrivingPtr
from code_aster.NonLinear.LineSearchMethod cimport LineSearchMethodPtr
from code_aster.NonLinear.NonLinearMethod cimport NonLinearMethodPtr
from code_aster.NonLinear.State cimport StatePtr
from code_aster.Results.ResultsContainer cimport ResultsContainerPtr
from code_aster.Studies.TimeStepManager cimport TimeStepManagerPtr


cdef extern from "Solvers/StaticNonLinearAnalysis.h":

    cdef cppclass StaticNonLinearAnalysisInstance:

        StaticNonLinearAnalysisInstance()
        ResultsContainerPtr execute()
        void addBehaviourOnElements( BehaviourPtr& curBehaviour, string nameOfGroup ) except+
        void setNonLinearMethod( NonLinearMethodPtr& curNonLinearMethod )
        void setLineSearchMethod( LineSearchMethodPtr& curLineSearchMethod )
        void setMaterialOnMesh( MaterialOnMeshPtr& curMatOnMesh )
        void setSupportModel( ModelPtr& curModel )
        void setLinearSolver( LinearSolverPtr& curSolver )
        void setInitialState( StatePtr& curState )
        void setLoadStepManager( TimeStepManagerPtr& curTimeStepManager )
        void setDriving( DrivingPtr& curDriving )
        void addStandardExcitation(  GenericMechanicalLoadPtr& currentLoad );
        void addStandardScaledExcitation( GenericMechanicalLoadPtr& currentLoad,  FunctionPtr& scalF );
        void addStandardExcitation(  KinematicsLoadPtr& currentLoad ); 
        void addStandardScaledExcitation(  KinematicsLoadPtr& currentLoad,  FunctionPtr& scalF );
        void addDrivenExcitation(  GenericMechanicalLoadPtr& currentLoad ); 
        void addExcitationOnUpdatedGeometry(  GenericMechanicalLoadPtr& currentLoad ); 
        void addScaledExcitationOnUpdatedGeometry(  GenericMechanicalLoadPtr& currentLoad, FunctionPtr& scalF );
        void addIncrementalDirichletExcitation(  GenericMechanicalLoadPtr& currentLoad ); 
        void addIncrementalDirichletScaledExcitation(  GenericMechanicalLoadPtr& currentLoad, FunctionPtr& scalF );
        const string getType()

    cdef cppclass StaticNonLinearAnalysisPtr:

        StaticNonLinearAnalysisPtr( StaticNonLinearAnalysisPtr& )
        StaticNonLinearAnalysisPtr( StaticNonLinearAnalysisInstance * )
        StaticNonLinearAnalysisInstance* get()


#### StaticNonLinearAnalysis

cdef class StaticNonLinearAnalysis( DataStructure ):
    cdef StaticNonLinearAnalysisPtr* _cptr
    cdef set( self, StaticNonLinearAnalysisPtr other )
    cdef StaticNonLinearAnalysisPtr* getPtr( self )
    cdef StaticNonLinearAnalysisInstance* getInstance( self )
