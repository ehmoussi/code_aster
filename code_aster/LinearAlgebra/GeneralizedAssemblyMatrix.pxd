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


cdef extern from "LinearAlgebra/GeneralizedAssemblyMatrix.h":

    cdef cppclass GenericGeneralizedAssemblyMatrixInstance:

        GenericGeneralizedAssemblyMatrixInstance()
        string getName()
        string getType()
        void debugPrint(int logicalUnit) except +

    cdef cppclass GenericGeneralizedAssemblyMatrixPtr:

        GenericGeneralizedAssemblyMatrixPtr(GenericGeneralizedAssemblyMatrixPtr&)
        GenericGeneralizedAssemblyMatrixPtr(GenericGeneralizedAssemblyMatrixInstance*)
        GenericGeneralizedAssemblyMatrixInstance* get()

    cdef cppclass GeneralizedAssemblyMatrixDoubleInstance:

        GeneralizedAssemblyMatrixDoubleInstance()

    cdef cppclass GeneralizedAssemblyMatrixDoublePtr:

        GeneralizedAssemblyMatrixDoublePtr(GeneralizedAssemblyMatrixDoublePtr&)
        GeneralizedAssemblyMatrixDoublePtr(GeneralizedAssemblyMatrixDoubleInstance*)
        GeneralizedAssemblyMatrixDoubleInstance* get()

    cdef cppclass GeneralizedAssemblyMatrixComplexInstance:

        GeneralizedAssemblyMatrixComplexInstance()

    cdef cppclass GeneralizedAssemblyMatrixComplexPtr:

        GeneralizedAssemblyMatrixComplexPtr(GeneralizedAssemblyMatrixComplexPtr&)
        GeneralizedAssemblyMatrixComplexPtr(GeneralizedAssemblyMatrixComplexInstance*)
        GeneralizedAssemblyMatrixComplexInstance* get()


cdef class GenericGeneralizedAssemblyMatrix(DataStructure):

    cdef GenericGeneralizedAssemblyMatrixPtr* _cptr

    cdef set(self, GenericGeneralizedAssemblyMatrixPtr other)
    cdef GenericGeneralizedAssemblyMatrixPtr* getPtr(self)
    cdef GenericGeneralizedAssemblyMatrixInstance* getInstance(self)


cdef class GeneralizedAssemblyMatrixDouble(GenericGeneralizedAssemblyMatrix):
    pass


cdef class GeneralizedAssemblyMatrixComplex(GenericGeneralizedAssemblyMatrix):
    pass
