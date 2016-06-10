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
from code_aster.Materials.Material cimport MaterialPtr


cdef extern from "Materials/MaterialOnMesh.h":

    cdef cppclass MaterialOnMeshInstance:

        MaterialOnMeshInstance()
        void addMaterialOnAllMesh( MaterialPtr& curMater )
        void addMaterialOnGroupOfElements( MaterialPtr& curMater,
                                           string nameOfGroup )
        bint setSupportMesh( MeshPtr& currentMesh )
        MeshPtr getSupportMesh()
        getCommandKeywords()
        bint build()
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass MaterialOnMeshPtr:

        MaterialOnMeshPtr( MaterialOnMeshPtr& )
        MaterialOnMeshPtr( MaterialOnMeshInstance* )
        MaterialOnMeshInstance* get()


cdef class MaterialOnMesh( DataStructure ):

    cdef MaterialOnMeshPtr* _cptr

    cdef set( self, MaterialOnMeshPtr other )
    cdef MaterialOnMeshPtr* getPtr( self )
    cdef MaterialOnMeshInstance* getInstance( self )
