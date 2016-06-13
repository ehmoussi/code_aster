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


cdef extern from "Interactions/ContactZone.h":

    cdef cppclass GenericContactZoneInstance:

        GenericContactZoneInstance()

    cdef cppclass GenericContactZonePtr:

        GenericContactZonePtr(GenericContactZonePtr&)
        GenericContactZonePtr(GenericContactZoneInstance *)
        GenericContactZoneInstance* get()

    cdef enum NormTypeEnum:
        cMasterNorm "MasterNorm"
        cSlaveNorm "SlaveNorm"
        cAverageNorm "AverageNorm"

    cdef enum ContactAlgorithmEnum:
        cConstraintContact "ConstraintContact"
        cPenalizationContact "PenalizationContact"
        cGcpContact "GcpContact"
        cStandardContact "StandardContact"
        cCzmContact "CzmContact"

    cdef enum FrictionAlgorithmEnum:
        cFrictionPenalization "FrictionPenalization"
        cStandardFriction "StandardFriction"

    cdef enum IntegrationAlgorithmEnum:
        cAutomaticIntegration "AutomaticIntegration"
        cGaussIntegration "GaussIntegration"
        cSimpsonIntegration "SimpsonIntegration"
        cNewtonCotesIntegration "NewtonCotesIntegration"
        cNodesIntegration "NodesIntegration"

    ctypedef vector[double] VectorDouble

    cdef cppclass DiscretizedContactZoneInstance(GenericContactZoneInstance):

        DiscretizedContactZoneInstance()
        void addBeamDescription() except +
        void addFriction(const double& coulomb, const double& eT, const double& coefMatrFrot)
        void addPlateDescription() except +
        void addMasterGroupOfElements(const string& nameOfGroup)
        void addSlaveGroupOfElements(const string& nameOfGroup)
        void disableResolution(const double& tolInterp)
        void disableSlidingContact()
        void enableBilateralContact(const double& gap)
        void enableSlidingContact()
        void excludeGroupOfElementsFromSlave(const string& name)
        void excludeGroupOfNodesFromSlave(const string& name)
        void setContactAlgorithm(const ContactAlgorithmEnum& cont)
        void setFixMasterVector(const VectorDouble& absc)
        void setMasterDistanceFunction(const FunctionPtr&)
        void setPairingMismatchProjectionTolerance(const double& value)
        void setPairingVector(const VectorDouble& absc)
        void setSlaveDistanceFunction(const FunctionPtr&)
        void setTangentMasterVector(const VectorDouble& absc)
        void setNormType(const NormTypeEnum& normType)

    cdef cppclass DiscretizedContactZonePtr:

        DiscretizedContactZonePtr(DiscretizedContactZonePtr&)
        DiscretizedContactZonePtr(DiscretizedContactZoneInstance*)
        DiscretizedContactZoneInstance* get()

    cdef cppclass ContinuousContactZoneInstance(GenericContactZoneInstance):

        ContinuousContactZoneInstance()
        void addBeamDescription() except +
        void addFriction(const FrictionAlgorithmEnum& algoFrot, const double& coulomb,
                         const double& seuilInit, const double& coefFrot)
        void addPlateDescription() except +
        void addMasterGroupOfElements(const string& nameOfGroup)
        void addSlaveGroupOfElements(const string& nameOfGroup)
        void disableResolution(const double& tolInterp)
        void disableSlidingContact()
        void enableBilateralContact(const double& gap)
        void enableSlidingContact()
        void excludeGroupOfElementsFromSlave(const string& name)
        void excludeGroupOfNodesFromSlave(const string& name)
        void setContactAlgorithm(const ContactAlgorithmEnum& cont)
        void setContactParameter(const double& value)
        void setFixMasterVector(const VectorDouble& absc)
        void setIntegrationAlgorithm(const IntegrationAlgorithmEnum& integr,
                                     const int& ordre)
        void setMasterDistanceFunction(const FunctionPtr&)
        void setPairingMismatchProjectionTolerance(const double& value)
        void setPairingVector(const VectorDouble& absc)
        void setSlaveDistanceFunction(const FunctionPtr&)
        void setTangentMasterVector(const VectorDouble& absc)
        void setNormType(const NormTypeEnum& normType)

    cdef cppclass ContinuousContactZonePtr:

        ContinuousContactZonePtr(ContinuousContactZonePtr&)
        ContinuousContactZonePtr(ContinuousContactZoneInstance*)
        ContinuousContactZoneInstance* get()

cdef class GenericContactZone(DataStructure):
    cdef GenericContactZonePtr* _cptr
    cdef set(self, GenericContactZonePtr other)
    cdef GenericContactZonePtr* getPtr(self)
    cdef GenericContactZoneInstance* getInstance(self)


cdef class DiscretizedContactZone(GenericContactZone):
    pass

cdef class ContinuousContactZone(GenericContactZone):
    pass
