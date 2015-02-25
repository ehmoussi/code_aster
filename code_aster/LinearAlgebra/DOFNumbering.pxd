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
from code_aster.Modeling.Model cimport ModelPtr
from code_aster.LinearAlgebra.ElementaryMatrix cimport ElementaryMatrixPtr
from code_aster.LinearAlgebra.LinearSolver cimport LinearSolverPtr
from code_aster.Loads.MechanicalLoad cimport GenericMechanicalLoadPtr


cdef extern from "LinearAlgebra/DOFNumbering.h":

    cdef cppclass DOFNumberingInstance:

        DOFNumberingInstance()
        void addLoad( GenericMechanicalLoadPtr& load )
        bint computeNumerotation()
        void setElementaryMatrix( ElementaryMatrixPtr& curElemMat )
        void setLinearSolver( LinearSolverPtr& curLinSolv )
        void setSupportModel( ModelPtr& curModel )
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass DOFNumberingPtr:

        DOFNumberingPtr( DOFNumberingPtr& )
        DOFNumberingPtr( DOFNumberingInstance* )
        DOFNumberingInstance* get()

#### DOFNumbering

cdef class DOFNumbering:

    cdef DOFNumberingPtr* _cptr

    cdef set( self, DOFNumberingPtr other )
    cdef DOFNumberingPtr* getPtr( self )
    cdef DOFNumberingInstance* getInstance( self )
