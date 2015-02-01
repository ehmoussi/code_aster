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

from cMesh cimport MeshInstance, MeshPtr

from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDouble

cimport code_aster.Supervis.libCommandSyntax as libCmd
from code_aster.Supervis.libCommandSyntax import _F


cdef class Mesh:
    """Python wrapper on the C++ Mesh object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new MeshPtr( new MeshInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, MeshPtr other ):
        """Point to an existing object"""
        self._cptr = new MeshPtr( other )

    cdef MeshPtr* get( self ):
        """Return the pointer on the c++ object"""
        return self._cptr

    def getCoordinates(self):
        """Return the coordinates as a FieldOnNodesDouble object"""
        coordinates = FieldOnNodesDouble()
        coordinates.set( self._cptr.get().getCoordinates() )
        return coordinates

    def hasGroupOfElements( self, string name ):
        """Tell if a group of elements exists in the mesh"""
        return self._cptr.get().hasGroupOfElements( name )

    def hasGroupOfNodes( self, string name ):
        """Tell if a group of nodes exists in the mesh"""
        return self._cptr.get().hasGroupOfNodes( name )

    def readMEDFile( self, string pathFichier ):
        """Read a MED file"""
        syntax = libCmd.CommandSyntax( "LIRE_MAILLAGE" )
        # self._cptr.get().getType()
        syntax.setResult( libCmd.getResultObjectName(), "MAILLAGE" )

        syntax.define( _F ( FORMAT="MED",
                            UNITE=20, #medFile.getLogicalUnit(),
                            VERI_MAIL=_F( VERIF="OUI",
                                          APLAT=1.e-3 ),
                          )
                     )

        # inst.ExecOperator( 1 )
        ret = self._cptr.get().readMEDFile( pathFichier )
        syntax.free()
        return ret
