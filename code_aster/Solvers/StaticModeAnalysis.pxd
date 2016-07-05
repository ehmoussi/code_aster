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
from libcpp.vector cimport vector
from code_aster.LinearAlgebra.AssemblyMatrix cimport AssemblyMatrixDoublePtr
from code_aster.LinearAlgebra.LinearSolver cimport LinearSolverPtr
from code_aster.Results.ResultsContainer cimport ResultsContainerPtr

cdef extern from "Solvers/StaticModeAnalysis.h":

    ctypedef vector[ string] VectorString
    ctypedef vector[ double] VectorDouble
    
    cdef cppclass StaticModeDeplInstance:
        StaticModeDeplInstance()
        void setAllLoc()
        void setAllCmp()
        void setMassMatrix( const AssemblyMatrixDoublePtr& currentMatrix ) 
        void setStiffMatrix( const AssemblyMatrixDoublePtr& currentMatrix )
        void setLinearSolver( const LinearSolverPtr& currentSolver )
        void WantedGrno(const VectorString listloc)
        void Unwantedcmp(const VectorString listcmp)
        void Wantedcmp(const VectorString listcmp)
        ResultsContainerPtr execute() except +
    

    cdef cppclass StaticModeDeplPtr:

        StaticModeDeplPtr( StaticModeDeplPtr& )
        StaticModeDeplPtr( StaticModeDeplInstance* )
        StaticModeDeplInstance* get()
        
    cdef cppclass StaticModeForcInstance:
        StaticModeForcInstance()
        void setAllLoc()
        void setAllCmp()
        void setMassMatrix( const AssemblyMatrixDoublePtr& currentMatrix ) 
        void setStiffMatrix( const AssemblyMatrixDoublePtr& currentMatrix )
        void setLinearSolver( const LinearSolverPtr& currentSolver )
        void WantedGrno(const VectorString listloc)
        void Unwantedcmp(const VectorString listcmp)
        void Wantedcmp(const VectorString listcmp)
        ResultsContainerPtr execute() except +
    

    cdef cppclass StaticModeForcPtr:

        StaticModeForcPtr( StaticModeForcPtr& )
        StaticModeForcPtr( StaticModeForcInstance* )
        StaticModeForcInstance* get()
        
    cdef cppclass StaticModePseudoInstance:
        StaticModePseudoInstance()
        void setAllLoc()
        void setAllCmp()
        void setMassMatrix( const AssemblyMatrixDoublePtr& currentMatrix ) 
        void setStiffMatrix( const AssemblyMatrixDoublePtr& currentMatrix )
        void setLinearSolver( const LinearSolverPtr& currentSolver )
        void WantedGrno(const VectorString listloc)
        void WantedDir(const VectorDouble dir)
        void setDirname(const string dirname)
        void WantedAxe(const VectorString listaxe)
        void Unwantedcmp(const VectorString listcmp)
        void Wantedcmp(const VectorString listcmp)
        ResultsContainerPtr execute() except +
    

    cdef cppclass StaticModePseudoPtr:

        StaticModePseudoPtr( StaticModePseudoPtr& )
        StaticModePseudoPtr( StaticModePseudoInstance* )
        StaticModePseudoInstance* get()

    cdef cppclass StaticModeInterfInstance:
        StaticModeInterfInstance()
        void setAllLoc()
        void setAllCmp()
        void setMassMatrix( const AssemblyMatrixDoublePtr& currentMatrix ) 
        void setStiffMatrix( const AssemblyMatrixDoublePtr& currentMatrix )
        void setLinearSolver( const LinearSolverPtr& currentSolver )
        void WantedGrno(const VectorString listloc)
        void Unwantedcmp(const VectorString listcmp)
        void Wantedcmp(const VectorString listcmp)
        void setShift(const double shift)
        void setNbmod(const int nb )
        ResultsContainerPtr execute() except +
    

    cdef cppclass StaticModeInterfPtr:

        StaticModeInterfPtr( StaticModeInterfPtr& )
        StaticModeInterfPtr( StaticModeInterfInstance* )
        StaticModeInterfInstance* get()


cdef class StaticModeDepl:

    cdef StaticModeDeplPtr* _cptr

    cdef set( self, StaticModeDeplPtr other )
    cdef StaticModeDeplPtr* getPtr( self )
    cdef StaticModeDeplInstance* getInstance( self )
    
cdef class StaticModeForc:

    cdef StaticModeForcPtr* _cptr

    cdef set( self, StaticModeForcPtr other )
    cdef StaticModeForcPtr* getPtr( self )
    cdef StaticModeForcInstance* getInstance( self )
    
cdef class StaticModePseudo:

    cdef StaticModePseudoPtr* _cptr

    cdef set( self, StaticModePseudoPtr other )
    cdef StaticModePseudoPtr* getPtr( self )
    cdef StaticModePseudoInstance* getInstance( self )

cdef class StaticModeInterf:

    cdef StaticModeInterfPtr* _cptr

    cdef set( self, StaticModeInterfPtr other )
    cdef StaticModeInterfPtr* getPtr( self )
    cdef StaticModeInterfInstance* getInstance( self )
