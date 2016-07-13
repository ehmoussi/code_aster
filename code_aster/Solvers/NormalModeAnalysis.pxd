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

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.LinearAlgebra.AssemblyMatrix cimport AssemblyMatrixDoublePtr
from code_aster.Results.MechanicalModeContainer cimport MechanicalModeContainerPtr


cdef extern from "Solvers/NormalModeAnalysis.h":

    cdef cppclass NormalModeAnalysisInstance:

        NormalModeAnalysisInstance()
        MechanicalModeContainerPtr execute()
        void setMassMatrix( const AssemblyMatrixDoublePtr matr )
        void setNumberOfFrequencies( const int number )
        void setRigidityMatrix( const AssemblyMatrixDoublePtr matr )

    cdef cppclass NormalModeAnalysisPtr:

        NormalModeAnalysisPtr( NormalModeAnalysisPtr& )
        NormalModeAnalysisPtr( NormalModeAnalysisInstance * )
        NormalModeAnalysisInstance* get()


#### NormalModeAnalysis

cdef class NormalModeAnalysis( DataStructure ):
    cdef NormalModeAnalysisPtr* _cptr
    cdef set( self, NormalModeAnalysisPtr other )
    cdef NormalModeAnalysisPtr* getPtr( self )
    cdef NormalModeAnalysisInstance* getInstance( self )
