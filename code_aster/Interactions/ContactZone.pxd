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

from code_aster.Function.Function cimport FunctionPtr


cdef extern from "Interactions/ContactZone.h":

    cdef enum NormTypeEnum:
        cMasterNorm "MasterNorm"
        cSlaveNorm "SlaveNorm"
        cAverageNorm "AverageNorm"

    ctypedef vector[ double] VectorDouble

    cdef cppclass ContactZoneInstance:

        ContactZoneInstance()
        void addBeamDescription() except +
        void addPlateDescription() except +
        void addMasterGroupOfElements(const string& nameOfGroup)
        void addSlaveGroupOfElements(const string& nameOfGroup)
        void disableResolution(const double& tolInterp)
        void excludeGroupOfElementsFromSlave(const string& name)
        void excludeGroupOfNodesFromSlave(const string& name)
        void setFixMasterVector(const VectorDouble& absc)
        void setMasterDistanceFunction(const FunctionPtr&)
        void setSlaveDistanceFunction(const FunctionPtr&)
        void setPairingVector(const VectorDouble& absc)
        void setTangentMasterVector(const VectorDouble& absc)
        void setNormType(const NormTypeEnum& normType)
        #void debugPrint( int logicalUnit )

    cdef cppclass ContactZonePtr:

        ContactZonePtr( ContactZonePtr& )
        ContactZonePtr( ContactZoneInstance* )
        ContactZoneInstance* get()


cdef class ContactZone:

    cdef ContactZonePtr* _cptr

    cdef set( self, ContactZonePtr other )
    cdef ContactZonePtr* getPtr( self )
    cdef ContactZoneInstance* getInstance( self )
