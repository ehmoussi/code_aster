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
from code_aster.Interactions.ContactZone cimport GenericContactZone
from code_aster.Modeling.Model cimport Model

Coulomb, WithoutFriction = cCoulomb, cWithoutFriction
FixPoint, Newton = cFixPoint, cNewton
Auto, Controlled, WithoutGeometricUpdate = cAuto, cControlled, cWithoutGeometricUpdate
Dirichlet, WithoutPrecond = cDirichlet, cWithoutPrecond


cdef class DiscretizedContact(DataStructure):
    """Python wrapper on the C++ DiscretizedContact object"""

    def __cinit__(self, bint init=True):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new DiscretizedContactPtr(new DiscretizedContactInstance())

    def __dealloc__(self):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set(self, DiscretizedContactPtr other):
        """Point to an existing object"""
        self._cptr = new DiscretizedContactPtr(other)

    cdef DiscretizedContactPtr* getPtr(self):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DiscretizedContactInstance* getInstance(self):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addContactZone(self, GenericContactZone zone):
        """"""
        self.getInstance().addContactZone(deref(zone.getPtr()))

    def build(self):
        """"""
        return self.getInstance().build()

    def setModel(self, Model model):
        """"""
        self.getInstance().setModel(deref(model.getPtr()))

    def setGeometricResolutionAlgorithm(self, curAlgo):
        """"""
        self.getInstance().setGeometricResolutionAlgorithm(curAlgo)

    def setGeometricUpdate(self, curUp):
        """"""
        self.getInstance().setGeometricUpdate(curUp)

    def setMaximumNumberOfGeometricIteration(self, value):
        """"""
        self.getInstance().setMaximumNumberOfGeometricIteration(value)

    def setGeometricResidual(self, value):
        """"""
        self.getInstance().setGeometricResidual(value)

    def setNumberOfGeometricIteration(self, value):
        """"""
        self.getInstance().setNumberOfGeometricIteration(value)

    def setNormsSmooth(self, curBool):
        """"""
        self.getInstance().setNormsSmooth(curBool)

    def setNormsVerification(self, curBool):
        """"""
        self.getInstance().setNormsVerification(curBool)

    def setStopOnInterpenetrationDetection(self, curBool):
        """"""
        self.getInstance().setStopOnInterpenetrationDetection(curBool)

    def setContactAlgorithm(self, coef):
        """"""
        self.getInstance().setContactAlgorithm(coef)

    def enableContactMatrixSingularityDetection(self, value):
        """"""
        self.getInstance().enableContactMatrixSingularityDetection(value)

    def numberOfSolversForSchurComplement(self, value):
        """"""
        self.getInstance().numberOfSolversForSchurComplement(value)

    def setResidualForGcp(self, value):
        """"""
        self.getInstance().setResidualForGcp(value)

    def allowOutOfBoundLinearSearch(self, value):
        """"""
        self.getInstance().allowOutOfBoundLinearSearch(value)

    def setPreconditioning(self, value):
        """"""
        self.getInstance().setPreconditioning(value)

    def setThresholdOfPreconditioningActivation(self, value):
        """"""
        self.getInstance().setThresholdOfPreconditioningActivation(value)

    def setMaximumNumberOfPreconditioningIteration(self, value):
        """"""
        self.getInstance().setMaximumNumberOfPreconditioningIteration(value)

    def debugPrint(self, logicalUnit=6):
        """Print debug information of the content"""
        self.getInstance().debugPrint(logicalUnit)


cdef class ContinuousContact(DataStructure):
    """Python wrapper on the C++ ContinuousContact object"""

    def __cinit__(self, bint init=True):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new ContinuousContactPtr(new ContinuousContactInstance())

    def __dealloc__(self):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set(self, ContinuousContactPtr other):
        """Point to an existing object"""
        self._cptr = new ContinuousContactPtr(other)

    cdef ContinuousContactPtr* getPtr(self):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef ContinuousContactInstance* getInstance(self):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    #def addMasterGroupOfElements(self, nameOfGroup):
        #"""Add a modeling on all the mesh"""
        #self.getInstance().addMasterGroupOfElements(nameOfGroup)

    #def debugPrint(self, logicalUnit=6):
        #"""Print debug information of the content"""
        #self.getInstance().debugPrint(logicalUnit)


cdef class XfemContact(DataStructure):
    """Python wrapper on the C++ XfemContact object"""

    def __cinit__(self, bint init=True):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new XfemContactPtr(new XfemContactInstance())

    def __dealloc__(self):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set(self, XfemContactPtr other):
        """Point to an existing object"""
        self._cptr = new XfemContactPtr(other)

    cdef XfemContactPtr* getPtr(self):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef XfemContactInstance* getInstance(self):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    #def addMasterGroupOfElements(self, nameOfGroup):
        #"""Add a modeling on all the mesh"""
        #self.getInstance().addMasterGroupOfElements(nameOfGroup)

    #def debugPrint(self, logicalUnit=6):
        #"""Print debug information of the content"""
        #self.getInstance().debugPrint(logicalUnit)


cdef class UnilateralConnexion(DataStructure):
    """Python wrapper on the C++ UnilateralConnexion object"""

    def __cinit__(self, bint init=True):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new UnilateralConnexionPtr(new UnilateralConnexionInstance())

    def __dealloc__(self):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set(self, UnilateralConnexionPtr other):
        """Point to an existing object"""
        self._cptr = new UnilateralConnexionPtr(other)

    cdef UnilateralConnexionPtr* getPtr(self):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef UnilateralConnexionInstance* getInstance(self):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    #def addMasterGroupOfElements(self, nameOfGroup):
        #"""Add a modeling on all the mesh"""
        #self.getInstance().addMasterGroupOfElements(nameOfGroup)

    #def debugPrint(self, logicalUnit=6):
        #"""Print debug information of the content"""
        #self.getInstance().debugPrint(logicalUnit)
