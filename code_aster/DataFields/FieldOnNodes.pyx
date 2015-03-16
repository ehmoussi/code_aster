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

from code_aster cimport libaster
from code_aster.libaster cimport INTEGER
from code_aster.Supervis.libCommandSyntax cimport CommandSyntax, resultNaming
from code_aster.Supervis.libFile cimport LogicalUnitFile

from code_aster.Supervis.libCommandSyntax import _F
from code_aster.Supervis.libFile import FileType, FileAccess


cdef class FieldOnNodesDouble:
    """Python wrapper on the C++ FieldOnNodes object"""

    def __cinit__( self, string name="" ):
        """Initialization: stores the pointer to the C++ object"""
        if len(name) > 0:
            self._cptr = new FieldOnNodesDoublePtr( new FieldOnNodesDoubleInstance( name ) )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, FieldOnNodesDoublePtr other ):
        """Point to an existing object"""
        self._cptr = new FieldOnNodesDoublePtr( other )

    cdef FieldOnNodesDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef FieldOnNodesDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance objet"""
        return self._cptr.get()

    def __getitem__( self, i ):
        """Return the value at the given index"""
        cdef double val = deref(self.getInstance())[i]
        return val

    def printMEDFile( self, string filename ):
        """Print the field using the MED format"""
        name = self.getInstance().getName()
        assert len(name.strip()) <= 8, \
            "TODO: field with name longer than 8 chars can not be directly printed"

        syntax = CommandSyntax( "IMPR_RESU" )
        medFile = LogicalUnitFile( filename, FileType.Binary, FileAccess.New )
        syntax.define( _F( FORMAT="MED",
                           UNITE=medFile.getLogicalUnit(),
                           RESU=_F( CHAM_GD=name,
                                    INFO_MAILLAGE="NON",
                                    IMPR_NOM_VARI="NON", ), ), )
        cdef INTEGER numOp = 39
        libaster.execop_( & numOp )
        syntax.free()

    def debugPrint( self, logicalUnit = 6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )
