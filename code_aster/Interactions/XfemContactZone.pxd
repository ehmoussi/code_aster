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
from code_aster.Function.Function cimport FunctionPtr
from .ContactZone cimport FrictionAlgorithmEnum, ContactAlgorithmEnum, IntegrationAlgorithmEnum
from .ContactZone cimport GenericContactZone, GenericContactZoneInstance, GenericContactZonePtr
from code_aster.Modeling.XfemCrack cimport XfemCrackPtr


cdef extern from "Interactions/XfemContactZone.h":

    cdef enum LagrangeAlgorithmEnum:
        cAutomaticLagrangeAlgorithm "AutomaticLagrangeAlgorithm"
        cNoLagrangeAlgorithm "NoLagrangeAlgorithm"
        cV1LagrangeAlgorithm "V1LagrangeAlgorithm"
        cV2LagrangeAlgorithm "V2LagrangeAlgorithm"
        cV3LagrangeAlgorithm "V3LagrangeAlgorithm"

    cdef enum CzmAlgorithmEnum:
        cCzmExpReg "CzmExpReg"
        cCzmLinReg "CzmLinReg"
        cCzmTacMix "CzmTacMix"
        cCzmOuvMix "CzmOuvMix"
        cCzmLinMix "CzmLinMix"

    cdef cppclass XfemContactZoneInstance(GenericContactZoneInstance):

        XfemContactZoneInstance()
        void addFriction(const FrictionAlgorithmEnum& algoFrot, const double& coulomb,
                         const double& seuilInit, const double& coefFrot)
        void disableSlidingContact()
        void enableSlidingContact()
        void setContactAlgorithm(const ContactAlgorithmEnum& cont)
        void setContactParameter(const double& value)
        void setInitialContact(const bint& contactInit)
        void setLagrangeAlgorithm(const LagrangeAlgorithmEnum& lagr)
        void setIntegrationAlgorithm(const IntegrationAlgorithmEnum& integr,
                                     const int& ordre)
        void setPairingMismatchProjectionTolerance(const double& value)
        void setXfemCrack(const XfemCrackPtr& crack)

    cdef cppclass XfemContactZonePtr:

        XfemContactZonePtr(XfemContactZonePtr&)
        XfemContactZonePtr(XfemContactZoneInstance*)
        XfemContactZoneInstance* get()


cdef class XfemContactZone(GenericContactZone):
    pass
