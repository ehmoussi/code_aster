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
from code_aster.Discretization.DOFNumbering cimport DOFNumberingPtr
from code_aster.Loads.PhysicalQuantity cimport PhysicalQuantityComponent

cdef extern from "LinearAlgebra/StructureInterface.h":

    ctypedef vector[string] VectorString
    ctypedef vector[PhysicalQuantityComponent] VectorComponent

    cpdef enum InterfaceTypeEnum:
        MacNeal, CraigBampton, HarmonicalCraigBampton, NoInterfaceType

    cdef cppclass StructureInterfaceInstance:

        StructureInterfaceInstance(DOFNumberingPtr)
        void addInterface(const string name, const InterfaceTypeEnum typ,
                          const VectorString groupsOfNodes,
                          const VectorComponent components)
        bint build()

    cdef cppclass StructureInterfacePtr:

        StructureInterfacePtr(StructureInterfacePtr&)
        StructureInterfacePtr(StructureInterfaceInstance*)
        StructureInterfaceInstance* get()

#### StructureInterface

cdef class StructureInterface(DataStructure):

    cdef StructureInterfacePtr* _cptr

    cdef set(self, StructureInterfacePtr other)
    cdef StructureInterfacePtr* getPtr(self)
    cdef StructureInterfaceInstance* getInstance(self)
