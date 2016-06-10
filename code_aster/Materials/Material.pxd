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
from code_aster.Materials.MaterialBehaviour cimport GeneralMaterialBehaviourPtr


cdef extern from "Materials/Material.h":

    cdef cppclass MaterialInstance:

        MaterialInstance()
        string getType()
        void addMaterialBehaviour(GeneralMaterialBehaviourPtr& curMaterBehav) except +
        bint build() except +
        void debugPrint( int logicalUnit ) except +

    cdef cppclass MaterialPtr:

        MaterialPtr( MaterialPtr& )
        MaterialPtr( MaterialInstance* )
        MaterialInstance* get()


cdef class Material( DataStructure ):

    cdef MaterialPtr* _cptr

    cdef set( self, MaterialPtr other )
    cdef MaterialPtr* getPtr( self )
    cdef MaterialInstance* getInstance( self )
