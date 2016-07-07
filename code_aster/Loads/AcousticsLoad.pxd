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
from libcpp.vector cimport vector

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.Modeling.Model cimport ModelPtr
from .PhysicalQuantity cimport PhysicalQuantityComponent


cdef extern from "Loads/AcousticsLoad.h":

    ctypedef vector[string] VectorString
    ctypedef vector[PhysicalQuantityComponent] VectorComponent

    cdef cppclass AcousticsLoadInstance:

        AcousticsLoadInstance()
        void addImposedNormalSpeedOnAllMesh(const complex speed)
        void addImposedNormalSpeedOnGroupsOfElements(const VectorString names,
                                                     const complex speed)
        void addImpedanceOnAllMesh(const complex impe)
        void addImpedanceOnGroupsOfElements(const VectorString names,
                                            const complex impe)
        void addImposedPressureOnAllMesh(const complex pres)
        void addImposedPressureOnGroupsOfElements(const VectorString names,
                                                  const complex pres)
        void addImposedPressureOnGroupsOfNodes(const VectorString names,
                                               const complex pres)
        void addUniformConnectionOnGroupsOfElements(const VectorString names,
                                                    const VectorComponent val)
        void addUniformConnectionOnGroupsOfNodes(const VectorString names,
                                                 const VectorComponent val)
        bint build() except +
        void debugPrint(int logicalUnit)
        bint setSupportModel(ModelPtr& currentModel)

    cdef cppclass AcousticsLoadPtr:

        AcousticsLoadPtr(AcousticsLoadPtr&)
        AcousticsLoadPtr(AcousticsLoadInstance *)
        AcousticsLoadInstance* get()


cdef class AcousticsLoad(DataStructure):
    cdef AcousticsLoadPtr* _cptr
    cdef set(self, AcousticsLoadPtr other)
    cdef AcousticsLoadPtr* getPtr(self)
    cdef AcousticsLoadInstance* getInstance(self)
