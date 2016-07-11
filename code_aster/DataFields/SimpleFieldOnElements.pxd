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

from code_aster.DataStructure.DataStructure cimport DataStructure


cdef extern from "DataFields/SimpleFieldOnElements.h":

    cdef cppclass SimpleFieldOnElementsInstance[ ValueType ]:

        SimpleFieldOnElementsInstance( string name )
        ValueType& operator[]( int i )
        const ValueType& getValue( int nodeNumber, int compNumber )
        bint updateValuePointers()
        void debugPrint( int logicalUnit )

    cdef cppclass SimpleFieldOnElementsDoublePtr:

        SimpleFieldOnElementsDoublePtr( SimpleFieldOnElementsDoublePtr& )
        SimpleFieldOnElementsDoublePtr( SimpleFieldOnElementsInstance[ double ]* )
        SimpleFieldOnElementsInstance[ double ]* get()

ctypedef SimpleFieldOnElementsInstance[ double ] SimpleFieldOnElementsDoubleInstance


cdef class SimpleFieldOnElementsDouble( DataStructure ):

    cdef SimpleFieldOnElementsDoublePtr* _cptr

    cdef set( self, SimpleFieldOnElementsDoublePtr other )
    cdef SimpleFieldOnElementsDoublePtr* getPtr( self )
    cdef SimpleFieldOnElementsDoubleInstance* getInstance( self )
