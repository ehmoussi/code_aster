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

from code_aster.Mesh.Mesh cimport MeshPtr

from PhysicsAndModeling cimport Physics, Modelings
from PhysicsAndModeling cimport cMechanics, cThermal, cAcoustics
from PhysicsAndModeling cimport cAxisymmetrical, cTridimensional, cPlanar, cDKT


cdef extern from "Modeling/Model.h":

    cdef cppclass ModelInstance:

        ModelInstance()
        void addModelingOnAllMesh( Physics phys, Modelings mod )
        void addModelingOnGroupOfElements( Physics phys, Modelings mod, string nameOfGroup )
        void addModelingOnGroupOfNodes( Physics phys, Modelings mod, string nameOfGroup )
        void setSplittingMethod()
        bint setSupportMesh( MeshPtr& currentMesh )
        MeshPtr getSupportMesh()
        string getEntity( int )
        string getEntityName( int )
        string getModeling( int )
        int getNumberOfModeling()
        string getPhysic( int )
        bint build() except +

    cdef cppclass ModelPtr:

        ModelPtr( ModelPtr& )
        ModelPtr( ModelInstance* )
        ModelInstance* get()


cdef class Model:

    cdef ModelPtr* _cptr

    cdef set( self, ModelPtr other )
    cdef ModelPtr* getPtr( self )
    cdef ModelInstance* getInstance( self )
