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
from code_aster.Modeling.XfemCrack cimport XfemCrack


AutomaticLagrangeAlgorithm, NoLagrangeAlgorithm, V1LagrangeAlgorithm, V2LagrangeAlgorithm, V3LagrangeAlgorithm = cAutomaticLagrangeAlgorithm, cNoLagrangeAlgorithm, cV1LagrangeAlgorithm, cV2LagrangeAlgorithm, cV3LagrangeAlgorithm

CzmExpReg, CzmLinReg, CzmTacMix, CzmOuvMix, CzmLinMix = cCzmExpReg, cCzmLinReg, cCzmTacMix, cCzmOuvMix, cCzmLinMix


cdef class XfemContactZone(GenericContactZone):
    """Python wrapper on the C++ XfemContactZone object"""

    def __cinit__(self, bint init=True):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericContactZonePtr *>\
                new XfemContactZonePtr(new XfemContactZoneInstance())

    def __dealloc__(self):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    def addFriction(self, algoFrot, double coulomb, double eT, double coefMatrFrot):
        """"""
        (<XfemContactZoneInstance* >self.getInstance()).addFriction(algoFrot, coulomb, eT, coefMatrFrot)

    def disableSlidingContact(self):
        """"""
        (<XfemContactZoneInstance* >self.getInstance()).disableSlidingContact()

    def enableSlidingContact(self):
        """"""
        (<XfemContactZoneInstance* >self.getInstance()).enableSlidingContact()

    def setContactAlgorithm(self, absc):
        """"""
        (<XfemContactZoneInstance* >self.getInstance()).setContactAlgorithm(absc)

    def setContactParameter(self, double value):
        """"""
        (<XfemContactZoneInstance* >self.getInstance()).setContactParameter(value)

    def setInitialContact(self, value):
        """"""
        (<XfemContactZoneInstance* >self.getInstance()).setInitialContact(value)

    def setLagrangeAlgorithm(self, value):
        """"""
        (<XfemContactZoneInstance* >self.getInstance()).setLagrangeAlgorithm(value)

    def setIntegrationAlgorithm(self, integr, ordre = -1):
        """"""
        (<XfemContactZoneInstance* >self.getInstance()).setIntegrationAlgorithm(integr, ordre)

    def setPairingMismatchProjectionTolerance(self, double value):
        """"""
        (<XfemContactZoneInstance* >self.getInstance()).setPairingMismatchProjectionTolerance(value)

    def setXfemCrack(self, XfemCrack crack):
        """"""
        (<XfemContactZoneInstance* >self.getInstance()).setXfemCrack(deref(crack.getPtr()))

