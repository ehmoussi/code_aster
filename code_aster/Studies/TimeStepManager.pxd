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
from libcpp.vector cimport vector

from code_aster.Studies.FailureConvergenceManager cimport GenericConvergenceErrorPtr


cdef extern from "Studies/TimeStepManager.h":
    ctypedef vector[ double] VectorDouble

    cdef cppclass TimeStepManagerInstance:

        TimeStepManagerInstance()
        void addErrorManager( const GenericConvergenceErrorPtr& currentError ) except +
        void build()
        void setAutomaticManagement( const int& isAuto )
        void setTimeList( const VectorDouble& timeList )
        void setTimeListFromResultsContainer()
        void debugPrint( int logicalUnit )

    cdef cppclass TimeStepManagerPtr:

        TimeStepManagerPtr( TimeStepManagerPtr& )
        TimeStepManagerPtr( TimeStepManagerInstance * )
        TimeStepManagerInstance* get()


#### TimeStepManager

cdef class TimeStepManager:
    cdef TimeStepManagerPtr* _cptr
    cdef set( self, TimeStepManagerPtr other )
    cdef TimeStepManagerPtr* getPtr( self )
    cdef TimeStepManagerInstance* getInstance( self )
