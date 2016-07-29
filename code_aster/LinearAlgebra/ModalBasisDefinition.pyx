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
from cython.operator cimport dereference as deref

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.Results.MechanicalModeContainer cimport MechanicalModeContainer
from .LinearSolver cimport LinearSolver
from .StructureInterface cimport StructureInterface
from .AssemblyMatrix cimport AssemblyMatrixDouble, AssemblyMatrixComplex
from code_aster.Discretization.DOFNumbering cimport DOFNumbering


cdef class GenericModalBasis(DataStructure):
    """Python wrapper on the C++ GenericModalBasis Object"""

    def __cinit__(self):
        """Initialization: stores the pointer to the C++ object"""
        pass

    def __dealloc__(self):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set(self, GenericModalBasisPtr other):
        """Point to an existing object"""
        self._cptr = new GenericModalBasisPtr(other)

    cdef GenericModalBasisPtr* getPtr(self):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef GenericModalBasisInstance* getInstance(self):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def build(self):
        return self.getInstance().build()


cdef class StandardModalBasis(GenericModalBasis):
    """Python wrapper on the C++ StandardModalBasis Object"""

    def __cinit__(self, bint init = True):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = <GenericModalBasisPtr *>\
                new StandardModalBasisPtr(new StandardModalBasisInstance())

    #def setModalBasis(self, StructureInterface structInterf, VectorOfMechaMode vecOfMechaMode,
                      #vecOfInt):
        #return True
        #cdef VectorOfMechaModePtr val2
        #cdef MechanicalModeContainerPtr* tmp
        #if type(vecOfMechaMode) == list:
            #for cVal in vecOfMechaMode:
                #if isinstance(cVal, MechanicalModeContainer):
                    #tmp = cVal.getPtr()
                    #val2.push_back(deref(tmp))
            #(<StandardModalBasisInstance* >self.getInstance()).setModalBasis(deref(structInterf.getPtr()),
                                                                             #vecOfMechaMode,
                                                                             #vecOfInt)
        #else:
            #(<StandardModalBasisInstance* >self.getInstance()).setModalBasis(deref(structInterf.getPtr()),
                                                                             #[mechaMode], vecOfInt)
