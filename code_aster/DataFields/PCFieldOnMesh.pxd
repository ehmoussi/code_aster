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
from code_aster.Mesh.Mesh cimport MeshPtr


cdef extern from "DataFields/PCFieldOnMesh.h":

    cdef cppclass PCFieldOnMeshInstance[ ValueType ]:

        PCFieldOnMeshInstance( string name )
        bint updateValuePointers()
        bint setSupportMesh( MeshPtr& currentMesh )
        string getType()

    cdef cppclass PCFieldOnMeshPtrDouble:

        PCFieldOnMeshPtrDouble( PCFieldOnMeshPtrDouble& )
        PCFieldOnMeshPtrDouble( PCFieldOnMeshInstance[ double ]* )
        PCFieldOnMeshInstance[ double ]* get()

ctypedef PCFieldOnMeshInstance[ double ] PCFieldOnMeshInstanceDouble


cdef class PCFieldOnMeshDouble( DataStructure ):

    cdef PCFieldOnMeshPtrDouble* _cptr

    cdef set( self, PCFieldOnMeshPtrDouble other )
    cdef PCFieldOnMeshPtrDouble* getPtr( self )
    cdef PCFieldOnMeshInstanceDouble* getInstance( self )
