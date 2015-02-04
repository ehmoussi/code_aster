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

from code_aster cimport libaster
from code_aster.libaster cimport INTEGER
from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDouble
from code_aster.RunManager.File cimport File
from code_aster.Supervis.libCommandSyntax cimport CommandSyntax, resultNaming

from code_aster.Supervis.libCommandSyntax import _F
from code_aster.RunManager.File import FileType, FileAccess


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
 
    def readGibiMesh ( self, string filename ):
        """Read a Gibi mesh file"""

        gibiFile = File( filename, FileType.Ascii, FileAccess.Old )
        mailAsterFile = File( "/tmp/tmp_maillage_aster", FileType.Ascii, FileAccess.New )
        
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
                            VERI_MAIL=_F( VERIF="OUI",
                                          APLAT=1.e-3 ),
                          )
                     )
        numOp = 1
        libaster.execop_( &numOp )
        ret = self._cptr.get().readMeshFile()
        syntax.free()
        return ret
     
    def readGmshMesh ( self, string filename ):
        """Read a Gmsh mesh file"""

        gmshFile = File( filename, FileType.Ascii, FileAccess.Old )
        mailAsterFile = File( "/tmp/tmp_maillage_aster", FileType.Ascii, FileAccess.New )
        
        syntax = CommandSyntax( "PRE_GMSH" ) 
        """ Add logical units """
        syntax.define( _F ( UNITE_GMSH=gmshFile.getLogicalUnit(),
                            UNITE_MAILLAGE=mailAsterFile.getLogicalUnit() )
                      )
        cdef INTEGER numOp = 47
        libaster.execop_( &numOp )
        syntax.free() 

        """Read a Aster mesh file"""                     
        syntax = CommandSyntax( "LIRE_MAILLAGE" ) 
        
        syntax.setResult( resultNaming.getResultObjectName(), "MAILLAGE" )
                    
        syntax.define( _F ( FORMAT="ASTER",
                            UNITE=mailAsterFile.getLogicalUnit(),
                            VERI_MAIL=_F( VERIF="OUI",
                                          APLAT=1.e-3 ),
                          )
                     )
        numOp = 1
        libaster.execop_( &numOp )
        ret = self._cptr.get().readMeshFile()
        syntax.free()
        return ret


 
    def readMedMesh( self, string filename ):
        """Read a MED Mesh file"""
        medFile = File( filename, FileType.Binary, FileAccess.Old )

        syntax = CommandSyntax( "LIRE_MAILLAGE" )
        # self._cptr.get().getType()
        syntax.setResult( resultNaming.getResultObjectName(), "MAILLAGE" )

        syntax.define( _F ( FORMAT="MED",
                            UNITE=medFile.getLogicalUnit(),
                            VERI_MAIL=_F( VERIF="OUI",
                                          APLAT=1.e-3 ),
                          )
                     )
        cdef INTEGER numOp = 1
        libaster.execop_( &numOp )
        ret = self._cptr.get().readMeshFile()
        syntax.free()
        return ret

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self._cptr.get().debugPrint( logicalUnit )
