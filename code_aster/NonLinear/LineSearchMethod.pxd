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

from code_aster.DataStructure.DataStructure cimport DataStructure


cdef extern from "NonLinear/LineSearchMethod.h":
    cpdef enum LineSearchEnum:
           Corde, Mixte, Pilotage

    cdef cppclass LineSearchMethodInstance:

        LineSearchMethodInstance( LineSearchEnum curMethod )
        void setMinimumRhoValue( double rhoMin )
        void setMaximumRhoValue( double rhoMax )
        void setExclRhoValue( double rhoExcl )
        void setMaximumNumberOfIterations( int nIterMax )
        void setRelativeTolerance( double reslin )

    cdef cppclass LineSearchMethodPtr:

        LineSearchMethodPtr( LineSearchMethodPtr& )
        LineSearchMethodPtr( LineSearchMethodInstance* )
        LineSearchMethodInstance* get()

#### LineSearchMethod

cdef class LineSearchMethod( DataStructure ):

    cdef LineSearchMethodPtr* _cptr

    cdef set( self, LineSearchMethodPtr other )
    cdef LineSearchMethodPtr* getPtr( self )
    cdef LineSearchMethodInstance* getInstance( self )
