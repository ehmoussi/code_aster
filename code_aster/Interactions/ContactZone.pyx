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
from code_aster.Function.Function cimport Function


MasterNorm, SlaveNorm, AverageNorm = cMasterNorm, cSlaveNorm, cAverageNorm


cdef class GenericContactZone:
    """Python wrapper on the C++ GenericContactZone object"""

    def __cinit__(self):
        """Initialization: stores the pointer to the C++ object"""
        pass

    def __dealloc__(self):
        """Destructor"""
        # subclassing, see https://github.com/cython/cython/wiki/WrappingSetOfCppClasses
        cdef GenericContactZonePtr* tmp
        if self._cptr is not NULL:
            tmp = <GenericContactZonePtr *>self._cptr
            del tmp
            self._cptr = NULL

    cdef set(self, GenericContactZonePtr other):
        """Point to an existing object"""
        # set must be subclassed if it is necessary
        self._cptr = new GenericContactZonePtr(other)

    cdef GenericContactZonePtr* getPtr(self):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef GenericContactZoneInstance* getInstance(self):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()


cdef class DiscretizedContactZone(GenericContactZone):
    """Python wrapper on the C++ DiscretizedContactZone object"""

    def __cinit__(self, bint init=True):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericContactZonePtr *>\
                new DiscretizedContactZonePtr(new DiscretizedContactZoneInstance())

    def __dealloc__(self):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    def addBeamDescription(self):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).addBeamDescription()

    def addFriction(self, double coulomb, double eT, double coefMatrFrot):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).addFriction(coulomb, eT, coefMatrFrot)

    def addPlateDescription(self):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).addPlateDescription()

    def addMasterGroupOfElements(self, nameOfGroup):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).addMasterGroupOfElements(nameOfGroup)

    def addSlaveGroupOfElements(self, nameOfGroup):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).addSlaveGroupOfElements(nameOfGroup)

    def disableResolution(self, tolInterp = 0.):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).disableResolution(tolInterp)

    def disableSlidingContact(self):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).disableSlidingContact()

    def enableBilateralContact(self, double gap):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).enableBilateralContact(gap)

    def enableSlidingContact(self):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).enableSlidingContact()

    def excludeGroupOfElementsFromSlave(self, name):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).excludeGroupOfElementsFromSlave(name)

    def excludeGroupOfNodesFromSlave(self, name):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).excludeGroupOfNodesFromSlave(name)

    def setContactAlgorithm(self, absc):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).setContactAlgorithm(absc)

    def setFixMasterVector(self, absc):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).setFixMasterVector(absc)

    def setMasterDistanceFunction(self, Function func):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).setMasterDistanceFunction(deref(func.getPtr()))

    def setPairingMismatchProjectionTolerance(self, double value):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).setPairingMismatchProjectionTolerance(value)

    def setPairingVector(self, absc):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).setPairingVector(absc)

    def setSlaveDistanceFunction(self, Function func):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).setSlaveDistanceFunction(deref(func.getPtr()))

    def setTangentMasterVector(self, absc):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).setTangentMasterVector(absc)

    def setNormType(self, normType):
        """"""
        (<DiscretizedContactZoneInstance* >self.getInstance()).setNormType(normType)


cdef class ContinuousContactZone(GenericContactZone):
    """Python wrapper on the C++ ContinuousContactZone object"""

    def __cinit__(self, bint init=True):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericContactZonePtr *>\
                new ContinuousContactZonePtr(new ContinuousContactZoneInstance())

    def __dealloc__(self):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    def addBeamDescription(self):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).addBeamDescription()

    def addFriction(self, algoFrot, double coulomb, double eT, double coefMatrFrot):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).addFriction(algoFrot, coulomb, eT, coefMatrFrot)

    def addPlateDescription(self):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).addPlateDescription()

    def addMasterGroupOfElements(self, nameOfGroup):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).addMasterGroupOfElements(nameOfGroup)

    def addSlaveGroupOfElements(self, nameOfGroup):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).addSlaveGroupOfElements(nameOfGroup)

    def disableResolution(self, tolInterp = 0.):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).disableResolution(tolInterp)

    def disableSlidingContact(self):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).disableSlidingContact()

    def enableBilateralContact(self, double gap):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).enableBilateralContact(gap)

    def enableSlidingContact(self):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).enableSlidingContact()

    def excludeGroupOfElementsFromSlave(self, name):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).excludeGroupOfElementsFromSlave(name)

    def excludeGroupOfNodesFromSlave(self, name):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).excludeGroupOfNodesFromSlave(name)

    def setContactAlgorithm(self, absc):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).setContactAlgorithm(absc)

    def setContactParameter(self, double value):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).setContactParameter(value)

    def setFixMasterVector(self, absc):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).setFixMasterVector(absc)

    def setIntegrationAlgorithm(self, integr, ordre):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).setIntegrationAlgorithm(integr, ordre)

    def setMasterDistanceFunction(self, Function func):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).setMasterDistanceFunction(deref(func.getPtr()))

    def setPairingMismatchProjectionTolerance(self, double value):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).setPairingMismatchProjectionTolerance(value)

    def setPairingVector(self, absc):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).setPairingVector(absc)

    def setSlaveDistanceFunction(self, Function func):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).setSlaveDistanceFunction(deref(func.getPtr()))

    def setTangentMasterVector(self, absc):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).setTangentMasterVector(absc)

    def setNormType(self, normType):
        """"""
        (<ContinuousContactZoneInstance* >self.getInstance()).setNormType(normType)
