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

from code_aster.Supervis.libCommandSyntax cimport CommandSyntax

from code_aster.Supervis.libCommandSyntax import _F


cdef char* FileTypeName[3]
FileTypeName[0] = "ASCII"
FileTypeName[1] = "BINARY"
FileTypeName[2] = "LIBRE"

cdef char* FileAccessName[3]
FileAccessName[0] = "NEW"
FileAccessName[1] = "APPEND"
FileAccessName[2] = "OLD"


cdef class LogicalUnitManager:

    """This class manages the associations between the filenames and the
    logical units"""

    def __cinit__( self ):
        """Constructor"""
        # 1-18 considered as reserved
        self._freeLogicalUnit = set( range( 19, 100 ) )
        self._usedLogicalUnit = set()

    cdef int getFreeLogicalUnit( self ) except? 0:
        """Return a free logical unit"""
        cdef int unit = 0
        if len( self._freeLogicalUnit ) == 0:
            raise ValueError( "No more free logical unit" )
        unit = self._freeLogicalUnit.pop()
        self._usedLogicalUnit.add( unit )
        return unit

    cdef bint releaseLogicalUnit( self, const int unitToRelease ) except? False:
        """Release a logical unit"""
        "Unable to free this logical unit"
        cdef bint ok = False
        try:
            self._usedLogicalUnit.remove( unitToRelease )
        except KeyError:
            msg = "Unable to free the logical unit {}".format( unitToRelease )
            raise KeyError( msg )
        self._freeLogicalUnit.add( unitToRelease )
        return True

# global "singleton" instance
cdef LogicalUnitManager logicalUnitManager
logicalUnitManager = LogicalUnitManager()


cdef class File:

    """This class defines a file associated to a fortran logical unit"""

    def __cinit__( self, name, type, access ):
        """
        The constructor currently calls DEFI_FICHIER to reserve a logical unit
        @param fileName Path to the file
        @param type Type of file (Ascii, Binary, Free)
        @param access Type of access (New, Append, Old)
        """
        self._fileName = name
        self._type = type
        self._access = access
        self._logicalUnit = logicalUnitManager.getFreeLogicalUnit()
        self._numOp26 = 26

        syntax = CommandSyntax( "DEFI_FICHIER" )
        syntax.define( _F( ACTION="ASSOCIER",
                           UNITE=self._logicalUnit,
                           FICHIER=self._fileName,
                           TYPE=FileTypeName[ self._type ],
                           ACCES=FileAccessName[ self._access ],
                         )
                     )
        libaster.opsexe_( &self._numOp26 )
        syntax.free()

    def __dealloc__( self ):
        """Destructor
        Call DEFI_FICHIER to release the logical unit"""
        logicalUnitManager.releaseLogicalUnit( self._logicalUnit )

        syntax = CommandSyntax( "DEFI_FICHIER" )
        syntax.define( _F( ACTION="LIBERER",
                           UNITE=self._logicalUnit,
                           FICHIER=self._fileName,
                         )
                     )
        libaster.opsexe_( &self._numOp26 )
        syntax.free()

    cpdef int getLogicalUnit( self ):
        """Return the logical unit associated to this file"""
        return self._logicalUnit


# for unittests and Python usage
class FileType:
    Ascii = 0
    Binary = 1
    Free = 2


class FileAccess:
    New = 0
    Append = 1
    Old = 2


class _TestLogicalUnitManager:

    @staticmethod
    def getFreeLogicalUnit():
        return logicalUnitManager.getFreeLogicalUnit()

    @staticmethod
    def releaseLogicalUnit( unit ):
        return logicalUnitManager.releaseLogicalUnit( unit )
