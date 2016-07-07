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

from cython.operator cimport dereference as deref

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.Modeling.Model cimport Model


cdef class AcousticsLoad(DataStructure):
    """Python wrapper on the C++ GenericAcousticsLoad object"""

    def __cinit__(self, bint init=True):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new AcousticsLoadPtr(new AcousticsLoadInstance())

    def __dealloc__(self):
        """Destructor"""
        # subclassing, see https://github.com/cython/cython/wiki/WrappingSetOfCppClasses
        cdef AcousticsLoadPtr* tmp
        if self._cptr is not NULL:
            tmp = <AcousticsLoadPtr *>self._cptr
            del tmp
            self._cptr = NULL

    cdef set(self, AcousticsLoadPtr other):
        """Point to an existing object"""
        # set must be subclassed if it is necessary
        self._cptr = new AcousticsLoadPtr(other)

    cdef AcousticsLoadPtr* getPtr(self):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef AcousticsLoadInstance* getInstance(self):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addImposedNormalSpeedOnAllMesh(self, complex speed):
        """"""
        self.getInstance().addImposedNormalSpeedOnAllMesh(speed)

    def addImposedNormalSpeedOnGroupsOfElements(self, names, complex speed):
        """"""
        self.getInstance().addImposedNormalSpeedOnGroupsOfElements(names, speed)

    def addImpedanceOnAllMesh(self, complex impe):
        """"""
        self.getInstance().addImpedanceOnAllMesh(impe)

    def addImpedanceOnGroupsOfElements(self, names, complex impe):
        """"""
        self.getInstance().addImpedanceOnGroupsOfElements(names, impe)

    def addImposedPressureOnAllMesh(self, complex pres):
        """"""
        self.getInstance().addImposedPressureOnAllMesh(pres)

    def addImposedPressureOnGroupsOfElements(self, names, complex pres):
        """"""
        self.getInstance().addImposedPressureOnGroupsOfElements(names, pres)

    def addImposedPressureOnGroupsOfNodes(self, names, complex pres):
        """"""
        self.getInstance().addImposedPressureOnGroupsOfNodes(names, pres)

    def addUniformConnectionOnGroupsOfElements(self, names, val):
        """"""
        cdef VectorComponent val2
        for cVal in val:
            val2.push_back(cVal)
        self.getInstance().addUniformConnectionOnGroupsOfElements(names, val2)

    def addUniformConnectionOnGroupsOfNodes(self, names, val):
        """"""
        cdef VectorComponent val2
        for cVal in val:
            val2.push_back(cVal)
        self.getInstance().addUniformConnectionOnGroupsOfNodes(names, val2)

    def build(self):
        """"""
        self.getInstance().build()

    def debugPrint(self, logicalUnit=6):
        """Print debug information of the content"""
        self.getInstance().debugPrint(logicalUnit)

    def setSupportModel(self, Model model):
        """"""
        self.getInstance().setSupportModel(deref(model.getPtr()))
