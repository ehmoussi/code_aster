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

#from code_aster.Mesh.Mesh cimport MeshPtr


cdef extern from "Interaction/ContactZone.h":

    cdef cppclass ContactZoneInstance:

        ContactZoneInstance()
        void addMasterGroupOfElements( string nameOfGroup ) except +
        void addSlaveGroupOfElements( string nameOfGroup ) except +
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
