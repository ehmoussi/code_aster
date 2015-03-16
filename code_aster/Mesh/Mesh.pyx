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

import tempfile

from libcpp.string cimport string
from cython.operator cimport dereference as deref

from code_aster cimport libaster
from code_aster.libaster cimport INTEGER
from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDouble
from code_aster.Supervis.libFile cimport LogicalUnitFile

from code_aster.Supervis.libCommandSyntax cimport CommandSyntax, resultNaming

from code_aster.Supervis.libCommandSyntax import _F
from code_aster.Supervis.libFile import FileType, FileAccess


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

    cdef MeshPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef MeshInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def getCoordinates(self):
        """Return the coordinates as a FieldOnNodesDouble object"""
        coordinates = FieldOnNodesDouble()
        coordinates.set( self.getInstance().getCoordinates() )
        return coordinates

    def hasGroupOfElements( self, string name ):
        """Tell if a group of elements exists in the mesh"""
        return self.getInstance().hasGroupOfElements( name )

    def hasGroupOfNodes( self, string name ):
        """Tell if a group of nodes exists in the mesh"""
        return self.getInstance().hasGroupOfNodes( name )

    def readGibiFile( self, string filename ):
        """Read a Gibi mesh file"""
        assert self.getInstance().isEmpty(), "The mesh is already filled!"
        tmpfile = tempfile.NamedTemporaryFile( dir='.' ).name

        gibiFile = LogicalUnitFile( filename, FileType.Ascii, FileAccess.Old )
        mailAsterFile = LogicalUnitFile( tmpfile, FileType.Ascii, FileAccess.New )

        syntax = CommandSyntax( "PRE_GIBI" )
        """ Add logical units """
        syntax.define( _F ( UNITE_GIBI=gibiFile.getLogicalUnit(),
                       UNITE_MAILLAGE=mailAsterFile.getLogicalUnit() )
                      )
        cdef INTEGER numOp = 49
        libaster.execop_( &numOp )
        syntax.free()

        """Read a Aster mesh file"""
        syntax = CommandSyntax( "LIRE_MAILLAGE" )

        syntax.setResult( resultNaming.getResultObjectName(), "MAILLAGE" )

        syntax.define( _F ( FORMAT="ASTER",
                            UNITE=mailAsterFile.getLogicalUnit(),
                          )
                     )
        numOp = 1
        libaster.execop_( &numOp )
        ret = self.getInstance().build()
        syntax.free()
        return ret

    def readGmshFile( self, string filename ):
        """Read a Gmsh mesh file"""
        assert self.getInstance().isEmpty(), "The mesh is already filled!"
        tmpfile = tempfile.NamedTemporaryFile( dir='.' ).name

        gmshFile = LogicalUnitFile( filename, FileType.Ascii, FileAccess.Old )
        mailAsterFile = LogicalUnitFile( tmpfile, FileType.Ascii, FileAccess.New )

        syntax = CommandSyntax( "PRE_GMSH" )
        syntax.define( _F ( UNITE_GMSH=gmshFile.getLogicalUnit(),
                            UNITE_MAILLAGE=mailAsterFile.getLogicalUnit() )
                      )
        cdef INTEGER numOp = 47
        libaster.execop_( &numOp )
        syntax.free()

        # read a Aster mesh file
        syntax = CommandSyntax( "LIRE_MAILLAGE" )

        syntax.setResult( resultNaming.getResultObjectName(), "MAILLAGE" )

        syntax.define( _F ( FORMAT="ASTER",
                            UNITE=mailAsterFile.getLogicalUnit(), ),
                     )
        numOp = 1
        libaster.execop_( &numOp )
        ret = self.getInstance().build()
        syntax.free()
        return ret

    def readMedFile( self, string filename ):
        """Read a MED Mesh file"""
        assert self.getInstance().isEmpty(), "The mesh is already filled!"
        medFile = LogicalUnitFile( filename, FileType.Binary, FileAccess.Old )

        syntax = CommandSyntax( "LIRE_MAILLAGE" )
        curDict = _F ( FORMAT="MED",
                       UNITE=medFile.getLogicalUnit(), )

        # self.getInstance().getType()
        syntax.setResult( resultNaming.getResultObjectName(), "MAILLAGE" )

        syntax.define( curDict )
        cdef INTEGER numOp = 1
        libaster.execop_( &numOp )
        ret = self.getInstance().build()
        syntax.free()
        return ret

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )
