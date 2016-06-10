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
from code_aster.LinearAlgebra.LinearSolver cimport LinearSolverPtr


cdef extern from "NonLinear/NonLinearMethod.h":

    cpdef enum NonLinearMethodEnum:
        Newton, Implex, NewtonKrylov

    cpdef enum PredictionEnum:
       Tangente, Elastique, Extrapole, DeplCalcule

    cpdef enum MatrixEnum:
       MatriceTangente, MatriceElastique

    cdef cppclass NonLinearMethodInstance:

        NonLinearMethodInstance( NonLinearMethodEnum curNLMethod  )
        void setPrediction( PredictionEnum curPred )
        void setMatrix( MatrixEnum curMatrix )
        void forceStiffnessSymetry ( bint force )

    cdef cppclass NonLinearMethodPtr:

        NonLinearMethodPtr( NonLinearMethodPtr& )
        NonLinearMethodPtr( NonLinearMethodInstance* )
        NonLinearMethodInstance* get()

#### NonLinearMethod

cdef class NonLinearMethod( DataStructure ):

    cdef NonLinearMethodPtr* _cptr

    cdef set( self, NonLinearMethodPtr other )
    cdef NonLinearMethodPtr* getPtr( self )
    cdef NonLinearMethodInstance* getInstance( self )
