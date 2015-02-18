# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
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

from code_aster.Modeling.Model cimport ModelPtr
from PhysicalQuantity cimport AsterCoordinates


cdef extern from "Loads/KinematicsLoad.h":

    cdef cppclass KinematicsLoadInstance:

        KinematicsLoadInstance()
        void addImposedMechanicalDOFOnElements( AsterCoordinates coordinate, double value, string nameOfGroup )
        void addImposedMechanicalDOFOnNodes( AsterCoordinates coordinate, double value, string nameOfGroup )
        void addImposedThermalDOFOnElements( AsterCoordinates coordinate, double value, string nameOfGroup )
        void addImposedThermalDOFOnNodes( AsterCoordinates coordinate, double value, string nameOfGroup )
        bint build() except +
        void debugPrint( int logicalUnit )
        const string getType()
        bint setSupportModel( ModelPtr& currentModel )

    cdef cppclass KinematicsLoadPtr:

        KinematicsLoadPtr( KinematicsLoadPtr& )
        KinematicsLoadPtr( KinematicsLoadInstance* )
        KinematicsLoadInstance* get()


cdef class KinematicsLoad:

    cdef KinematicsLoadPtr* _cptr

    cdef KinematicsLoadPtr* getPtr( self )
    cdef KinematicsLoadInstance* getInstance( self )
    cdef set( self, KinematicsLoadPtr other )
