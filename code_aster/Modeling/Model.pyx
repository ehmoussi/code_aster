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
from cython.operator cimport dereference as deref

from code_aster.Mesh.Mesh cimport Mesh
from code_aster.Mesh.cMesh cimport MeshPtr

from code_aster.Supervis.libCommandSyntax cimport CommandSyntax, resultNaming

from cPhysicsAndModeling cimport Physics, Modelings

Mechanics, Thermal, Acoustics = cMechanics, cThermal, cAcoustics
Axisymmetrical, Tridimensional, Planar, DKT = cAxisymmetrical, cTridimensional, cPlanar, cDKT


cdef class Model:
    """Python wrapper on the C++ Model object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new ModelPtr( new ModelInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, ModelPtr other ):
        """Point to an existing object"""
        self._cptr = new ModelPtr( other )

    cdef ModelPtr* get( self ):
        """Return the pointer on the c++ object"""
        return self._cptr

    def addModelingOnAllMesh( self, phys, mod ):
        """Add a modeling on all the mesh"""
        self._cptr.get().addModelingOnAllMesh( phys, mod )

    def addModelingOnGroupOfElements( self, phys, mod, nameOfGroup ):
        """Add a modeling on a group of elements"""
        self._cptr.get().addModelingOnGroupOfElements( phys, mod, nameOfGroup )

    def addModelingOnGroupOfNodes( self, phys, mod, nameOfGroup ):
        """Add a modeling on a group of nodes"""
        self._cptr.get().addModelingOnGroupOfNodes( phys, mod, nameOfGroup )

    def setSupportMesh( self, Mesh mesh ):
        """Set the support mesh of the model"""
        return self._cptr.get().setSupportMesh( deref( mesh.get() ) )

    def getSupportMesh( self ):
        """Return the support mesh"""
        mesh = Mesh()
        mesh.set( self._cptr.get().getSupportMesh() )
        return mesh

    def build( self ):
        """Build the Model object"""
        syntax = CommandSyntax( "AFFE_MODELE" )
        # self._cptr.get().getType()
        syntax.setResult( resultNaming.getResultObjectName(), "MODELE" )

        dict = self._cptr.get().getCommandKeywords()
        syntax.define( dict )

        ret = self._cptr.get().build()
        syntax.free()
        ret = True
        return ret
