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


cdef extern from "Function/Function.h":

    ctypedef vector[ double] VectorDouble

    cdef cppclass FunctionInstance:
        FunctionInstance()
        void setParameterName( string name ) except +
        void setResultName( string name ) except +
        void setValues( const VectorDouble &absc, const VectorDouble &ord ) except +
        bint build() except +
        void debugPrint( int logicalUnit ) except +

    cdef cppclass FunctionPtr:

        FunctionPtr( FunctionPtr& )
        FunctionPtr( FunctionInstance* )
        FunctionInstance* get()


cdef class Function:

    cdef FunctionPtr* _cptr

    cdef set( self, FunctionPtr other )
    cdef FunctionPtr* getPtr( self )
    cdef FunctionInstance* getInstance( self )
