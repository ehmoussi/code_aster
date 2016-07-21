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
from code_aster.LinearAlgebra.LinearSolver cimport LinearSolver
from code_aster.Function.Function cimport Function 
from code_aster.Loads.KinematicsLoad cimport KinematicsLoad
from code_aster.Loads.MechanicalLoad cimport GenericMechanicalLoad
from code_aster.NonLinear.Behaviour cimport Behaviour
from code_aster.NonLinear.Driving cimport Driving 
from code_aster.NonLinear.LineSearchMethod cimport LineSearchMethod
from code_aster.NonLinear.NonLinearMethod cimport NonLinearMethod
from code_aster.NonLinear.State cimport State
from code_aster.Materials.MaterialOnMesh cimport MaterialOnMesh
from code_aster.Modeling.Model cimport Model
from code_aster.Results.ResultsContainer cimport ResultsContainer, ResultsContainerPtr
from code_aster.Results.NonLinearEvolutionContainer cimport NonLinearEvolutionContainer
from code_aster.Studies.TimeStepManager cimport TimeStepManager


cdef class StaticNonLinearAnalysis( DataStructure ):

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

    def execute( self ):
        """Solve the problem"""
        results = NonLinearEvolutionContainer()
        results.set( <ResultsContainerPtr>(self.getInstance().execute() ))
        return results

    def addBehaviourOnElements( self, Behaviour curBehaviour, string nameOfGroup = ""  ):
        """Set a nonlinear behaviour on a group of elements """
        self.getInstance().addBehaviourOnElements( deref( curBehaviour.getPtr() ), nameOfGroup )

    def setNonLinearMethod( self, NonLinearMethod curNonLinearMethod ):
        """Set the nonlinear method """
        self.getInstance().setNonLinearMethod( deref( curNonLinearMethod.getPtr() ) )

    def setLinearSolver( self, LinearSolver curLinearSolver ):
        """Set the linear solver """
        self.getInstance().setLinearSolver( deref( curLinearSolver.getPtr() ) )

    def setInitialState( self, State curState ):
        """Set the initial state of the analysis """
        self.getInstance().setInitialState( deref( curState.getPtr() ) )

    def setLineSearchMethod( self, LineSearchMethod curLineSearchMethod ):
        """Set the linesearch method """
        self.getInstance().setLineSearchMethod( deref( curLineSearchMethod.getPtr() ) )

    def setMaterialOnMesh( self, MaterialOnMesh curMatOnMesh ):
        """Set the base elementary matrix used to build the assembly matrix"""
        self.getInstance().setMaterialOnMesh( deref( curMatOnMesh.getPtr() ) )

    def setLoadStepManager( self, TimeStepManager curTimeStepManager ):
        """Set the base elementary matrix used to build the assembly matrix"""
        self.getInstance().setLoadStepManager( deref( curTimeStepManager.getPtr() ) )

    def setSupportModel( self, Model curModel ):
        """Set the base elementary matrix used to build the assembly matrix"""
        self.getInstance().setSupportModel( deref( curModel.getPtr() ) )

    def setDriving( self, Driving curDriving ) :
        """Set the driving method """
        self.getInstance().setDriving( deref( curDriving.getPtr() ) )

    def addStandardExcitation( self,  currentLoad ):
        """ Add standard excitation """  
        cdef GenericMechanicalLoad mecaLoad
        cdef KinematicsLoad kineLoad
        if ( isinstance( currentLoad, GenericMechanicalLoad )):
            mecaLoad = currentLoad
            self.getInstance().addStandardExcitation( deref( mecaLoad.getPtr() ) )
        if ( isinstance( currentLoad, KinematicsLoad )):
            kineLoad = currentLoad
            self.getInstance().addStandardExcitation( deref( kineLoad.getPtr() ) )
    
    def addStandardScaledExcitation( self, currentLoad,  Function scalF ):
        """ Add standard excitation, with a scaling time function """ 
        cdef GenericMechanicalLoad mecaLoad
        cdef KinematicsLoad kineLoad
        if ( isinstance( currentLoad, GenericMechanicalLoad )):
            mecaLoad = currentLoad
            self.getInstance().addStandardScaledExcitation( deref( mecaLoad.getPtr() ), deref( scalF.getPtr() )  )
        if ( isinstance( currentLoad, KinematicsLoad )):
            kineLoad = currentLoad
            self.getInstance().addStandardScaledExcitation( deref( kineLoad.getPtr() ), deref( scalF.getPtr() ) )

    def addDrivenExcitation( self, GenericMechanicalLoad currentLoad ):
        """ Add driven excitation """
        self.getInstance().addDrivenExcitation(  deref( currentLoad.getPtr() ) )

    def addExcitationOnUpdatedGeometry( self, GenericMechanicalLoad currentLoad ):
        """ Add excitation on updated geometry """ 
        self.getInstance().addExcitationOnUpdatedGeometry( deref( currentLoad.getPtr() ) )

    def addScaledExcitationOnUpdatedGeometry( self, GenericMechanicalLoad currentLoad, Function scalF ):
        """ Add scaled excitation on updated geometry, with a scaling time function """
        self.getInstance().addScaledExcitationOnUpdatedGeometry( deref( currentLoad.getPtr() ),  deref( scalF.getPtr() )  )

    def addIncrementalDirichletExcitation(  self,GenericMechanicalLoad currentLoad ):
        """ Add incremental Dirichlet excitation """
        self.getInstance().addIncrementalDirichletExcitation( deref( currentLoad.getPtr() ) )

    def addIncrementalDirichletScaledExcitation( self, GenericMechanicalLoad currentLoad, Function scalF ): 
        """ Add incremental Dirichlet excitation, with a scaling time function """
        self.getInstance().addIncrementalDirichletScaledExcitation(  deref( currentLoad.getPtr() ),  deref( scalF.getPtr() )  )
