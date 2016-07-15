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
from code_aster.Studies.StudyDescription cimport StudyDescriptionPtr
from code_aster.LinearAlgebra.ElementaryVector cimport ElementaryVectorPtr
from code_aster.LinearAlgebra.ElementaryMatrix cimport ElementaryMatrixPtr


cdef extern from "Discretization/DiscreteProblem.h":

    cdef cppclass DiscreteProblemInstance:

        DiscreteProblemInstance(StudyDescriptionPtr& model)
        ElementaryVectorPtr buildElementaryMechanicalLoadsVector()
        ElementaryMatrixPtr computeMechanicalRigidityMatrix()

    cdef cppclass DiscreteProblemPtr:

        DiscreteProblemPtr(DiscreteProblemPtr&)
        DiscreteProblemPtr(DiscreteProblemInstance *)
        DiscreteProblemInstance* get()


#### DiscreteProblem

cdef class DiscreteProblem(DataStructure):
    cdef DiscreteProblemPtr* _cptr
    cdef set(self, DiscreteProblemPtr other)
    cdef DiscreteProblemPtr* getPtr(self)
    cdef DiscreteProblemInstance* getInstance(self)
